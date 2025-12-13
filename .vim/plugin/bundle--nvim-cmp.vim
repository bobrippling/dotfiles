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

	local cmptypes = require("cmp.types")

	local insmap = cmp.mapping.preset.insert({
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
	})

	-- <C-n> is broken on some filetypes, but disabling isn't the fix
	--insmap['<C-N>'] = (function (orig)
	--	return function(...)
	--		local r = orig(...)
	--		return r
	--	end
	--end)(insmap['<C-N>'])
	--insmap['<C-P>'] = ...

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
		mapping = insmap,
		sorting = {
			priority_weight = 2,
			comparators = {
				-- sort by kind, but custom ordering
				function(a, b)
					local kind_priority = {
						Field = 1,
						Method = 2,
						Property = 3,
						Function = 4,
						Variable = 5,
						Class = 6,
						Interface = 6,
						Trait = 6,
						Module = 7,
					}

					local kind1 = kind_priority[a:get_kind()] or 100
					local kind2 = kind_priority[b:get_kind()] or 100
					-- lua print(vim.inspect(vim.lsp.protocol.CompletionItemKind))

					if kind1 ~= kind2 then
						return kind1 < kind2
					end
				end,
				-- sort methods by inherent or trait (rust)
				function(a, b)
					local method = cmptypes.lsp.CompletionItemKind.Method
					local a_item = a:get_completion_item() ---@type lsp.CompletionItem
					local b_item = b:get_completion_item() ---@type lsp.CompletionItem

					if a_item.kind == method and b_item.kind == method then
						-- a_item.detail: top-level plain detail about the item
						-- a_item.labelDetails: more verbose, shown before detail
						-- print(vim.inspect(a_item)), :source this file to refresh
						local a_trait = (a_item.labelDetails and a_item.labelDetails.detail) ~= nil
						local b_trait = (b_item.labelDetails and b_item.labelDetails.detail) ~= nil

						if a_trait and b_trait then
							-- return nil
						elseif a_trait then
							return false
						elseif b_trait then
							return true
						end
					end
				end,
				-- Use a mix of the comparators from nvim-cmp after custom ones
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.recently_used,
				cmp.config.compare.scopes,
				cmp.config.compare.locality,
				cmp.config.compare.kind,
				cmp.config.compare.length,
				cmp.config.compare.sort_text,
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
