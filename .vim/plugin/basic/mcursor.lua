-- can't use q-, since then vim hangs on `q` to close certain windows
vim.api.nvim_set_keymap("n", "<leader>q-", "", {
	desc = "stop multicursor mode",
	callback = function()
		local ns = vim.api.nvim_create_namespace("nvim.multicursor")

		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
	end,
})
