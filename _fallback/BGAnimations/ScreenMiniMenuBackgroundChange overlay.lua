-- WARNING: BitEye: You were not supposed to replace files, this could cause many issues!
-- It's better to add bitEye manually!

local bitEye = LoadModule("bitEye/bitEye.lua")
return Def.ActorFrame{ bitEye.spawn("OptionRow Window") }