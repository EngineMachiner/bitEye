return Def.ActorFrame{

	OnCommand=function(self)

		local s = bitEye.Path .. "Window/Textures/"

		self:AddChildFromPath(s .. "AFT.lua")
		self:AddChildFromPath(s .. "Sprite.lua")
		
	end

}