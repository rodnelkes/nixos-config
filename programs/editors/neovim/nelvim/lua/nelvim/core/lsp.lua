vim.lsp.config("*", {
	root_markers = { ".git", ".jj" },
})

vim.lsp.enable({ "bashls", "lua_ls", "nixd" })

vim.diagnostic.config({
	virtual_lines = true,
	update_in_insert = true,
	severity_sort = true,
})
