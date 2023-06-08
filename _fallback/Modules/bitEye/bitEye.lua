
bitEye = { OptionRow = {} }
bitEye.Path = "/Appearance/Themes/_fallback/Modules/bitEye/"

LoadModule("bitEye/Config.lua")

bitEye.spawn = function(s)

	if not s:match("%.lua") then s = s .. ".lua" end

	return Def.ActorFrame{ OnCommand=function(self)
		self:AddChildFromPath( bitEye.Path .. s )
	end }

end

bitEye.setEffectTimingForChildren = function(self)
	self:RunCommandsOnChildren( function(child) bitEye.setEffectTiming(child) end )
end

bitEye.setEffectTiming = function(self)

	local s = tostring(self)

	self:effectclock("timer"):set_tween_uses_effect_delta(false)

	if s:match("Sprite ") then self:set_use_effect_clock_for_texcoords(false)
	elseif s:match("ActorFrame ") then bitEye.setEffectTimingForChildren(self) end

end

bitEye.getLastChild = function(self) 
	local t = self:GetChild("")			
	if tostring(t):match("Frame") then return t[#t] else return t end
end

bitEye.createCooldown = function( self, cooldownName, limitName, f )

	self[cooldownName] = -1					self[limitName] = 0.0625

	-- Returns the update function
	return function()

		local cooldown = self[cooldownName]

		-- Refreshing cooldown
		if cooldown >= self[limitName] then f(self); self[cooldownName] = -1
		elseif cooldown >= 0 then self[cooldownName] = cooldown + self:GetEffectDelta() end

	end

end

bitEye.isCustom = function( rowIndex )

	local isCustom = false

	for i=7,9 do isCustom = isCustom or rowIndex == i or rowIndex == i + 8 end

	if rowIndex == 7 or rowIndex == 15 then return "isScript" end
	
	return isCustom
	
end

bitEye.isBGA = function( rowIndex ) return rowIndex == 10 or rowIndex == 18 end

bitEye.isRM = function( rowIndex )
	return ( rowIndex > 10 and rowIndex < 14 ) or ( rowIndex > 18 and rowIndex < 22 )
end