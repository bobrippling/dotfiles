local M = {}

local function maybe_with(exe)
	if vim.call("executable", exe) then
		vim.health.report_ok(("Using `%s`"):format(exe))
		return true
	end
	return false
end

M.check = function()
	vim.health.report_start("grep")

	vim.health.report_info("current global grep: `" .. vim.opt.grepprg:get() .. "`")

	if not maybe_with("rg") and not maybe_with("ag") then
		vim.health.report_warn("No search executable found, using grep", "suggestion: install ripgrep or ag")
	end
end

return M
