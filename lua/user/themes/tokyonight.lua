return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'folke/tokyonight.nvim',
  config = function()
    require('tokyonight').setup {
      ---@class colors Colorscheme
      on_colors = function(colors)
        --colors.bg = '#22223b'
        -- colors.bg_highlight = '#3c3c5e'
        -- colors.bg_popup = '#3c3c5e'
        -- colors.bg_search = '#3c3c5e'
        -- colors.bg_sidebar = '#22223b'
        -- colors.fg_sidebar = '#fffff0'
        -- colors.blue1 = '#adbdff'
        -- colors.blue5 = '#fffff0'
        colors.border = '#fffff0'
        colors.border_highlight = '#fffff0'
        -- colors.green = '#d7907b'
        -- colors.orange = '#d7907b'
        -- colors.yellow = '#fffff0'
        -- colors.green1 = '#8b85c1'
        -- colors.magenta = '#73daca'
        -- colors.purple = '#41a6b5'
      end,
    }
  end,
}
