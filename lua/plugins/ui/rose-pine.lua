return {
  'rose-pine/neovim',
  name = 'rose-pine',
  lazy = false,
  priority = 1000,
  config = function()
    require('rose-pine').setup {
      highlight_groups = {
        -- hide the solid block; virt-column.nvim draws a thin line instead
        ColorColumn = { bg = 'none' },
      },
    }
    vim.cmd [[colorscheme rose-pine-moon]]
  end,
}
