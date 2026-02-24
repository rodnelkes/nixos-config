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
    "jj"
}

for _, plugin in ipairs(plugins) do
	require("nelvim.plugins." .. plugin .. "")
end
