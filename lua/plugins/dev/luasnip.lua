return {
  'L3MON4D3/LuaSnip',
  build = (function()
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      return
    end
    return 'make install_jsregexp'
  end)(),
  config = function()
    local ls = require 'luasnip'

    ls.config.setup {
      update_events = 'TextChanged,TextChangedI',
      region_check_events = 'CursorMoved',
      delete_check_events = 'TextChanged,InsertLeave',
      enable_autosnippets = true,
      store_selection_keys = '<Tab>',
    }

    local snippet_dir = vim.fn.stdpath 'config' .. '/snippets'
    require('luasnip.loaders.from_lua').lazy_load { paths = snippet_dir }

    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = snippet_dir .. '/*.lua',
      group = vim.api.nvim_create_augroup('luasnip-reload', { clear = true }),
      callback = function()
        require('luasnip.loaders.from_lua').load { paths = snippet_dir }
        vim.notify('snippets reloaded', vim.log.levels.INFO)
      end,
    })
  end,
}
