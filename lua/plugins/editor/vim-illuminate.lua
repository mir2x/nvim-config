return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("illuminate").configure({
      delay = 150,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
      filetypes_denylist = {
        "dirbuf",
        "dirvish",
        "fugitive",
        "help",
        "lazy",
        "mason",
        "oil",
        "TelescopePrompt",
      },
    })

    -- Optional keymaps to jump between references
    vim.keymap.set("n", "]]", function()
      require("illuminate").goto_next_reference(false)
    end, { desc = "Next reference" })

    vim.keymap.set("n", "[[", function()
      require("illuminate").goto_prev_reference(false)
    end, { desc = "Prev reference" })
  end,
}
