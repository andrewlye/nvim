return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gs = require 'gitsigns'
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map('n', ']c', function() gs.nav_hunk 'next' end, 'Next hunk')
      map('n', '[c', function() gs.nav_hunk 'prev' end, 'Previous hunk')

      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', 'Stage hunk')
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', 'Reset hunk')
      map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
      map('n', '<leader>hd', gs.diffthis, 'Diff against index')
      map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Blame line')
    end,
  },
}
