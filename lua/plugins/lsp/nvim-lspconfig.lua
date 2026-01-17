return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"williamboman/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},

	config = function()
		-- 1) Diagnostics UI
		vim.diagnostic.config({
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			virtual_text = {
				spacing = 2,
				prefix = "●",
			},
			float = {
				border = "rounded",
				source = "if_many",
			},
		})

		-- 2) Keymaps + per-buffer behavior on attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(args)
				local bufnr = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client then
					return
				end

				-- Prevent formatter fights: use Conform/Prettier instead
				if client.name == "eslint" or client.name == "vtsls" or client.name == "lua_ls" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				local map = vim.keymap.set
				local opts = { buffer = bufnr, noremap = true, silent = true }

				map("n", "gd", vim.lsp.buf.definition, opts)
				map("n", "K", vim.lsp.buf.hover, opts)
				map("n", "gi", vim.lsp.buf.implementation, opts)
				map("n", "gr", vim.lsp.buf.references, opts)
				map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				map("n", "<leader>rn", vim.lsp.buf.rename, opts)

				-- Inlay hints
				if client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end,
		})

		-- 3) Capabilities for nvim-cmp
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- 4) Per-server configuration
		local servers = require("plugins.lsp.mason").servers

		for _, server in ipairs(servers) do
			local server_opts = {}

			-- c/c++
			if server == "clangd" then
				server_opts.cmd = {
					"clangd",
					"--header-insertion=iwyu",
					"--header-insertion-decorators",
				}
			end

			-- python
			if server == "pyright" then
				server_opts.root_markers = {
					".venv",
					"venv",
					"requirements.txt",
					"setup.cfg",
					"setup.py",
					"pyrightconfig.json",
					".git",
				}

				server_opts.before_init = function(_, config)
					local root = config.root_dir
					local python = nil

					local venv = vim.env.VIRTUAL_ENV
					if venv and #venv > 0 then
						python = venv .. "/bin/python"
					elseif root then
						local candidates = {
							root .. "/.venv/bin/python",
							root .. "/venv/bin/python",
							root .. "/.env/bin/python",
						}
						for _, p in ipairs(candidates) do
							if vim.fn.executable(p) == 1 then
								python = p
								break
							end
						end
					end

					if python then
						config.settings = config.settings or {}
						config.settings.python = config.settings.python or {}
						config.settings.python.pythonPath = python
					end
				end

				server_opts.settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							autoImportCompletions = true,
						},
					},
				}
			end

			-- javascript/typescript
			if server == "vtsls" then
				server_opts.root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" }
				server_opts.settings = {
					complete_function_calls = true,
					vtsls = {
						autoUseWorkspaceTsdk = true,
						enableMoveToFileCodeAction = true,
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = { completeFunctionCalls = true },
					},
					javascript = {
						suggest = { completeFunctionCalls = true },
					},
				}
			end

			if server == "eslint" then
				server_opts.root_markers = {
					"eslint.config.js",
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					".eslintrc.yml",
					"package.json",
					".git",
				}
			end

			if server == "tailwindcss" then
				server_opts.root_markers = {
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.cjs",
					"package.json",
					".git",
				}
				server_opts.settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ "clsx%(([^)]*)%)", "[\"'`]([^\"'`]*)([\"'`])" },
								{ "cn%(([^)]*)%)", "[\"'`]([^\"'`]*)([\"'`])" },
							},
						},
					},
				}
			end

			if server == "emmet_ls" then
				server_opts.filetypes = {
					"html",
					"css",
					"scss",
					"javascriptreact",
					"typescriptreact",
				}
			end

			if server == "prismals" then
				server_opts.root_markers = { "schema.prisma", "prisma", "package.json", ".git" }
			end

			if server == "graphql" then
				server_opts.root_markers = { ".graphqlrc", ".graphqlrc.json", "package.json", ".git" }
			end

			-- lua
			if server == "lua_ls" then
				server_opts.settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
						},
						hint = { enable = true },
						telemetry = { enable = false },
					},
				}
			end

			-- go
			if server == "gopls" then
				server_opts.settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						usePlaceholders = true,
						completeUnimported = true,
						analyses = {
							unusedparams = true,
							unreachable = true,
						},
					},
				}
				server_opts.root_markers = { "go.work", "go.mod", ".git" }
			end

			-- rust
			if server == "rust_analyzer" then
				server_opts.settings = {
					["rust-analyzer"] = {
						cargo = { buildScripts = { enable = true } },
						procMacro = { enable = true },
						checkOnSave = true,
						check = { command = "clippy" },
					},
				}
			end

			vim.lsp.config(server, server_opts)
		end

		-- 5) Enable servers (autostart for matching filetypes)
		for _, server in ipairs(servers) do
			vim.lsp.enable(server)
		end
	end,
}
