return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {},
  version = '^1.0.0',
  keys = {
    { '<S-l>', '<cmd>BufferNext<cr>', desc = 'Next buffer' },
    { '<S-h>', '<cmd>BufferPrevious<cr>', desc = 'Previous buffer' },
    { '<leader>bd', '<cmd>BufferClose<cr>', desc = 'Close buffer' },
  },
}
