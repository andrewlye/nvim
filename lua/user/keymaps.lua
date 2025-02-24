-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Modes
-- normal = 'n'
-- insert = 'i'
-- visual = 'v'
-- visual_block = 'x'
-- terminal = 't'
-- command = 'c'

-- Normal --
-- Toggle nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
-- Window management
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split vertical' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split horizontal' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Equalize windows' })
vim.keymap.set('n', '<leader>sx', ':close<CR>', { desc = 'Close active window' })

-- Resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize +3<CR>', { desc = 'Increase window size' })
vim.keymap.set('n', '<C-Down>', ':resize -3<CR>', { desc = 'Decrease window size' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -3<CR>', { desc = 'Decrease window size (vertical)' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +3<CR>', { desc = 'Increase window size (vertical)' })

-- Navigate buffers
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { desc = 'Previous buffer' })

-- Delete buffer
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })

-- Tab management
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>tl', ':tabn<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>th', ':tabp<CR>', { desc = 'Previous tab' })

-- No register x
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete w/o register' })

-- Clear search highlights
vim.keymap.set('n', '<Esc>', ':nohl<CR>', { desc = 'Clear search highlights' })

-- Visual --
-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- Move text up and down
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste' })

-- Visual Block --
-- Move text up and down
vim.keymap.set('x', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move line down' })
vim.keymap.set('x', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move line up' })
vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv", { desc = 'Move line down' })
vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv", { desc = 'Move line up' })
