-- doesn't seem to be present
if vim.version.lt(vim.version(), {0, 12, 0}) then
	return
end

vim.opt.cmdheight = 0
if vim.fn.exists("+showcmdloc") then
	vim.o.showcmdloc = "statusline"
end

-- vim.cmd.set('shm+=F') -- workaround before #41002

require("vim._core.ui2").enable({
	msg = {
		-- see :h ui-messages
		-- $type = cmd|msg|pager|dialog
		--targets = {
			-- <target> = $type
		--},
		--[[
		$type = {
		    height = 0.5,
		    timeout = 5000,
		},
		]]
	},
})
