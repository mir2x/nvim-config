local servers = {
	-- c/c++
	"clangd",
	-- python
	"pyright",
	"ruff",
	-- typescript/javascript
	"vtsls",
	"eslint",
	"html",
	"cssls",
	"jsonls",
	"yamlls",
	"emmet_ls",
	"tailwindcss",
	"prismals",
	"graphql",
	-- lua
	"lua_ls",
	"stylua",
	-- go
	"gopls",
	-- rust
	"rust_analyzer",
}

return {
	"williamboman/mason.nvim",
	servers = servers,
	opts = {
		ui = {
			border = "rounded",
		},
	},
}
