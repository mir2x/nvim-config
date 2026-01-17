return {
  "akinsho/toggleterm.nvim",
  -- Load when you use the commands or keys
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { [[<c-\>]],    "<cmd>ToggleTerm<cr>",                      desc = "Toggle terminal" },
    { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>",      desc = "Terminal (float)" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal)" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",   desc = "Terminal (vertical)" },
  },
  opts = {
    -- this is the canonical option from the plugin docs
    open_mapping = [[<c-\>]],

    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,

    persist_size = true,
    persist_mode = true,

    -- Make vertical terminals take 40% width
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
      return 20
    end,

    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,

    float_opts = {
      border = "rounded",
      winblend = 0,
    },
  },
}
