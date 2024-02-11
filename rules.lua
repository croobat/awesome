local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

local M = {}

M.init = function()
	-- tags
	web = "1"
	dev = "2"
	app = "3"
	ide = "4"
	doc = "5"
	play = "6"
	talk = "7"
	chat = "8"
	fun = "9"
	back = "10"

	-- Rules to apply to new clients (through the "manage" signal)
	-- WM_CLASS(STRING) = instance, class
	-- WM_NAME(STRING) = name
	awful.rules.rules = {
		-- All clients.
		{
			rule = {},
			properties = {
				border_width = beautiful.border_width,
				border_color = beautiful.border_normal,
				focus = awful.client.focus.filter,
				raise = true,
				keys = clientkeys,
				buttons = clientbuttons,
				screen = awful.screen.preferred,
				placement = awful.placement.no_overlap + awful.placement.no_offscreen
			}
		},

		-- Scratchpad rules
		{
			rule_any = {
				name = { "__scratchpad__" }
			},
			properties = {
				skip_taskbar = false,
				floating = true,
				ontop = false,
				minimized = true,
				sticky = false,
				width = screen_width * 0.8,
				height = screen_height * 0.8,
			},
			callback = function(c)
				awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
				gears.timer.delayed_call(function()
					c.urgent = false
				end)
			end
		},


		-- Floating clients.
		{
			rule_any = {
				instance = {
					"DTA",   -- Firefox addon DownThemAll
					"copyq", -- Includes session name in class
					"pinentry", -- GPG key password entry
					"peek",  -- Peek Gif Recorder
					"gcolor3", -- GTK color picker
					"kdeconnect-app", -- KDE Connect
					"pavucontrol", -- Pulseaudio volume control
					"gnome-system-monitor", -- System monitor
					"simple-scan", -- Scanner
				},
				class = {
					"Arandr", -- Screen layout editor
					"Blueman-manager", -- Bluetooth manager
					"Gpick", -- Color picker
					"Kruler", -- Pixel ruler
					"MessageWin", -- Quassel
					"Sxiv", -- Image viewer
					"Tor Browser", -- Needs a fixed window size to avoid fingerprinting
					"Wpa_gui", -- WPA supplicant graphical frontend
					"veromix", -- Veromix
					"xtightvncviewer" }, -- VNC client
				"Gitk",   -- GTK git history viewer
				name = {
					"Event Tester", -- xev
					"Emulator", -- android studio emulator
				},
				role = {
					"AlarmWindow", -- Thunderbird's calendar
					"ConfigManager", -- Thunderbird's about:config
					"pop-up", -- e.g. Google Chrome's (detached) Developer Tools
				}
			},
			properties = { floating = true }
		},

		-- Remove titlebars from normal clients and dialogs
		{
			rule_any = { type = { "normal", "dialog" } },
			properties = { titlebars_enabled = false }
		},

		-- Default tags for apps
		{
			rule_any = {
				instance = {
					"qutebrowser",
					"google-chrome",
					"google-chrome-unstable",
				},
				class = {
					"firefox",
					"firefoxdeveloperedition",
				},
			},
			properties = { tag = "Web" }
		},
		{
			rule_any = {
				instance = {
					"gimp-2.10",
					"com.github.johnfactotum.Foliate",
					"reactotron",
				},
			},
			properties = { tag = "App" }
		},
		{
			rule_any = {
				instance = {
					"code",
					"DBeaver",
					"postman",
				},
			},
			properties = { tag = "Ide" }
		},
		{
			rule_any = {
				instance = {
					"libreoffice",
				},
				class = {
					"Godot",
					"calibre",
				},
			},
			properties = { tag = "Doc" }
		},
		{
			rule_any = {
				name = {
					"cmus",
					"ncspot",
					"rofi-beats",
				},
			},
			properties = { tag = "Play" }
		},
		{
			rule_any = {
				class = {
					"discord",
					"zoom",
				},
			},
			properties = { tag = "Talk" }
		},
		{
			rule_any = {
				instance = {
					"slack",
					"google-chat-linux",
					"whatsapp-nativefier-d40211",
				},
			},
			properties = { tag = "Chat" }
		},
		{
			rule_any = {
				instance = {
					"trello",
					"whale",
					"notion",
				},
				class = {
					"jetbrains-toolbox",
					"steam",
				},
			},
			properties = { tag = "Fun" }
		},
		{
			rule_any = {
				instance = {
					"simplescreenrecorder",
					"qbittorrent",
				},
				class = {
					"thunderbird",
				},
			},
			properties = { tag = "Back" }
		},
	}
end

return M
