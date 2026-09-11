return {
  'lukas-reineke/virt-column.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    char = '▏', -- thin hairline glyph drawn at the 'colorcolumn' position
    highlight = 'NonText', -- subtle, low-contrast
  },
}
