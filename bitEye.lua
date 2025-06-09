
bitEye = { OptionRow = {}, Actors = {} }


local isLegacy = tapLua.isLegacy()

local path = "/Appearance/Themes/_fallback/Modules/bitEye/"

bitEye.Path = isLegacy and "/Modules/bitEye/" or path


LoadModule("bitEye/Config.lua")             LoadModule("bitEye/Actor.lua")
