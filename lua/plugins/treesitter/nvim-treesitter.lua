return {
	"nvim-treesitter/nvim-treesitter",

  build = ":TSUpdate",
	config = function ()
    local ts = require("nvim-treesitter")
		ts.setup({
			ensure_installed = { "c", "cpp", "java", "python", "javascript", "typescript", "go", "lua", "html", "css", "vim", "vimdoc", "query" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
