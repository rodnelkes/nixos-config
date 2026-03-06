vim.lsp.config("*", {
	root_markers = { ".git", ".jj" },
})

vim.lsp.enable({
	"bashls",
	"clangd",
	"kdl-lsp",
	"lua_ls",
	"nixd",
	"nu-lsp",
	"qmlls",
	"yamlls",
})

vim.diagnostic.config({
	virtual_lines = true,
	update_in_insert = true,
	severity_sort = true,
})
