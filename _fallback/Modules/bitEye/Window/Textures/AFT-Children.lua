
local EditNoteField = bitEye.EditNoteField
local Layers = EditNoteField.Layers

-- Get background according to the BGChanges data table
local function lookUpBackgroundPath(dir, data)

	local songDir = GAMESTATE:GetCurrentSong():GetSongDir()

	for i=1,#dir do

		local s1 = dir[i]:gsub("%p","")
		local s2 = data.file1:gsub("%p","")
		local checkSongDir = dir[i]:match(songDir)

		if s1:match(s2) then
			if checkSongDir then return songDir .. data.file1 
			else return dir[i] end
		end
		
	end

	return false

end

return Def.ActorFrame{
	InitCommand=function(self) self:Center() end,
	bitEyeCommand=function(self)

		if not bitEye.EditNoteField.isVisible then return end

		local bgChanges = bitEye.BGChanges
		local path = GAMESTATE:GetCurrentSong():GetSongDir()

		local bga_directory = FILEMAN:GetDirListing("/BGAnimations/", false, true)
		local rm_directory = FILEMAN:GetDirListing("/RandomMovies/", false, true)
		local songDirectory = FILEMAN:GetDirListing(path, false, true)

		local currentBeat, i = GAMESTATE:GetSongBeat()
		
		if #bgChanges == 1 and currentBeat == bgChanges[1].start_beat then i = 1 end

		for k=2,#bgChanges do

			local current = bgChanges[k - 1]
			local nextChange = bgChanges[k]

			local last = currentBeat == nextChange.start_beat and k == #bgChanges

			-- in the middle
			local b = currentBeat >= current.start_beat
			b = b and currentBeat < nextChange.start_beat and not last

			-- Last BGChange
			if last then i = k break end

			if b then i = k - 1 break end

		end

		if not i then
			local window = bitEye.EditNoteField			window:playcommand("Hide")
			window.isVisible = false 		return 
		end

		self:RemoveAllChildren()

		local data = bgChanges[i]

		local bga_path = lookUpBackgroundPath(bga_directory, data)
		bga_path = bga_path and bga_path .. "/default.lua"

		local rm_path = lookUpBackgroundPath(rm_directory, data)
		local songPath = lookUpBackgroundPath(songDirectory, data)

		if songPath and ( bga_path or rm_path ) then 
			bga_path = false		rm_path = false
		end

		self:AddChildFromPath( bitEye.Path .. "Window/Background.lua" )
		Layers.Background = bitEye.getLastChild(self)

		if not bga_path and not rm_path and not songPath then
			self:AddChildFromPath( bitEye.Path .. "Window/404Actor.lua" )
			Layers.Missing = bitEye.getLastChild(self)
		end

		if bga_path then self:AddChildFromPath(bga_path) end
		if rm_path then self:AddChildFromPath(rm_path) end

		if songPath then
			if not data.file1:match('%.') then songPath = songPath .. "/default.lua" end
			self:AddChildFromPath(songPath)
		end

		Layers.Animation = bitEye.getLastChild(self)

		self:AddChildFromPath( bitEye.Path .. "Window/Overlay.lua" )
		Layers.Overlay = self:GetChild("bitEyeOverlay")

		local animation = Layers.Animation
		local isStatic = tostring( animation ):match("Sprite")
		if isStatic then animation:scale_or_crop_background() end

		self:playcommand("On")		bitEye.uiScale(Layers.Overlay)
		
	end
}
