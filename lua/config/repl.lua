-- Data-analysis REPL: drives an IPython session in a split pane of the
-- multiplexer nvim is running inside. Cells are `# %%` markers (jupytext
-- percent format); code is delivered as a bracketed paste. Figures render in
-- the pane via the matplotlib hook in tools/repl/profile/.
--
-- The backend is picked from the environment, not from which binaries exist:
-- $TMUX wins over $WEZTERM_PANE because tmux is the innermost multiplexer
-- (tmux inside WezTerm locally, or tmux on a remote host) and its splits
-- survive a detach. Outside both, the REPL keys report an error and do nothing.

local state = { pane = nil }

local launcher = vim.fn.stdpath('config') .. '/tools/repl/da'

local function run(cmd, input)
  local result = vim.system(cmd, { stdin = input }):wait()
  if result.code ~= 0 then
    local what = table.concat(vim.list_slice(cmd, 1, 3), ' ')
    vim.notify(what .. ' failed: ' .. (result.stderr or ''), vim.log.levels.ERROR)
    return nil
  end
  return result.stdout
end

-- A backend is: spawn(cwd) -> pane id with focus left in nvim, alive(id),
-- paste(id, text) as a bracketed paste, key(id, 'enter' | 'interrupt'),
-- kill(id). Pane ids are strings ("7" in WezTerm, "%7" in tmux).

local wezterm = {
  spawn = function(cwd)
    local out = run({
      'wezterm', 'cli', 'split-pane', '--right', '--percent', '40',
      '--cwd', cwd, '--', launcher,
    })
    if not out then return nil end
    run({ 'wezterm', 'cli', 'activate-pane', '--pane-id', vim.env.WEZTERM_PANE })
    return vim.trim(out)
  end,
  alive = function(id)
    local out = run({ 'wezterm', 'cli', 'list', '--format', 'json' })
    local ok, panes = pcall(vim.json.decode, out or '')
    if not ok then return false end
    for _, pane in ipairs(panes) do
      if tostring(pane.pane_id) == id then return true end
    end
    return false
  end,
  paste = function(id, text)
    run({ 'wezterm', 'cli', 'send-text', '--pane-id', id }, text)
  end,
  key = function(id, name)
    local raw = ({ enter = '\r', interrupt = '\x03' })[name]
    run({ 'wezterm', 'cli', 'send-text', '--pane-id', id, '--no-paste', raw })
  end,
  kill = function(id)
    run({ 'wezterm', 'cli', 'kill-pane', '--pane-id', id })
  end,
}

local tmux = {
  spawn = function(cwd)
    -- -d leaves focus in nvim; -p rather than -l 40% keeps tmux < 3.1 working
    local out = run({
      'tmux', 'split-window', '-h', '-d', '-p', '40', '-t', vim.env.TMUX_PANE,
      '-c', cwd, '-P', '-F', '#{pane_id}', vim.fn.shellescape(launcher),
    })
    return out and vim.trim(out) or nil
  end,
  alive = function(id)
    local out = run({ 'tmux', 'list-panes', '-a', '-F', '#{pane_id}' })
    for line in (out or ''):gmatch('[^\n]+') do
      if line == id then return true end
    end
    return false
  end,
  paste = function(id, text)
    -- load-buffer + paste-buffer -p is tmux's only real bracketed paste;
    -- send-keys -l would let IPython auto-indent every pasted line
    if run({ 'tmux', 'load-buffer', '-b', 'nvim-repl', '-' }, text) then
      run({ 'tmux', 'paste-buffer', '-p', '-d', '-b', 'nvim-repl', '-t', id })
    end
  end,
  key = function(id, name)
    run({ 'tmux', 'send-keys', '-t', id, ({ enter = 'Enter', interrupt = 'C-c' })[name] })
  end,
  kill = function(id)
    run({ 'tmux', 'kill-pane', '-t', id })
  end,
}

