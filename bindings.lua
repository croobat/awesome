local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local scratch = require("widgets.scratchpad")

local volume_widget = require("widgets.volume-widget.volume")
local brightness_widget = require("widgets.brightness-widget.brightness")

local my_hotkeys_popup = hotkeys_popup.widget.new({
	width = 1600,
	height = 900,
	group_margin = 20,
	labels = {
		["#19"] = "n",
		Tab = "(Tab)",
		Return = "(Enter)",
		Print = "(PrtSc)",
		Mod1 = "(A)",
		Mod4 = "(M)",
		Control = "(C)",
		Shift = "(S)",
		XF86AudioMute = "F01 󰖁",
		XF86AudioLowerVolume = "F02 󰝝",
		XF86AudioRaiseVolume = "F03 󰝞",
		XF86AudioMicMute = "F04 🎤",
		XF86MonBrightnessDown = "F05 󰽥",
		XF86MonBrightnessUp = "F06 󰖨",
		XF86Display = "F07 󰌢",
		XF86LAN = "F08 󰖪",
		XF86Tools = "F09 󰒓",
		XF86Bluetooth = "F10 ",
		XF86WakeUp = "F11 󰌌",
		XF86Favorites = "F12 󰓎",
	}
})

local home = os.getenv("HOME")

local scripts = home .. "/.scripts"

local M = {}

