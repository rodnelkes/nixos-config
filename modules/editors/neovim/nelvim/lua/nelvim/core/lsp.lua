vim.lsp.config("*", {
	root_markers = { ".git", ".jj" },
})

vim.lsp.enable({ "bashls", "kdl-lsp", "lua_ls", "nixd", "nu-lsp" })

vim.diagnostic.config({
	virtual_lines = true,
	update_in_insert = true,
	severity_sort = true,
})
