require("conform").setup({
	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		objc = { "clang-format" },
		objcpp = { "clang-format" },
		cuda = { "clang-format" },
		kdl = { "kdlfmt" },
		lua = { "stylua" },
		nix = { "nixfmt" },
		nu = { "nufmt" },
		qml = { "qmlformat" },
		qmljs = { "qmlformat" },
		yaml = { "yamlfmt" },
	},
})