M.init = function()
	-- mouse global bindings
	root.buttons(gears.table.join(
		awful.button({}, 4, awful.tag.viewnext),
		awful.button({}, 5, awful.tag.viewprev)
	))

	-- mouse client bindings
	clientbuttons = gears.table.join(
		awful.button({}, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
		end),
		awful.button({ modkey }, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({ modkey }, 3, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	-- global bindings
	globalkeys = gears.table.join(

	-- awesome group
		awful.key({ modkey, "Shift" }, "/", function() my_hotkeys_popup:show_help() end,
			{ description = "Show help", group = "4 - awesome" }),
		awful.key({ modkey, "Control" }, "r", awesome.restart,
			{ description = "Reload awesome", group = "4 - awesome" }),
		awful.key({ modkey, altkey, "Shift", "Control" }, "r", awesome.quit,
			{ description = "Quit awesome", group = "4 - awesome" }),
		awful.key({ modkey, "Control", "Shift" }, "x",
			function()
				awful.prompt.run {
					prompt       = "Run Lua code: ",
					textbox      = awful.screen.focused().mypromptbox.widget,
					exe_callback = awful.util.eval,
					history_path = awful.util.get_cache_dir() .. "/history_eval"
				}
			end,
			{ description = "Lua prompt", group = "4 - awesome" }),
		awful.key({ modkey, "Shift" }, "r", function() awful.screen.focused().mypromptbox:run() end,
			{ description = "Prompt", group = "4 - awesome" }),
		-- open scratchpad
		awful.key({ modkey }, "`", function() scratch.toggle("alacritty --title '__scratchpad__'") end,
			{ description = "Open scratchpad terminal", group = "4 - awesome" }),

		-- tag group
		awful.key({ modkey, }, "Left", awful.tag.viewprev,
			{ description = "Previous", group = "1 - tag" }),
		awful.key({ modkey, }, "Right", awful.tag.viewnext,
			{ description = "Next", group = "1 - tag" }),
		awful.key({ modkey, "Control" }, "j", awful.tag.viewprev,
			{ description = "Previous", group = "1 - tag" }),
		awful.key({ modkey, "Control" }, "k", awful.tag.viewnext,
			{ description = "Next", group = "1 - tag" }),
		awful.key({ modkey, }, "Escape", awful.tag.history.restore,
			{ description = "Go back", group = "1 - tag" }),

		-- client group
		awful.key({ modkey, }, "j", function() awful.client.focus.byidx(1) end,
			{ description = "Next", group = "3 - client" }),
		awful.key({ modkey, }, "k", function() awful.client.focus.byidx(-1) end,
			{ description = "Previous", group = "3 - client" }),
		awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
			{ description = "Swap with next", group = "3 - client" }),
		awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
			{ description = "Swap with previous", group = "3 - client" }),
		awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
			{ description = "Go to urgent", group = "3 - client" }),
		awful.key({ modkey, }, "Tab",
			function()
				awful.client.focus.history.previous()
				if client.focus then client.focus:raise() end
			end,
			{ description = "go back", group = "3 - client" }),
		awful.key({ modkey, "Shift" }, "n",
			function()
				local c = awful.client.restore()
				if c then c:emit_signal("request::activate", "key.unminimize", { raise = true }) end
			end,
			{ description = "Restore minimized", group = "3 - client" }),

		-- layout group
		awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
			{ description = "Decrease master width", group = "2 - layout" }),
		awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
			{ description = "Increase master width", group = "2 - layout" }),
		awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
			{ description = "Increase master count", group = "2 - layout" }),
		awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
			{ description = "Decrease master count", group = "2 - layout" }),
		awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
			{ description = "Increase columns", group = "2 - layout" }),
		awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
			{ description = "Decrease columns", group = "2 - layout" }),
		awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
			{ description = "Next layout", group = "2 - layout" }),
		awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
			{ description = "Previous layout", group = "2 - layout" })
	)

	-- client bindings
	clientkeys = gears.table.join(
		awful.key({ modkey }, "q", function(c) c:kill() end,
			{ description = "Close client", group = "3 - client" }),
		awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
			{ description = "Toggle floating", group = "3 - client" }),
		awful.key({ modkey }, "m", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "Toggle fullscreen", group = "3 - client" }),
		awful.key({ modkey }, "t", function(c)
				local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))

				if current_layout == " [M] " then
					awful.layout.set(awful.layout.suit.tile)
				else
					awful.layout.set(awful.layout.suit.max)
				end

				if c.fullscreen then
					c.fullscreen = false
					awful.layout.set(awful.layout.suit.tile)
				end
			end,
			{ description = "Toggle max layout", group = "3 - client" }),
		awful.key({ modkey }, "z",
			function(c)
				if c == awful.client.getmaster() then
					awful.client.swap.byidx(1)
				else
					c:swap(awful.client.getmaster())
				end
			end,
			{ description = "Swap with master", group = "3 - client" }),
		awful.key({ modkey, "Shift" }, "t", function(c) c.ontop = not c.ontop end,
			{ description = "Toggle keep on top", group = "3 - client" }),
		awful.key({ modkey, }, "n", function(c) c.minimized = true end,
			{ description = "Minimize client", group = "3 - client" }),
		awful.key({ modkey, "Shift" }, "m",
			function(c)
				c.maximized = not c.maximized
				c:raise()
			end,
			{ description = "(un)maximize", group = "client" })
	)

	-- Bind 0-9 keys to tags.
	for i = 1, 9 do
		globalkeys = gears.table.join(globalkeys,
			awful.key({ modkey }, "#" .. i + 9,
				function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						tag:view_only()
					end
				end,
				{}),

			awful.key({ modkey, "Control" }, "#" .. i + 9,
				function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						awful.tag.viewtoggle(tag)
					end
				end,
				{}),

			awful.key({ modkey, "Shift" }, "#" .. i + 9,
				function()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:move_to_tag(tag)
							local screen = awful.screen.focused()
							local tag2 = screen.tags[i]
							tag2:view_only()
						end
					end
				end,
				{}),

			awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				function()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:toggle_tag(tag)
						end
					end
				end,
				{})
		)
	end

	-- bind 10th tag to 0
	globalkeys = gears.table.join(globalkeys,
		awful.key({ modkey }, "#19",
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[10]
				if tag then
					tag:view_only()
				end
			end,
			{ description = "View tag n", group = "1 - tag" }),

		awful.key({ modkey, "Control" }, "#19",
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[10]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{ description = "Toggle tag n", group = "1 - tag" }),

		awful.key({ modkey, "Shift" }, "#19",
			function()
				if client.focus then
					local tag = client.focus.screen.tags[10]
					if tag then
						client.focus:move_to_tag(tag)
						local screen = awful.screen.focused()
						local tag2 = screen.tags[10]
						tag2:view_only()
					end
				end
			end,
			{ description = "Move client to tag n", group = "1 - tag" }),
		awful.key({ modkey, "Control", "Shift" }, "#19",
			function()
				if client.focus then
					local tag = client.focus.screen.tags[10]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{ description = "Toggle client on tag n", group = "1 - tag" })
	)

	-- program keys --
	globalkeys = gears.table.join(globalkeys,

		-- 5 -media and scripts keys
		awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end, -- F1 Audio mute
			{ description = "Toggle mute", group = "5 - media/scripts" }),
		awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec(10) end, -- F2 Audio lower volume
			{ description = "Decrease volume", group = "5 - media/scripts" }),
		awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc(10) end, -- F3 Audio raise volume
			{ description = "Increase volume", group = "5 - media/scripts" }),
		-- F4 Audio mic mute
		awful.key({}, "XF86MonBrightnessDown", function() brightness_widget:dec() end,  -- F5 Decrease brightness
			{ description = "Decrease brightness", group = "5 - media/scripts" }),
		awful.key({}, "XF86MonBrightnessUp", function() brightness_widget:inc() end,    -- F6 Increase brightness
			{ description = "Increase brightness", group = "5 - media/scripts" }),
		awful.key({}, "XF86Display", function() awful.spawn(scripts .. "/rotate-screen") end, -- F7 Rotate screen
			{ description = "Rotate screen", group = "5 - media/scripts" }),
		-- F8 LAN
		awful.key({}, "XF86Tools", function() awful.spawn("thunderbird") end, -- F9 Mail
			{ description = "Mail", group = "5 - media/scripts" }),
		awful.key({}, "XF86Bluetooth", function() awful.spawn("blueberry") end, -- F10 Bluetooth
			{ description = "Bluetooth", group = "5 - media/scripts" }),
		-- F11 Wake up
		awful.key({}, "XF86Favorites", -- F12 Favorites
			function() awful.spawn("alacritty --title rofi-beats -e " .. scripts .. "/rofi-beats") end,
			{ description = "Rofi beats", group = "5 - media/scripts" }),

		-- scripts
		awful.key({ modkey }, "]", function() volume_widget:inc(10) end,
			{ description = "Increase volume", group = "5 - media/scripts" }),
		awful.key({ modkey }, "[", function() volume_widget:dec(10) end,
			{ description = "Decrease volume", group = "5 - media/scripts" }),
		awful.key({ modkey }, "\\", function() volume_widget:toggle() end,
			{ description = "Toggle mute", group = "5 - media/scripts" }),
		awful.key({ modkey, "Shift" }, "\\", function() volume_widget:set(100) end,
			{ description = "Set volume to 100", group = "5 - media/scripts" }),
		awful.key({ modkey }, "p", function() awful.spawn("playerctl play-pause") end,
			{ description = "Play/pause", group = "5 - media/scripts" }),
		awful.key({ modkey }, ".", function() awful.spawn("playerctl next") end,
			{ description = "Next", group = "5 - media/scripts" }),
		awful.key({ modkey }, ",", function() awful.spawn("playerctl previous") end,
			{ description = "Previous", group = "5 - media/scripts" }),
		awful.key({ modkey }, "b", function() awful.spawn(scripts .. "/bmks") end,
			{ description = "Repos bookmarks", group = "5 - media/scripts" }),
		awful.key({ modkey, "Shift" }, "b", function() awful.spawn(scripts .. "/bmks gh-repos") end,
			{ description = "Repos bookmarks", group = "5 - media/scripts" }),
		awful.key({ modkey, "Shift" }, "s", function() awful.spawn(scripts .. "/rotate-screen") end,
			{ description = "Rotate screen", group = "5 - media/scripts" }),


		-- 6 - special keys
		awful.key({ modkey, "Shift" }, "Return", function() awful.spawn(file_manager) end,
			{ description = "File manager", group = "6 - special" }),
		awful.key({}, "Print", function() awful.spawn("flameshot gui") end,
			{ description = "Screenshot", group = "6 - special" }),
		awful.key({ modkey }, "Print", function() awful.spawn("simple-scan") end,
			{ description = "Scanner", group = "6 - special" }),
		awful.key({ "Control", "Shift" }, "Escape", function() awful.spawn("gnome-system-monitor") end,
			{ description = "System monitor", group = "6 - special" }),
		awful.key({ modkey, "Shift" }, "x", function() awful.spawn("xkill") end,
			{ description = "Kill", group = "6 - special" }),
		awful.key({ modkey }, "v", function() awful.spawn("pavucontrol") end,
			{ description = "Volume control", group = "6 - special" }),
		awful.key({ modkey, "Control", "Shift" }, "v", function() awful.spawn("alacritty -e pulsemixer") end,
			{ description = "Audio mixer", group = "6 - special" }),

		-- 7 - dmenu keys
		awful.key({ modkey }, "r", function() awful.spawn("j4-dmenu-desktop") end,
			{ description = "Desktop applications", group = "7 - dmenu/rofi" }),
		awful.key({ modkey, "Shift" }, "c",
			function() awful.spawn("rofi -show calc -modi calc -no-show-match -no-sort") end,
			{ description = "Calculator", group = "7 - dmenu/rofi" }),
		awful.key({ altkey }, "Tab", function() awful.spawn("rofi -show window") end,
			{ description = "Clients", group = "7 - dmenu/rofi" }),
		awful.key({ modkey }, "F2", function() awful.spawn("rofi -show run") end,
			{ description = "Run", group = "7 - dmenu/rofi" }),
		awful.key({ modkey }, "F3", function() awful.spawn("rofi -show ssh") end,
			{ description = "SSH", group = "7 - dmenu/rofi" }),
		awful.key({ modkey }, "c",
			function() awful.spawn("rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'") end,
			{ description = "Clipboard", group = "7 - dmenu/rofi" }),
		awful.key({ modkey }, "/",
			function()
				awful.spawn.with_shell(
					"dmenu-emoji | dmenu -i -l 10 | awk '{print $1}' | tr -d '\n' | xclip -selection clipboard")
			end,
			{ description = "Emoji", group = "7 - dmenu/rofi" }),

		-- 8 - apps keys
		awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
			{ description = "Terminal", group = "8 - apps" }),
		awful.key({ modkey }, "f", function() awful.spawn("firefox") end,
			{ description = "Firefox", group = "8 - apps" }),
		awful.key({ modkey, "Shift" }, "f", function() awful.spawn("firefox-developer-edition") end,
			{ description = "Firefox developer edition", group = "8 - apps" }),
		awful.key({ modkey }, "g", function() awful.spawn("google-chrome-stable --no-default-browser-check") end,
			{ description = "Google chrome", group = "8 - apps" }),
		awful.key({ modkey, "Shift" }, "g",
			function() awful.spawn("google-chrome-unstable --no-default-browser-check") end,
			{ description = "Google chrome unstable", group = "8 - apps" }),
		awful.key({ modkey }, "w", function() awful.spawn("qutebrowser") end,
			{ description = "Qutebrowser", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "c", function() awful.spawn("alacritty --title cmus -e cmus") end,
			{ description = "Cmus", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "d", function() awful.spawn("discord") end,
			{ description = "Discord", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "e", function() awful.spawn(terminal) end,
			{ description = "Terminal", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "f", function() awful.spawn("freecad") end,
			{ description = "Freecad", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "g", function() awful.spawn("/opt/google-chat-linux/google-chat-linux %U") end,
			{ description = "Google chat", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "l", function() awful.spawn("libreoffice") end,
			{ description = "Libreoffice", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "s", function() awful.spawn("steam") end,
			{ description = "Steam", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "v", function() awful.spawn("vlc") end,
			{ description = "VLC", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "y", function() awful.spawn("alacritty --title ncspot -e ncspot") end,
			{ description = "Spotify", group = "8 - apps" }),
		awful.key({ modkey, altkey }, "z",
			function()
				awful.spawn(
					"/opt/google/chrome-unstable/google-chrome-unstable '--profile-directory=Profile 1' --app-id=hnpfjngllnobngcgfapefoaidbinmjnm")
			end,
			{ description = "Whatsapp", group = "8 - apps" })
	)

	-- Set keys
	root.keys(globalkeys)
end

return M
