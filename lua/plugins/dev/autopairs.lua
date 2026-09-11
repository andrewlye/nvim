return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {},
  config = function(_, opts)
    local npairs = require 'nvim-autopairs'
    npairs.setup(opts)

    local Rule = require 'nvim-autopairs.rule'

    -- Block comments: <CR> right after a `/*` or `/**` that starts a line opens
    --   /**
    --    * |
    --    */
    -- Nothing is inserted while typing, so inline `/* ... */` stays untouched.
    -- Key sequence: <CR> lets the C ftplugin's 'formatoptions' r-flag insert the
    -- ` * ` leader; `/` then uses the x-flag on `ex:*/` in 'comments' to turn that
    -- leader into ` */` (:help format-comments); <Up><End><CR> opens the middle
    -- line. No `====` re-indent, so ` */` stays aligned with the ` *` lines.
    npairs.add_rule(Rule('^%s*/%*%*?$', '^%s*$', { 'c', 'cpp' }) -- before cursor / after cursor
      :use_regex(true)
      :only_cr()
      :replace_map_cr(function()
        return '<c-g>u<CR>/<Up><End><CR>'
      end))
  end,
}
