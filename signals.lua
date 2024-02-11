local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local scratch = require("widgets.scratchpad")

local M = {}

-- Helper functions {{{
local function is_terminal(c)
	return (c.class and c.class:match("Alacritty")) and true or false
end

local function copy_size(c, parent_client)
	if not c or not parent_client then
		return
	end
	if not c.valid or not parent_client.valid then
		return
	end
	c.x = parent_client.x;
	c.y = parent_client.y;
	c.width = parent_client.width;
	c.height = parent_client.height;
end

local function minimize_terminal(c)
	if awesome.startup then return end

	if is_terminal(c) then
		return
	end
	local parent_client = awful.client.focus.history.get(c.screen, 1)

	local awesome_config_folder = os.getenv("HOME") .. "/.config/awesome/"

	local pid = c.pid or ""

	awful.spawn.easy_async('bash ' .. awesome_config_folder .. 'utils/check_parent.sh gppid ' .. pid, function(gppid)
		awful.spawn.easy_async('bash ' .. awesome_config_folder .. 'utils/check_parent.sh ppid ' .. pid, function(ppid)
			if parent_client and (gppid:find('^' .. parent_client.pid) or ppid:find('^' .. parent_client.pid)) and is_terminal(parent_client) then
				parent_client.child_resize = c
				parent_client.minimized = true

				c:connect_signal("unmanage", function() parent_client.minimized = false end)

				-- c.floating=true
				copy_size(c, parent_client)
			end
		end)
	end)
end

local function move_mouse_onto_focused_client()
	if awesome.startup then return end

	local c = client.focus

	if c then
		gears.timer({
			timeout = 0.01,
			autostart = true,
			single_shot = true,
			callback = function()
				if mouse.object_under_pointer() ~= c then
					local geometry = c:geometry()
					local x = geometry.x + geometry.width / 2
					local y = geometry.y + geometry.height / 2
					mouse.coords({ x = x, y = y }, true)
				end
			end
		})
	end
end
-- }}}

M.init = function()
	-- when a new client appears
	client.connect_signal("manage", function(c)
		local t = c.first_tag

		-- set master factor to 0.55 (only if there are 2 clients)
		if #c.screen.tiled_clients == 2 then
			t.master_width_factor = 0.55
		end

		-- set new windows as slave
		if not awesome.startup then awful.client.setslave(c) end

		-- minimize terminal clients (swallow-like behavior)
		minimize_terminal(c)

		-- focus tag of new clients
		t:view_only(t)
		c:emit_signal("request::activate", "manage", { raise = true })

		-- if client is floating, center it
		if c.floating then
			awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
		end
	end)

	-- Enable sloppy focus, so that focus follows mouse.
	client.connect_signal("mouse::enter", function(c)
		c:emit_signal("request::activate", "mouse_enter", { raise = false })
	end)

	-- when a client is focused
	client.connect_signal("focus", function(c)
		-- no border for maximized clients
		c.border_color = beautiful.border_focus

		-- move mouse onto focused client
		move_mouse_onto_focused_client()
	end)

	-- when a client is unfocused
	client.connect_signal("unfocus", function(c)
		-- no border for maximized clients
		c.border_color = beautiful.border_normal
	end)

	-- when a client is swapped
	client.connect_signal("swapped", function()
		-- move mouse onto focused client
		move_mouse_onto_focused_client()
	end)

	-- when a client is closed
	client.connect_signal("unmanage", function()
		-- move mouse onto focused client
		move_mouse_onto_focused_client()
	end)

	tag.connect_signal("property::selected", function()
		scratch.turn_off_all()
	end)

	-- when arranging the screen
	screen.connect_signal("arrange", function(s)
		-- No borders when rearranging only 1 non-floating client
		local only_one = #s.tiled_clients == 1
		local is_layout_max = awful.layout.getname(awful.layout.get(s)) == " [M] "
		for _, c in pairs(s.clients) do
			if (only_one or is_layout_max) and not c.floating or c.maximized then
				c.border_width = 0
			else
				c.border_width = beautiful.border_width
			end
		end
	end)
end

return M
