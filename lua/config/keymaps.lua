local map = vim.keymap.set

-- Diagnostics ([d / ]d are Neovim builtins, :help ]d-default)
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix list' })

-- Window resize
map('n', '<C-Up>', ':resize +3<CR>', { desc = 'Resize up' })
map('n', '<C-Down>', ':resize -3<CR>', { desc = 'Resize down' })
map('n', '<C-Left>', ':vertical resize -3<CR>', { desc = 'Resize left' })
map('n', '<C-Right>', ':vertical resize +3<CR>', { desc = 'Resize right' })

-- Window splits
map('n', '<C-w>v', '<C-w>v', { desc = 'Vertical split' })
map('n', '<C-w>h', '<C-w>s', { desc = 'Horizontal split' })
map('n', '<C-w>x', '<C-w>q', { desc = 'Close split' })
map('n', '<C-w>d', '<C-w>o', { desc = 'Close all other splits' })
map('n', '<C-w>f', function()
  if vim.t.zoomed then
    vim.cmd 'tabclose'
  else
    vim.cmd 'tab split'
    vim.t.zoomed = true
  end
end, { desc = 'Zoom toggle' })

-- Tabs
map('n', '<leader>to', ':tabnew<CR>', { desc = 'New tab' })
map('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close tab' })
map('n', '<leader>tl', ':tabn<CR>', { desc = 'Next tab' })
map('n', '<leader>th', ':tabp<CR>', { desc = 'Previous tab' })

map('n', 'x', '"_x', { desc = 'Delete w/o register' })
map('n', '<Esc>', ':nohl<CR>', { desc = 'Clear search highlights' })

map('n', '<Esc><Esc>', function()
  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(win).relative ~= '' then
    vim.api.nvim_win_close(win, true)
  end
end, { desc = 'Close floating window' })

-- Visual: keep selection when indenting
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

map('v', 'p', '"_dP', { desc = 'Paste without yank' })

-- Move blocks in visual-block
map('x', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move block down' })
map('x', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move block up' })
map('x', '<A-j>', ":move '>+1<CR>gv-gv", { desc = 'Move block down' })
map('x', '<A-k>', ":move '<-2<CR>gv-gv", { desc = 'Move block up' })
