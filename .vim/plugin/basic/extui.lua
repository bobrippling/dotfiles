if vim.version.lt(vim.version(), {0, 12, 0}) then
	return
end

require('vim._extui').enable({})
vim.notify('enabled _extui')
