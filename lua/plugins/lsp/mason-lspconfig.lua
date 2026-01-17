return {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  dependencies = { "williamboman/mason.nvim" },
  opts = function()
    local servers = require("plugins.lsp.mason").servers
    return {
      ensure_installed = servers,
      automatic_enable = false,
    }
  end,
}
