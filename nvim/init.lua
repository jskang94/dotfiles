vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("00_init-plugins")
require("10_setup-bufferline-nvim")
require("10_setup-formatter-nvim")
require("10_setup-lsp-status-nvim")
require("10_setup-nvim-cmp")
require("10_setup-nvim-config-local")
require("10_setup-nvim-tree")
require("20_setup-lsp")
require("40_colorscheme")
require("40_keymap")
require("40_options")
