local plugins = {
    "git",
    "hipatterns",
	"icons",
    "indentscope"
}

for _, plugin in ipairs(plugins) do
	require("nelvim.plugins.mini." .. plugin .. "")
end
