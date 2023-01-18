
local EditNoteField = bitEye.EditNoteField
local Layers = EditNoteField.Layers

-- Get background according to the BGChanges data table
local function lookUpBackgroundPath(dir, data)

	for i=1,#dir do

		local s1 = dir[i]:gsub("%p","")
		local s2 = data.file1:gsub("%p","")

		if s1:match(s2) then return dir[i] end
		
	end

	return false

end

return Def.ActorFrame{
	InitCommand=function(self) self:Center() end,
	bitEyeCommand=function(self)

		local bgChanges = bitEye.BGChanges
		local path = GAMESTATE:GetCurrentSong():GetSongDir()

		local bga_directory = FILEMAN:GetDirListing("/BGAnimations/", false, true)
		local rm_directory = FILEMAN:GetDirListing("/RandomMovies/", false, true)
		local songDirectory = FILEMAN:GetDirListing(path, false, true)

		local currentBeat, i = GAMESTATE:GetSongBeat()
		local firstChange, lastChange = bgChanges[1], bgChanges[#bgChanges]
		
		for k=2,#bgChanges do

			local current = bgChanges[k - 1]
			local nextChange = bgChanges[k]

			local b = currentBeat >= current.start_beat
			b = b and currentBeat < nextChange.start_beat

			if b then i = k - 1 break end

		end

		if not i then
			local window = bitEye.EditNoteField
			window:playcommand("Hide")
			window.isVisible = false 		return 
		end

		self:RemoveAllChildren()

		local data = bgChanges[i]

		local bga_path = lookUpBackgroundPath(bga_directory, data)
		bga_path = bga_path and bga_path .. "/default.lua"

		local rm_path = lookUpBackgroundPath(rm_directory, data)
		local songPath = lookUpBackgroundPath(songDirectory, data)

		self:AddChildFromPath( bitEye.Path .. "Window/Background.lua" )
		Layers.Background = bitEye.getLastChild(self)

		if not bga_path and not rm_path and not songPath then
			self:AddChildFromPath( bitEye.Path .. "Window/404Actor.lua" )
			Layers.Missing = bitEye.getLastChild(self)
		end

		if bga_path then self:AddChildFromPath(bga_path) end
		if rm_path then self:AddChildFromPath(rm_path) end

		if songPath then

			if FILEMAN:DoesFileExist( songPath .. "/default.lua" ) then
				songPath = songPath .. "/default.lua"
			end

			self:AddChildFromPath(songPath)

		end

		Layers.Animation = bitEye.getLastChild(self)

		self:AddChildFromPath( bitEye.Path .. "Window/Overlay.lua" )
		Layers.Overlay = bitEye.getLastChild(self)
		Layers.Overlay.Name = "bitEyeOverlay"

		local animation = Layers.Animation
		local isStatic = tostring( animation ):match("Sprite")
		if isStatic then animation:scale_or_crop_background() end

		self:playcommand("On")		bitEye.uiScale(Layers.Overlay)
		
	end
}