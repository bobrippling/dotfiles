if !has("nvim")
	finish
endif

lua <<EOF
	-- https://github.com/hrsh7th/nvim-cmp/wiki
	local ok, cmp = pcall(require, 'cmp')
	if not ok then
		vim.cmd.echom("'nvim-cmp not installed'")
		return
	end

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
			--[[
			<CR> inserts a newline in insertmode and searchs in '/' mode (i.e. always passthru)
			<Tab> accepts first entry [expanding snippets, etc] if cmp visible (check is done for us), otherwise inserts tab
			]]
			-- Ctrl-e ends completion
			['<C-u>'] = cmp.mapping.scroll_docs(-4),
			['<C-d>'] = cmp.mapping.scroll_docs(4),
			['<C-l>'] = cmp.mapping.complete_common_string(),
			['<Tab>'] = cmp.mapping.confirm({ select = true }),
			['<C-g>'] = function()
				if cmp.visible_docs() then
					cmp.close_docs()
				else
					cmp.open_docs()
				end
			end,
		}),
		sorting = {
			priority_weight = 2,
			comparators = {
				function(a, b)
					local kind_priority = {
						Field = 1,
						Method = 1,
						Property = 2,
						Function = 2,
						Variable = 3,
						Class = 4,
						Interface = 4,
						Module = 5,
						Trait = 6,
					}

					local kind1 = kind_priority[a:get_kind()] or 100
					local kind2 = kind_priority[b:get_kind()] or 100
					-- lua print(vim.inspect(vim.lsp.protocol.CompletionItemKind))

					if kind1 ~= kind2 then
						return kind1 < kind2
					end
				end,
				-- Use the default comparators from nvim-cmp after custom ones
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
		sources = cmp.config.sources(
			{
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
						end,
						show_source = true,
					}
				}
			}
		),
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
