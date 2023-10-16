require("formatter").setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    cpp = {
      require("formatter.filetypes.cpp").clangformat
    },
    python = {
      require("formatter.filetypes.python").black
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
})
