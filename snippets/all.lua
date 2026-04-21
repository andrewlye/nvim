-- Snippet model:
--   s(trigger, body)          regular snippet — type trigger then <Tab>
--   s({trig=..., snippetType='autosnippet'}, body)
--                             fires immediately on typing the trigger
--
--   Nodes: t = literal text, i = tab stop, f = computed from fn
--   Saving this file auto-reloads snippets (see plugins/dev/luasnip.lua).

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  s('date', f(function() return os.date '%Y-%m-%d' end)),

  s('td', {
    t 'TODO(',
    i(1, 'author'),
    t '): ',
    i(2, 'description'),
  }),

  s(
    { trig = '==>', snippetType = 'autosnippet' },
    t '⇒'
  ),
}
