-- Split navigation that continues into the surrounding multiplexer at the
-- edge of nvim's window tree.
--
-- Not lazy: at startup it marks the pane as "nvim is here" (tmux pane option
-- @pane-is-vim, WezTerm user var IS_NVIM) so the multiplexer's own C-hjkl
-- bindings forward the keys instead of moving their panes. The multiplexer
-- side lives outside this repo: ~/.config/tmux/tmux.conf and
-- ~/.config/wezterm/wezterm.lua.
return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  init = function()
    -- Same rule as lua/config/repl.lua: $TMUX first (innermost multiplexer,
    -- survives detach), then $WEZTERM_PANE, else no integration. Set through
    -- vim.g because the plugin's own auto-detect keys off $TERM_PROGRAM,
    -- which tmux only sets from 3.3 on, so older remote tmux would go unseen.
    vim.g.smart_splits_multiplexer_integration = vim.env.TMUX and 'tmux'
      or vim.env.WEZTERM_PANE and 'wezterm'
      or false
  end,
  opts = {},
  keys = {
    { '<C-h>', function() require('smart-splits').move_cursor_left() end, desc = 'Move to left split' },
    { '<C-j>', function() require('smart-splits').move_cursor_down() end, desc = 'Move to split below' },
    { '<C-k>', function() require('smart-splits').move_cursor_up() end, desc = 'Move to split above' },
    { '<C-l>', function() require('smart-splits').move_cursor_right() end, desc = 'Move to right split' },
    { '<A-h>', function() require('smart-splits').resize_left() end, desc = 'Resize split left' },
    { '<A-j>', function() require('smart-splits').resize_down() end, desc = 'Resize split down' },
    { '<A-k>', function() require('smart-splits').resize_up() end, desc = 'Resize split up' },
    { '<A-l>', function() require('smart-splits').resize_right() end, desc = 'Resize split right' },
  },
}
