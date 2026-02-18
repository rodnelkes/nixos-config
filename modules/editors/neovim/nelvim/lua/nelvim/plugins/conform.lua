require("conform").setup({
	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		kdl = { "kdlfmt" },
		lua = { "stylua" },
		nix = { "nixfmt" },
        nu = { "nufmt" },
		qml = { "qmlformat" },
		qmljs = { "qmlformat" },
	},
})
