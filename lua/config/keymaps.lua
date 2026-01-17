local opts = { noremap = true, silent = true }

-- Set leader key (do this before mappings ideally)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Diagnostic keymaps
-- Disable default keys
for _, lhs in ipairs({ "]d", "[d", "]D", "[D", "<C-w>d" }) do
    pcall(vim.keymap.del, "n", lhs)
end

vim.keymap.set(
    "n",
    "]e",
    vim.diagnostic.goto_next,
    vim.tbl_extend("force", opts, { desc = "Jump to the next diagnostic in the current buffer" })
)

vim.keymap.set(
    "n",
    "[e",
    vim.diagnostic.goto_prev,
    vim.tbl_extend("force", opts, { desc = "Jump to the previous diagnostic in the current buffer" })
)

vim.keymap.set(
    "n",
    "]E",
    function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
    vim.tbl_extend("force", opts, { desc = "Jump to the last diagnostic in the current buffer" })
)

vim.keymap.set(
    "n",
    "[E",
    function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
    vim.tbl_extend("force", opts, { desc = "Jump to the first diagnostic in the current buffer" })
)

vim.keymap.set(
    "n",
    "<leader>e",
    vim.diagnostic.open_float,
    vim.tbl_extend("force", opts, { desc = "Show diagnostics under the cursor" })
)
