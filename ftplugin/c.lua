-- Filetype-local keys for C and C++. Neovim's ftplugin/cpp.vim runs
-- `runtime! ftplugin/c.lua`, so this file is loaded for both filetypes.
local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

map('<localleader>d', function()
  require('neogen').generate()
end, 'Doxygen: document this')
map('<localleader>D', function()
  require('neogen').generate { type = 'file' }
end, 'Doxygen: file header')
map('<localleader>h', '<cmd>LspClangdSwitchSourceHeader<cr>', 'Switch source/header')

-- Insert the missing #include for the unresolved symbol under the cursor.
-- clangd's include-fixer offers this as a quickfix; --header-insertion=never
-- only stops completion-accept from inserting headers, not this code action.
map('<localleader>i', function()
  vim.lsp.buf.code_action {
    filter = function(a)
      return a.title:match '^Include ' ~= nil or a.title:match '^Add include' ~= nil
    end,
    apply = true,
  }
end, 'Insert missing #include')
