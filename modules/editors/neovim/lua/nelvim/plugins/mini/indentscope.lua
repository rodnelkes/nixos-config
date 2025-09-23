local indentscope = require("mini.indentscope")

indentscope.setup({
	draw = {
		delay = 0,
		animation = indentscope.gen_animation.none(),
	},

    symbol = "|",
})
