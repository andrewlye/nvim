-- Doc-comment generation from treesitter (doxygen for C/C++, docstrings for
-- Python, ...). Emitted as a LuaSnip snippet, so <C-f>/<C-b> jump between the
-- fields. Keys are filetype-local: see ftplugin/c.lua and ftplugin/python.lua.
--
-- C/C++ use a custom `///` doxygen convention instead of the stock /** */
-- block (same lines as neogen's templates/doxygen.lua, restyled).
local function doxygen_slash()
  local i = require('neogen.types.template').item
  return {
    { nil, '/// @file', { no_results = true, type = { 'file' } } },
    { nil, '/// @brief $1', { no_results = true, type = { 'func', 'file', 'class' } } },
    { nil, '', { no_results = true, type = { 'file' } } },

    { i.ClassName, '/// @class %s', { type = { 'class' } } },
    { i.Type, '/// @typedef %s', { type = { 'type' } } },
    { nil, '/// @brief $1', { type = { 'func', 'class', 'type' } } },
    { nil, '///', { type = { 'func', 'class', 'type' } } },
    { i.Tparam, '/// @tparam %s $1' },
    { i.Parameter, '/// @param %s $1' },
    { i.Return, '/// @return $1' },
  }
end

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  cmd = 'Neogen',
  opts = function()
    local slash = { annotation_convention = 'doxygen_slash', doxygen_slash = doxygen_slash() }
    return {
      snippet_engine = 'luasnip',
      languages = {
        c = { template = slash },
        cpp = { template = slash },
      },
    }
  end,
}
