if !has("nvim")
	finish
endif

lua <<EOF
local ok, wk = pcall(require, 'which-key')
if not ok then
	--vim.cmd.echom("'which-key not installed'")
	return
end

wk.setup({ delay = 800 })
EOF
