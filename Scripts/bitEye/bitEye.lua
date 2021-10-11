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