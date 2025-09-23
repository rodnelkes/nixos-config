require("oil").setup({
	default_file_explorer = true,

	skip_confirm_for_simple_edits = true,

	view_options = {
		show_hidden = true,
	},

	preview_win = {
		update_on_cursor_moved = true,
		preview_method = "fast_scratch",
		disable_preview = function(filename)
			return false
		end,
		win_options = {},
	},
})

vim.keymap.set("n", "<leader>p", "<CMD>Oil<CR>", { desc = "Open parent directory" })
