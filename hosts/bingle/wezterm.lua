local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrains Mono")

return config
