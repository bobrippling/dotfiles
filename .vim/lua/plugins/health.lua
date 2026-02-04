local M = {}

local function check(lib)
	local ok, cmp = pcall(require, lib)

	if not ok then
		vim.health.warn("\"" .. lib .. "\" not installed")
	end

	return ok
end

function M.check()
	vim.health.start("plugins")

	local ok = true
	if not check("nvim-cmp") then ok = false end

	if ok then
		vim.health.info("plugin checks ok")
	end
end

return M
