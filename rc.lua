pcall(require, "luarocks.loader")

require("awful.autofocus")

require("error_handling").init()
require("variables").init()
require("wibar").init()
require("bindings").init()
require("rules").init()
require("signals").init()

-- NOTE: check if file chooser doesn't work, try installing dbus-daemon-units instead of dbus-broker-units
