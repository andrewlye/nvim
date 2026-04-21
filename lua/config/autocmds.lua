vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd 'set laststatus=3'
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  desc = '<Esc><Esc> closes floating terminals (toggleterm, lazygit, etc.)',
  group = vim.api.nvim_create_augroup('float-term-esc', { clear = true }),
  callback = function(args)
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_config(win).relative == '' then return end
    vim.keymap.set('t', '<Esc><Esc>', function()
      vim.api.nvim_win_close(0, true)
    end, { buffer = args.buf, desc = 'Close floating terminal' })
  end,
})
