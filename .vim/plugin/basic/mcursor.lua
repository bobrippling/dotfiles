vim.cmd.highlight("link MCursor Cursor")

-- can't use q-, since then vim hangs on `q` to close certain windows
vim.api.nvim_set_keymap("n", "<leader>q-", "", {
	desc = "stop multicursor mode",
	callback = function()
		local ns = vim.api.nvim_create_namespace("nvim.multicursor")

		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
	end,
})

vim.api.nvim_create_user_command(
	"MCkeep",
	function(args)
		local have_re = #args.args > 0
		local have_count = args.range > 0 -- args.line[12]
		local re = args.args

		if not have_re and not have_count then
			error("need /re/ or :range for filtering")
		end

		local ns = vim.api.nvim_create_namespace("nvim.multicursor")
		local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1)
		local ids = {}
		local lines = {}

		for _, mark in pairs(marks) do
			local id, row0, _ = unpack(mark)
			local row1 = row0 + 1

			if have_count and (row1 < args.line1 or row1 > args.line2) then
				table.insert(ids, id)

			elseif have_re then
				local text = lines[row0]
				if text == nil then
					text = vim.api.nvim_buf_get_lines(0, row0, row0 + 1, false)
					lines[row0] = text
				end

				if vim.fn.match(text, re) < 0 then
					table.insert(ids, id)
				end
			end
		end

		local n = 0
		for _, id in pairs(ids) do
			vim.api.nvim_buf_del_extmark(0, ns, id)
			n = n + 1
		end

		print("Deleted " .. n .. " mark" .. (n == 1 and "" or "s"))
	end,
	{
		desc = "filter mcursors on a regex (:MCk /.../) within a range (:a,b MCk [/.../])",
		force = true,
		nargs = "?",
		addr = "lines",
		range = "%",
		bar = true,
	}
)
