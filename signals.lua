local awful = require("awful")
local beautiful = require("beautiful")

local M = {}

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

M.init = function()
	-- signal function to execute when a new client appears.
	client.connect_signal("manage", function(c)
		-- set master factor to 0.55 (only if there are 2 clients)
		if #c.screen.tiled_clients == 2 then
			awful.tag.setmwfact(0.55)
		end

		-- set new windows as slave
		if not awesome.startup then awful.client.setslave(c) end

		-- minimize terminal clients (swallow-like behavior)
		minimize_terminal(c)

		-- focus tag of new clients
		local t = c.first_tag
		awful.tag.viewonly(t)
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

	-- no border for maximized clients
	client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
	client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

	-- No borders when rearranging only 1 non-floating or maximized client
	screen.connect_signal("arrange", function(s)
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
