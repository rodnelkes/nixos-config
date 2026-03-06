require("catppuccin").setup({
	flavour = "mocha",

	custom_highlights = function(colors)
		return {
			BlinkCmpMenu = { bg = colors.base },
			BlinkCmpMenuBorder = { bg = colors.base, fg = colors.blue },
			BlinkCmpDoc = { bg = colors.base },
			BlinkCmpDocBorder = { bg = colors.base, fg = colors.blue },
			BlinkCmpDocSeparator = { bg = colors.base },
		}
	end,

	integrations = {
		blink_cmp = true,
		fzf = true,
		mini = {
			enabled = true,
			indentscope_color = "rosewater",
		},
		native_lsp = {
			enabled = true,

			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
				ok = { "italic" },
			},

			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
				ok = { "underline" },
			},

			inlay_hints = {
				background = true,
			},
		},
		treesitter = true,
	},
})

vim.cmd.colorscheme("catppuccin")
