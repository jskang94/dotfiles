require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      }
    }
  },
  filters = {
    custom = {"__pycache__", ".\\+\\.pyc$"},
  }
})
