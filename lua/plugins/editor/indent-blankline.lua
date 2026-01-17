return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  opts = {
    indent = { char = "▏" },
    scope = { enabled = true, show_start = false, show_end = false },
    exclude = {
      filetypes = {
        "help",
        "lazy",
        "mason",
        "oil",
        "dashboard",
        "alpha",
        "NvimTree",
        "neo-tree",
        "Trouble",
        "terminal",
      },
    },
  },
}