local backend = (vim.env.TMUX and vim.env.TMUX_PANE) and tmux
  or vim.env.WEZTERM_PANE and wezterm
  or nil

-- Returns the REPL's pane id, spawning it if needed; second value reports
-- whether it was freshly spawned (IPython won't be ready for input yet).
local function ensure_repl()
  if not backend then
    vim.notify('REPL needs nvim running inside tmux or WezTerm', vim.log.levels.ERROR)
    return nil
  end
  if state.pane and backend.alive(state.pane) then
    return state.pane, false
  end
  -- spawn in the current file's directory so sibling imports and relative
  -- paths resolve regardless of nvim's cwd; unnamed buffers fall back to cwd
  local name = vim.api.nvim_buf_get_name(0)
  local cwd = name ~= '' and vim.fs.dirname(name) or vim.fn.getcwd()
  if not vim.uv.fs_stat(cwd) then cwd = vim.fn.getcwd() end
  state.pane = backend.spawn(cwd)
  if not state.pane then return nil end
  return state.pane, true
end

local function send(text)
  local pane, fresh = ensure_repl()
  if not pane then return end
  if fresh then
    vim.notify('REPL starting — send again once the prompt is up', vim.log.levels.INFO)
    return
  end
  text = text:gsub('%s+$', '')
  if text == '' then return end
  -- the trailing newline matters: without it IPython treats a block ending
  -- on an indented line as incomplete and the Enter below opens a
  -- continuation line instead of executing
  backend.paste(pane, text .. '\n')
  backend.key(pane, 'enter')
end

local function is_marker(line)
  return line:match('^#%s*%%%%') ~= nil
end

-- 1-based inclusive line range of the cell under the cursor; text from the
-- top of the file to the first marker counts as a cell too.
local function cell_range()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local start = 1
  for i = row, 1, -1 do
    if is_marker(lines[i]) then
      start = i
      break
    end
  end
  local finish = #lines
  for i = row + 1, #lines do
    if is_marker(lines[i]) then
      finish = i - 1
      break
    end
  end
  return start, finish
end

local function jump_marker(dir)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local from, to = row + dir, dir > 0 and #lines or 1
  for i = from, to, dir do
    if is_marker(lines[i]) then
      vim.api.nvim_win_set_cursor(0, { i, 0 })
      return
    end
  end
end

local function send_cell()
  local start, finish = cell_range()
  local lines = vim.api.nvim_buf_get_lines(0, start - 1, finish, false)
  send(table.concat(lines, '\n'))
end

local function send_cell_and_next()
  send_cell()
  jump_marker(1)
end

local function send_line()
  send(vim.api.nvim_get_current_line())
end

local function send_file()
  send(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'))
end

local function send_selection()
  local text = table.concat(
    vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = vim.fn.mode() }),
    '\n'
  )
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  send(text)
end

local function interrupt()
  if state.pane and backend.alive(state.pane) then
    backend.key(state.pane, 'interrupt')
  end
end

local function close()
  if state.pane and backend.alive(state.pane) then
    backend.kill(state.pane)
  end
  state.pane = nil
end

local map = vim.keymap.set
map('n', '<leader>ro', ensure_repl, { desc = 'REPL: open' })
map('n', '<leader>rr', send_cell, { desc = 'REPL: run cell' })
map('n', '<leader>rj', send_cell_and_next, { desc = 'REPL: run cell, jump to next' })
map('x', '<leader>rr', send_selection, { desc = 'REPL: run selection' })
map('n', '<leader>rl', send_line, { desc = 'REPL: run line' })
map('n', '<leader>rf', send_file, { desc = 'REPL: run file' })
map('n', '<leader>ri', interrupt, { desc = 'REPL: interrupt' })
map('n', '<leader>rq', close, { desc = 'REPL: quit' })
map('n', ']r', function() jump_marker(1) end, { desc = 'Next cell' })
map('n', '[r', function() jump_marker(-1) end, { desc = 'Previous cell' })
