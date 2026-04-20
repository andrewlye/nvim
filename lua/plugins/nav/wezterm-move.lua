return {
  'letieu/wezterm-move.nvim',
  keys = {
    { '<C-h>', function() require('wezterm-move').move 'h' end, desc = 'Wezterm move left' },
    { '<C-j>', function() require('wezterm-move').move 'j' end, desc = 'Wezterm move down' },
    { '<C-k>', function() require('wezterm-move').move 'k' end, desc = 'Wezterm move up' },
    { '<C-l>', function() require('wezterm-move').move 'l' end, desc = 'Wezterm move right' },
  },
}
