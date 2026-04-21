return {
  'stevearc/conform.nvim',
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
  opts = {
    notify_on_error = true,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'ruff_organize_imports' },
    },
  },
}
