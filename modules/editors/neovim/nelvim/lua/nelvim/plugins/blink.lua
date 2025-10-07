require("blink.cmp").setup({
	keymap = { preset = "default" },

	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},

	completion = {
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},

		menu = {
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
							return kind_icon
						end,
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
					kind = {
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},

				treesitter = { "lsp" },
			},
			border = "rounded",
			scrollbar = false,
		},

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 0,

			window = {
				border = "rounded",
				scrollbar = false,
			},
		},

		ghost_text = { enabled = true },
	},

	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
			"omni",
            "nerdfont",
		},
		providers = {
			nerdfont = {
				module = "blink-nerdfont",
				name = "Nerd Fonts",
				score_offset = 15,
				opts = { insert = true },
			},
		},
	},

	fuzzy = {
		implementation = "prefer_rust" or "lua",
	},

	snippets = { preset = "luasnip" },

	signature = {
		enabled = true,

		window = {
			border = "rounded",
			scrollbar = false,
		},
	},
})
