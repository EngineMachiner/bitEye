bitEye = {}
bitEye.SPath = "/Scripts/bitEye/"

bitEye.Spawn = function(s) 
	return Def.ActorFrame{
		OnCommand=function(self)
			local p = bitEye.SPath 
			p = p .. "Window/"..s..".lua"
			self:AddChildFromPath(p)
		end
	}
end

bitEye.Scale = function(self, scale)
	self:zoom( scale )
	self:x( - SCREEN_CENTER_X * scale )
	self:y( - SCREEN_CENTER_Y * scale )
end

bitEye.UIScale = function(self)

	self:RunCommandsOnChildren(function(c)
		if c.Name == "bE-Overlay" and bitEye.AFT then
			bitEye.Scale(c, 0.5)	c:playcommand("AFT")
		end
	end)

end