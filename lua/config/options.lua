vim.g.autoformat = false
vim.b.autoformat = false

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = 'retab',
})

-- Vertical ruler one column past the line width. The width comes from 'textwidth'
-- when something has set it (a repo's .editorconfig max_line_length, or an
-- ftplugin such as ftplugin/python.lua reading ruff's line-length); otherwise the
-- ruler falls back to DEFAULT_RULER_WIDTH. Only 'colorcolumn' is touched here:
-- 'textwidth' itself stays 0 in the fallback case, so no auto-wrapping is added.
local DEFAULT_RULER_WIDTH = 100
local ruler = vim.api.nvim_create_augroup('ruler-follows-textwidth', { clear = true })
local function sync_ruler()
  local width = vim.bo.textwidth > 0 and vim.bo.textwidth or DEFAULT_RULER_WIDTH
  vim.opt_local.colorcolumn = tostring(width + 1)
end
vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, { group = ruler, callback = sync_ruler })
vim.api.nvim_create_autocmd('OptionSet', { group = ruler, pattern = 'textwidth', callback = sync_ruler })
