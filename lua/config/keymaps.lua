local map = vim.keymap.set

-- Diagnostics
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix list' })

-- Window splits
map('n', '<leader>sv', '<C-w>v', { desc = 'Split vertical' })
map('n', '<leader>sh', '<C-w>s', { desc = 'Split horizontal' })
map('n', '<leader>se', '<C-w>=', { desc = 'Equalize windows' })
map('n', '<leader>sx', ':close<CR>', { desc = 'Close window' })

-- Window resize
map('n', '<C-Up>', ':resize +3<CR>', { desc = 'Resize up' })
map('n', '<C-Down>', ':resize -3<CR>', { desc = 'Resize down' })
map('n', '<C-Left>', ':vertical resize -3<CR>', { desc = 'Resize left' })
map('n', '<C-Right>', ':vertical resize +3<CR>', { desc = 'Resize right' })

-- Tabs
map('n', '<leader>to', ':tabnew<CR>', { desc = 'New tab' })
map('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close tab' })
map('n', '<leader>tl', ':tabn<CR>', { desc = 'Next tab' })
map('n', '<leader>th', ':tabp<CR>', { desc = 'Previous tab' })

map('n', 'x', '"_x', { desc = 'Delete w/o register' })
map('n', '<Esc>', ':nohl<CR>', { desc = 'Clear search highlights' })

-- Visual: keep selection when indenting
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Move lines in visual
map('v', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
map('v', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
map('v', 'p', '"_dP', { desc = 'Paste without yank' })

-- Move blocks in visual-block
map('x', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move block down' })
map('x', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move block up' })
map('x', '<A-j>', ":move '>+1<CR>gv-gv", { desc = 'Move block down' })
map('x', '<A-k>', ":move '<-2<CR>gv-gv", { desc = 'Move block up' })
