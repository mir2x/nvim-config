return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      c = { "clangtidy" },
      cpp = { "clangtidy" },
      objc = { "clangtidy" },
      objcpp = { "clangtidy" },
      go = { "golangcilint" },
    }

    local grp = vim.api.nvim_create_augroup("Linting", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = grp,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, {})
  end,
}
