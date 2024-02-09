local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local battery_widget = require("widgets.battery-widget")
local volume_widget = require("widgets.volume-widget.volume")
local cmus_widget = require("widgets.cmus")

local M = {}

M.init = function()
	mytextclock = wibox.layout.margin(
		wibox.widget.textclock('%y-%m-%d %H:%M '),
		5, 0, 0, 0)

	myBattery = battery_widget {
		ac_prefix = "AC: ",
		battery_prefix = {
			{ 20,  "#--- " },
			{ 40,  "##-- " },
			{ 60,  "###- " },
			{ 100, "#### " },
		},
		percent_colors = {
			{ 20,  beautiful.col_red },
			{ 40,  beautiful.col_yellow },
			{ 999, beautiful.col_green }
		},
		alert_title = "Low battery!",
		widget_font = beautiful.font,
	}

	myVolume = wibox.layout.margin(
		volume_widget {
			card = 0,
			widget_type = "icon",
		},
		0, 5, 0, 0)

	mysystray = wibox.layout.margin(
		wibox.widget.systray(true),
		0, 5, 0, 0)

	myCmus = wibox.layout.margin(
		cmus_widget(),
		10, 0, 0, 0)

	-- tags buttons
	local taglist_buttons = gears.table.join(
		awful.button({}, 1, function(t) t:view_only() end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
		awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
	)

	-- opened windows buttons
	local tasklist_buttons = gears.table.join(
		awful.button({}, 1, function(c)
			if c == client.focus then
				c.minimized = true
			else
				c:emit_signal(
					"request::activate",
					"tasklist",
					{ raise = true }
				)
			end
		end),
		awful.button({}, 3, function()
			awful.menu.client_list({ theme = { width = 250 } })
		end),
		awful.button({}, 4, function()
			awful.client.focus.byidx(1)
		end),
		awful.button({}, 5, function()
			awful.client.focus.byidx(-1)
		end))

	-- wallpaper
	local function set_wallpaper(s)
		-- Wallpaper
		if beautiful.wallpaper then
			local wallpaper = beautiful.wallpaper
			-- If wallpaper is a function, call it with the screen
			if type(wallpaper) == "function" then
				wallpaper = wallpaper(s)
			end
			gears.wallpaper.maximized(wallpaper, s, true)
		end
	end

	-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
	screen.connect_signal("property::geometry", set_wallpaper)

	awful.screen.connect_for_each_screen(function(s)
		-- Wallpaper
		set_wallpaper(s)

		-- tag table
		local names = { "Web", "Dev", "App", "Ide", "Doc", "Play", "Talk", "Chat", "Fun", "Back" }
		local l = awful.layout.suit
		local layouts = { l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile }
		awful.tag(names, s, layouts)

		-- Create an imagebox widget which will contain an icon indicating which layout we're using.
		-- We need one layoutbox per screen.
		s.mylayoutbox = awful.widget.layoutbox(s)
		s.mylayoutbox:buttons(gears.table.join(
			awful.button({}, 1, function() awful.layout.inc(1) end),
			awful.button({}, 3, function() awful.layout.inc(-1) end),
			awful.button({}, 4, function() awful.layout.inc(1) end),
			awful.button({}, 5, function() awful.layout.inc(-1) end)))

		-- Create a taglist widget
		s.mytaglist = awful.widget.taglist {
			screen  = s,
			filter  = awful.widget.taglist.filter.all,
			layout  = {
				spacing = 5,
				layout  = wibox.layout.fixed.horizontal
			},
			buttons = taglist_buttons
		}

		-- Create a promptbox for each screen
		s.mypromptbox = awful.widget.prompt { prompt = "Run: ", bg = "#ffb86c", fg = "#282a36" }

		-- Create a tasklist widget
		s.mytasklist = awful.widget.tasklist {
			screen          = s,
			filter          = awful.widget.tasklist.filter.currenttags,
			buttons         = tasklist_buttons,
			style           = {
				shape_border_width = 1,
				shape_border_color = '#777777',
				shape              = gears.shape.rounded_rect,
			},
			layout          = {
				spacing = 5,
				layout  = wibox.layout.flex.horizontal,
			},
			widget_template = {
				{
					{
						{
							id     = 'text_role',
							widget = wibox.widget.textbox,
						},
						layout = wibox.layout.fixed.horizontal,
					},
					left   = 10,
					right  = 10,
					widget = wibox.container.margin
				},
				id     = 'background_role',
				widget = wibox.container.background,
			},
		}

		-- Create the wibox
		s.mywibox = awful.wibar({ position = "top", screen = s })

		-- Add widgets to the wibox
		s.mywibox:setup {
			layout = wibox.layout.align.horizontal,
			-- left widgets
			{
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
				s.mylayoutbox,
				s.mypromptbox,
			},
			-- middle widgets
			s.mytasklist,
			-- right widgets
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 10,
				myCmus,
				mysystray,
				myVolume,
				myBattery,
				mytextclock,
			},
		}
	end)
end

return M
