
bitEye = { OptionRow = {}, Actors = {} }


local path = "/Appearance/Themes/_fallback/Modules/bitEye/"

local isLegacy = tapLua.isLegacy()

bitEye.Path = isLegacy and "/Modules/bitEye/" or path


LoadModule("bitEye/Config.lua")             LoadModule("bitEye/Actor.lua")
