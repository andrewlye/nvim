return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      config = {
        week_header = { enable = true },
        shortcut = {},
        footer = {''}
      }
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
