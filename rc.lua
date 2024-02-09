pcall(require, "luarocks.loader")

require("awful.autofocus")
-- require("awful.hotkeys_popup.keys")

require("error_handling").init()
require("variables").init()
require("wibar").init()
require("bindings").init()
require("rules").init()
require("signals").init()
