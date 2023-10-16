local base16_theme = os.getenv("BASE16_THEME")
if base16_theme then
  local colors_name = string.format("base16-%s", base16_theme)
  if vim.g.colors_name ~= colors_name then
    vim.cmd(string.format("colorscheme %s", colors_name))
  end
end

vim.api.nvim_set_hl(0, "Normal", {})
vim.api.nvim_set_hl(0, "SignColumn", {})
vim.api.nvim_set_hl(0, "LineNr", {})
vim.api.nvim_set_hl(0, "ALEError", {
  ctermbg='none',
  cterm={ underline },
})
vim.api.nvim_set_hl(0, "ALEWarning", {
  ctermbg='none',
  cterm={ underline },
})
