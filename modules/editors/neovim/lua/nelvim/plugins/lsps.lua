local servers = {
	lua_ls = {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
				},
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						"${3rd}/luv/library",
						-- "${3rd}/busted/library",
					},
				},
			})
		end,
		settings = {
			Lua = {},
		},
	},
	nixd = {
		nixpkgs = {
			expr = nixCats.extra("nixdExtras.nixpkgs"),
		},
		formatting = { command = { "nixfmt" } },
		options = {
			nixos = {
				expr = nixCats.extra("nixdExtras.nixos_options"),
			},
			home_manager = {
				expr = nixCats.extra("nixdExtras.home_manager_options"),
			},
		},
	},
}

for server, config in pairs(servers) do
	config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
	require("lspconfig")[server].setup(config)
end

vim.diagnostic.config({ update_in_insert = true })
