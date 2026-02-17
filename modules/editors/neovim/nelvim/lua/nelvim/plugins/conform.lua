require("conform").setup({
	formatters_by_ft = {
		sh = { "shfmt" },
		kdl = { "kdlfmt" },
		lua = { "stylua" },
		nix = { "nixfmt" },
	},
})
