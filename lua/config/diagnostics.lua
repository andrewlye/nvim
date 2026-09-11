-- Inline diagnostic text (virtual_text) is the noisiest display mode, so its
-- on/off state is persisted to disk and restored on the next launch. Toggling
-- only flips virtual_text -- signs, underline, and the hover float stay on, so
-- "off" means quiet, not blind. <leader>uD is the per-buffer kill switch for
-- everything (underline, signs, virtual text), e.g. pseudocode in a .py buffer.

local state_file = vim.fn.stdpath 'state' .. '/diag-virtual-text'

local function load_enabled()
  local f = io.open(state_file, 'r')
  if not f then
    return true
  end -- default: on
  local v = f:read 'l'
  f:close()
  return v ~= 'off'
end

local function save_enabled(enabled)
  local f = io.open(state_file, 'w')
  if f then
    f:write(enabled and 'on' or 'off')
    f:close()
  end
end

local enabled = load_enabled()

vim.diagnostic.config {
  virtual_text = enabled,
  underline = true,
  severity_sort = true,
  float = { border = 'rounded', source = true },
}

vim.keymap.set('n', '<leader>ud', function()
  enabled = not enabled
  vim.diagnostic.config { virtual_text = enabled } -- merges; leaves underline/float intact
  save_enabled(enabled)
  vim.notify('Inline diagnostics ' .. (enabled and 'enabled' or 'disabled'))
end, { desc = 'Toggle inline diagnostics' })

-- Hide *all* diagnostic display for the current buffer (underline/undercurl,
-- signs, virtual text). Session-only; the LSP keeps running and `<leader>q`,
-- Trouble, etc. still see the diagnostics.
vim.keymap.set('n', '<leader>uD', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local on = not vim.diagnostic.is_enabled { bufnr = bufnr }
  vim.diagnostic.enable(on, { bufnr = bufnr })
  vim.notify('Diagnostics ' .. (on and 'shown' or 'hidden') .. ' for this buffer')
end, { desc = 'Toggle all diagnostics (buffer)' })
