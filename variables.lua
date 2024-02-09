local beautiful = require("beautiful")
local naughty = require("naughty")
local awful = require("awful")

local M = {}

M.init = function()
	beautiful.init("/home/tony/.config/awesome/theme.lua")

	naughty.config.defaults.timeout = 5
	naughty.config.defaults.margin = 10

	terminal = os.getenv("TERM") or "xterm"
	editor = os.getenv("EDITOR") or "nano"
	file_manager = "nemo"
	browser = "firefox"
	mail_client = "thunderbird"

	editor_cmd = terminal .. " -e " .. editor

	modkey = "Mod4"
	altkey = "Mod1"

	-- layouts names
	awful.layout.suit.floating.name = " [F] "
	awful.layout.suit.tile.name = " []= "
	awful.layout.suit.tile.left.name = " =[] "
	awful.layout.suit.tile.bottom.name = " T-B "
	awful.layout.suit.tile.top.name = " T-T "
	awful.layout.suit.fair.name = " ||| "
	awful.layout.suit.fair.horizontal.name = " === "
	awful.layout.suit.spiral.name = " [@] "
	awful.layout.suit.spiral.dwindle.name = " [\\\\\\] "
	awful.layout.suit.max.name = " [M] "
	awful.layout.suit.max.fullscreen.name = " [ ] "
	awful.layout.suit.magnifier.name = " [+] "
	awful.layout.suit.corner.nw.name = " '_| "
	awful.layout.suit.corner.ne.name = " |_' "
	awful.layout.suit.corner.sw.name = " ._| "
	awful.layout.suit.corner.se.name = " |_. "


	-- Table of layouts to cover with awful.layout.inc, order matters.
	awful.layout.layouts = {
		awful.layout.suit.tile,
		awful.layout.suit.tile.left,
		awful.layout.suit.fair.horizontal,
	}
end

return M
