local sprite = "Sprite "		local actorFrame = "ActorFrame "
local renderTarget = "RageTextureRenderTarget "

bitEye = { OptionRow = {} }
bitEye.Path = "/Appearance/Themes/_fallback/Modules/bitEye/"

bitEye.spawn = function(s)
	return Def.ActorFrame{
		OnCommand=function(self)
			local p = bitEye.Path .. "Window/" .. s .. ".lua"
			self:AddChildFromPath(p)
		end
	}
end

bitEye.scale = function(self, scale)
	self:zoom( scale )
	self:xy( - SCREEN_CENTER_X * scale, - SCREEN_CENTER_Y * scale )
end

-- self is the overlay to scale
bitEye.uiScale = function(self)
	if bitEye.aftOverlap then 
		bitEye.scale(self, 0.5) 	bitEye.aftOverlap = false 
	end
end

-- Is this deprecated?
-- AFT's overlapping can change the position of the content
-- This is my temporal fix for that
bitEye.tweakAFTs = function(self)

	-- self (main) ~= actor (child)
	local function adjustRenderTargets(actor)

		local name = tostring(actor)
		
		if name:match(sprite) then

			local texture = actor:GetTexture()
			texture = tostring(texture)

			if texture:match(renderTarget) then

				self:RunCommandsOnChildren( function(child)

					if child.Name == "bitEyeOverlay" then
						child:xy( - w * 0.125, - h * 0.125 ):zoom( 0.5 )
					end

				end )

				local fov = actor:GetParent():GetFOV()
				actor:xy(0,0):zoom( 0.5 * fov )

			end

		end

		if name:match(actorFrame) then
			actor:RunCommandsOnChildren( function(child) adjustRenderTargets(child) end )
		end

	end

	adjustRenderTargets(self)

end

bitEye.setEffectTimingForChildren = function(self)
	self:RunCommandsOnChildren( function(child) bitEye.setEffectTiming(child) end )
end

bitEye.setEffectTiming = function(self)

	local s = tostring(self)

	self:effectclock("timer")
	self:set_tween_uses_effect_delta(false)

	if s:match(sprite) then self:set_use_effect_clock_for_texcoords(false)
	elseif s:match(actorFrame) then bitEye.setEffectTimingForChildren(self) end

end

bitEye.getLastChild = function(self) 
	local t = self:GetChild("")			return t[#t] 
end

bitEye.createCooldown = function( self, cooldownName, limitName, f )

	self[cooldownName] = -1					self[limitName] = 0.0625

	-- Returns the update function
	return function()
		-- Refreshing cooldown
		if self[cooldownName] >= self[limitName] then f(self) self[cooldownName] = -1
		elseif self[cooldownName] >= 0 then self[cooldownName] = self[cooldownName] + self:GetEffectDelta() end
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

return bitEye