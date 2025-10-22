local plugins = {
	"catppuccin",
	"treesitter",
	"lualine",
	"oil",
	"undotree",
	"fzf",
	"blink",
	"conform",
	"mini",
}

for _, plugin in ipairs(plugins) do
	require("nelvim.plugins." .. plugin .. "")
end
