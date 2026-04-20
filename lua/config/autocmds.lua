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
