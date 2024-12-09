local M = {}

-- to reload:
-- :lua package.loaded['grep.health'] = nil

local function maybe_with(exe)
	if vim.call("executable", exe) then
		vim.health.ok(("Using `%s`"):format(exe))
		return true
	end
	return false
end

M.check = function()
	vim.health.start("grep")

	vim.health.info("current global grep: `" .. vim.opt.grepprg:get() .. "`")

	if not maybe_with("rg") and not maybe_with("ag") then
		vim.health.warn("No search executable found, using grep", "suggestion: install ripgrep or ag")
	end
end

return M
