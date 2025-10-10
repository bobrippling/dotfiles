if !has("nvim")
	finish
endif

lua <<EOF
local ok, osc52tmux = pcall(require, 'nvim-osc52-tmux')
if not ok then
	return
end

osc52tmux.setup { force_plus = true }
EOF
