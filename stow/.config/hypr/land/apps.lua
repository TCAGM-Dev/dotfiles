-- Set programs that you use

local apps = {}

apps.terminal = "kitty -1"
apps.fileManager = "kitty -1 -- yazi"
apps.menu = "qs ipc call launcher open"
apps.browser = "firefox"
apps.colorpicker = "~/.config/hypr/colorpicker.sh"
apps.powermenu = "rofi -show power -modes power -show-icons"
apps.top = "btop"

return apps