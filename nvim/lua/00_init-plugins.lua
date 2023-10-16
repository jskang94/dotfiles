-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use "klen/nvim-config-local"

  use 'chriskempson/base16-vim'
  use 'nvim-tree/nvim-web-devicons'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = 'nvim-tree/nvim-web-devicons'
  }

  use {
    'akinsho/bufferline.nvim',
    requires = 'nvim-tree/nvim-web-devicons'
  }

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use 'mhartington/formatter.nvim'

  use 'mhinz/vim-sayonara'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'

  use { 'junegunn/fzf', run = ":call fzf#install()" }
  use 'junegunn/fzf.vim'
end)
