lua <<EOF
	-- https://github.com/hrsh7th/nvim-cmp/wiki
	local cmp = require'cmp'

	cmp.setup({
		--[[
		snippet = {
			-- REQUIRED (?)
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
				-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
			end,
		},
		]]
		view = {
			entries = "custom" -- custom, wildmenu or native
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		}),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
		}, {
			{
				name = 'buffer',
				option = {
					get_bufnrs = function()
						local bufs = {}
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							bufs[vim.api.nvim_win_get_buf(win)] = true
						end
						return vim.tbl_keys(bufs)
					end
				}
			}
		})
	})

	--[[
	https://github.com/hrsh7th/nvim-cmp/issues/880
	in short, don't call cmd.setup({ cmdline = ... }) or cmd.setup.cmdline()
	or if you do, disable the Tab mapping:
	]]
	local cmdmap = cmp.mapping.preset.cmdline()
	cmdmap['<Tab>'] = nil
	cmdmap['<S-Tab>'] = nil
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmdmap,
		sources = {
			{ name = 'buffer' }
		}
	})

	--[[
	doesn't play well with wildcards
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		}),
		matching = { disallow_symbol_nonprefix_matching = false }
	})
	]]

	--[[ Set up lspconfig.
	this is done in plugin/lsp/setup.vim
	]]
EOF
