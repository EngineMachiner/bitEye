
-- To find in case it's missing
local function SearchFiles(dir, tbl)
	for m=1,#dir do
		local s1 = dir[m]:gsub("%p","")
		local s2 = tbl.file1:gsub("%p","")
		if s1:match(s2) then
			return dir[m]
		end
		if m == #dir then 
			return false
		end
	end
end

return Def.ActorFrame{
	bitEyeCommand=function(self)
		
		self:Center()

		local s = bitEye.SPath

		local BGA_dir = FILEMAN:GetDirListing("/BGAnimations/", false, true)
		local RM_dir = FILEMAN:GetDirListing("/RandomMovies/", false, true)
		local cur = GAMESTATE:GetCurrentSong():GetSongDir()
		local Song_dir = FILEMAN:GetDirListing(cur, false, true)

		local i = self:GetParent().Index
		local temp = bitEye.Info.BGChanges[i]

		local bga_path = SearchFiles(BGA_dir, temp)
		local rm_path = SearchFiles(RM_dir, temp)
		local song_path = SearchFiles(Song_dir, temp)

		self:AddChildFromPath( s .. "Window/Background.lua")
		bitEye.ChldName(self, "bE-Background")

		if not bga_path and not rm_path and not song_path then
			self:AddChildFromPath(s .. "Window/404Actor.lua")
			bitEye.ChldName(self, "bE-404")
		end

		bga_path = bga_path and bga_path .. "/default.lua"
		if bga_path then self:AddChildFromPath(bga_path) end
		if rm_path then self:AddChildFromPath(rm_path) end
		if song_path then self:AddChildFromPath(song_path) end
		bitEye.ChldName(self, "bE-Custom")

		self:AddChildFromPath(s .. "Window/Overlay.lua")
		bitEye.ChldName(self, "bE-Overlay")

		local s = bga_path  or rm_path
		s = s or song_path

		self:RunCommandsOnChildren(function(a)
			if s and s:sub(#s-3,#s) ~= ".lua"
			and a.Name == "bE-Custom" then
				local w = SCREEN_WIDTH 
				local h = SCREEN_HEIGHT
				a:x( a:GetX() + w * 0.5 )
				a:y( a:GetY() + h * 0.5 )
				a:scale_or_crop_background()
			end
		end)
		self:playcommand("On")
		bitEye.AFT_IssueFix(self)
		
	end
}