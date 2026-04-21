return {
  'saghen/blink.cmp',
  version = '*',
  dependencies = { 'L3MON4D3/LuaSnip' },
  opts = {
    keymap = {
      preset = 'none',
      ['<Tab>'] = { 'select_and_accept', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-Space>'] = { 'show', 'fallback' },
      ['<C-f>'] = { 'snippet_forward', 'fallback' },
      ['<C-b>'] = { 'snippet_backward', 'fallback' },
      ['<Up>'] = { 'hide', 'fallback' },
      ['<Down>'] = { 'hide', 'fallback' },
    },
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
      menu = { border = 'rounded' },
      documentation = {
        auto_show = true,
        window = { border = 'rounded' },
      },
      accept = { auto_brackets = { enabled = true } },
    },
    snippets = { preset = 'luasnip' },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },
    signature = { enabled = true },
  },
  opts_extend = { 'sources.default' },
}
