vim.g._ts_force_sync_parsing = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "bash", "nu", "kdl", "lua", "nix" },
	callback = function()
		vim.treesitter.start()
	end,
})
