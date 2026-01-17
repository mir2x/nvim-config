return {
  'stevearc/oil.nvim',
  dependencies = { { "echasnovski/mini.icons", opts = {} } },

	config = function ()
		require("oil").setup({
			keymaps = {
        ["q"] = "actions.close",               -- Close Oil
        ["<CR>"] = "actions.select",           -- Open file or directory
        ["<C-v>"] = "actions.select_vsplit",   -- Open in vertical split
        ["<C-x>"] = "actions.select_split",    -- Open in horizontal split
        ["<C-t>"] = "actions.select_tab",      -- Open in new tab
        ["<BS>"] = "actions.parent",           -- Go up one level
        ["_"] = "actions.open_cwd",            -- Open current working dir
        ["`"] = "actions.cd",                  -- Set Oil dir as cwd
        ["~"] = "actions.tcd",                 -- Set Oil dir as tab-local cwd
        ["g."] = "actions.toggle_hidden",      -- Toggle hidden files
        ["g?"] = "actions.show_help",          -- Show help
      },
      view_options = {
        show_hidden = true,
      },
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end
}
