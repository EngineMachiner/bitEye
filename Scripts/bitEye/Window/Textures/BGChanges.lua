return Def.ActorFrame{
	InitCommand=function(self)
		self:playcommand("Refresh")
	end,
	bitEyeCommand=function(self)
		local s = bitEye.SPath
		s = s .. "Window/Textures/"
		local BGChanges = GAMESTATE:GetCurrentSong()
		BGChanges = BGChanges:GetBGChanges()
		bitEye.Info.BGChanges = BGChanges
		for i=1,#BGChanges do
			self:AddChildFromPath(s .. "AFT.lua")
			self:AddChildFromPath(s .. "Sprite.lua")
			self:RunCommandsOnChildren(function(c)
				if not c.Index then c.Index = i end
			end)
		end
	end,
	RefreshCommand=function(self)
		bitEye.Info.Data.Textures = {}
		self:RemoveAllChildren()
		self:queuecommand("bitEye")
	end
}