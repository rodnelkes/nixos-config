require("conform").setup({
	formatters_by_ft = {
		sh = { "shfmt" },
		lua = { "stylua" },
		nix = { "nixfmt" },
	},
})
