vim.api.nvim_set_keymap('', '<C-n>', '<cmd>NvimTreeToggle<CR>', {})
vim.api.nvim_set_keymap('', '<C-h>', '<cmd>set hlsearch!<CR>', {})
vim.api.nvim_set_keymap('', '<C-t>', '<cmd>Files<CR>', {})
vim.api.nvim_set_keymap('n', '<C-q>', '<cmd>Sayonara<CR>', {})
vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>Format<CR>', { noremap=true })

vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>%bd|e#<CR>', {})
vim.api.nvim_set_keymap('n', 'ge', '<cmd>bn<CR>', {})
vim.api.nvim_set_keymap('n', 'gE', '<cmd>bp<CR>', {})
