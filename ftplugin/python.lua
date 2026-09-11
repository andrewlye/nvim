-- 'textwidth' (and therefore the colorcolumn ruler) follows the repo's ruff
-- line-length when one is configured, defaulting to 88.

-- Read the `line-length` value from a ruff config file, scoped correctly:
--   * pyproject.toml -> only under the [tool.ruff] table
--   * ruff.toml / .ruff.toml -> the top-level key
local function line_length_from(file)
  local ok, lines = pcall(vim.fn.readfile, file)
  if not ok then
    return nil
  end
  local is_pyproject = file:match 'pyproject%.toml$' ~= nil
  local in_scope = not is_pyproject -- ruff.toml: top-level is in scope immediately
  for _, line in ipairs(lines) do
    local section = line:match '^%s*%[(.-)%]'
    if section then
      in_scope = is_pyproject and section == 'tool.ruff' or false
    elseif in_scope then
      local n = line:match '^%s*line%-length%s*=%s*(%d+)'
      if n then
        return tonumber(n)
      end
    end
  end
  return nil
end

local function ruff_line_length(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end
  -- nearest config wins, matching ruff's own upward resolution
  local found = vim.fs.find({ '.ruff.toml', 'ruff.toml', 'pyproject.toml' }, {
    upward = true,
    path = vim.fs.dirname(name),
    limit = math.huge,
  })
  for _, file in ipairs(found) do
    local n = line_length_from(file)
    if n then
      return n
    end
  end
  return nil
end

vim.opt_local.textwidth = ruff_line_length(0) or 88

-- Filetype-local keys (REPL keys are global in lua/config/repl.lua on purpose).
vim.keymap.set('n', '<localleader>d', function()
  require('neogen').generate()
end, { buffer = true, desc = 'Docstring: document this' })
