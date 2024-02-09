---------------------------
-- Default awesome theme --
---------------------------

local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local theme = {}

theme.font = "Recursive Mono Linear Static Medium 7"

-- colors
theme.col_black = "#282a36"
theme.col_white = "#f8f8f2"
theme.col_light_gray = "#44475a"
theme.col_blue = "#6272a4"
theme.col_cyan = "#8be9fd"
theme.col_green = "#50fa7b"
theme.col_orange = "#ffb86c"
theme.col_pink = "#ff79c6"
theme.col_purple = "#bd93f9"
theme.col_red = "#ff5555"
theme.col_yellow = "#f1fa8c"

-- backgrounds
theme.bg_normal     = theme.col_black
theme.bg_focus      = theme.col_light_gray
theme.bg_urgent     = theme.col_orange
theme.bg_minimize   = theme.col_black
theme.bg_systray    = theme.col_black

-- foregrounds
theme.fg_normal     = theme.col_white
theme.fg_focus      = theme.col_white
theme.fg_urgent     = theme.col_black
theme.fg_minimize   = theme.col_cyan

-- borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(2)
theme.border_normal = theme.col_black
theme.border_focus  = theme.col_purple
theme.border_marked = theme.col_red

-- taglist
local taglist_square_size = dpi(5)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- systray
theme.systray_icon_spacing = dpi(5)

--hotkeys
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_border_color = theme.col_purple
theme.hotkeys_modifiers_fg=theme.col_yellow
theme.hotkeys_font="Recursive Mono Linear Static 10"
theme.hotkeys_description_font="Recursive Mono Linear Static 10"

-- notifications
theme.notification_font = "Recursive Mono Linear Static 9"
theme.notification_bg = theme.col_black
theme.notification_fg = theme.col_purple
theme.notification_shape = gears.shape.rounded_rect
theme.notification_margin = dpi(0)
-- theme.notification_max_width = dpi(300)
-- theme.notification_max_height = dpi(80)
theme.notification_max_width = dpi(800)
theme.notification_max_height = dpi(300)

-- wallpaper
theme.wallpaper = "/home/tony/Pictures/wallpapers/one-piece/gear5-dim-2.png"

return theme
