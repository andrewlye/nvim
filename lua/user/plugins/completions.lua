return {
  {
  "micangl/cmp-vimtex",
  ft = "tex",
  config = function()
      require('cmp_vimtex').setup({})
  end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",--autocomplete on the buffer
      "hrsh7th/cmp-path",--autocomplete path variables
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",--autocomplete from luasnip
      "L3MON4D3/LuaSnip",
    },

    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          -- Accept completion
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),
          
          -- Select [n]ext item
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if #cmp.get_entries() == 1 then
                cmp.confirm({select =true})
              else
                cmp.select_next_item()
              end
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Select [p]revious item
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          
          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),

          -- Manually trigger completion window
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
         
          -- Close completion window
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          
          -- Remove arrow key navigation
          ['<Down>'] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { 'i' }),
          ['<Up>'] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { 'i' }),

          -- <c-h> will move you to the right of each of the expansion locations.
          -- <c-l> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

        
        },
        sources = cmp.config.sources({
          { name = 'luasnip' },
          { name = 'buffer'},
          { name = 'nvim_lsp'},
          { name = 'path'},
        }),
      })
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path', option = {trailing_slash = true}, }
        },
        {
          { name = 'cmdline' , option = {treat_trailing_slash =false}}
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
      cmp.setup.filetype("tex", {
        sources = {
          { name = 'vimtex'},
          { name = 'luasnip' },
          { name = 'buffer'},
        },
      })
    end
  }
}
