
local OptionRow = bitEye.OptionRow
OptionRow.PlayerEnum = 'PlayerNumber_P1'		OptionRow.Layers = {}

local Layers = OptionRow.Layers

local function close(self)

	self:stoptweening():linear(0.25):diffusealpha(0)

	local box = bitEye.SearchBox
	box:playcommand("ForceClose")

end

local function Update(self)

	Layers = {}
	self:RemoveAllChildren()
	
	local screen, directory = SCREENMAN:GetTopScreen()
	local index, row, choice = OptionRow.index
	row = screen:GetOptionRow(index)
	choice = row:GetChoiceInRowWithFocus( OptionRow.PlayerEnum )
	choice = tonumber(choice)

	local isCustom = false
	for i=7,9 do isCustom = isCustom or index == i or index == i + 8 end

	local isBGA = index == 10 or index == 18
	local isRM = ( index > 10 and index < 14 ) or ( index > 18 and index < 22 )

	if not OptionRow.canShow then return end

	self:AddChildFromPath( bitEye.Path .. "Window/Background.lua" )
	Layers.Background = bitEye.getLastChild(self)

	-- Song custom background
	if isCustom then

		local cur = GAMESTATE:GetCurrentSong():GetSongDir()
		directory = FILEMAN:GetDirListing(cur, false, true)

		local filePath = directory[ choice + 1 ]
		if FILEMAN:DoesFileExist( filePath .. "/default.lua" ) then
			filePath = filePath .. "/default.lua"
		end

		self:AddChildFromPath( filePath )
		Layers.SongCustom = bitEye.getLastChild(self)

	end

	-- BGAnimations
	if isBGA then

		directory = FILEMAN:GetDirListing("/BGAnimations/", true, true)
		local filePath = directory[ choice + 1 ] .. "/default.lua"

		self:AddChildFromPath( filePath )
		Layers.BGA = bitEye.getLastChild(self)

	end

	-- RandomMovies
	if isRM then 

		directory = FILEMAN:GetDirListing("/RandomMovies/")
		local filePath = "/RandomMovies/" .. directory[ choice + 1 ]

		self:AddChildFromPath( filePath )
		Layers.RM = bitEye.getLastChild(self)

	end

	self:AddChildFromPath(bitEye.Path .. "Window/Overlay.lua")
	Layers.Overlay = bitEye.getLastChild(self)
	Layers.Overlay.Name = "bitEyeOverlay"

	for k,v in pairs( { Layers.SongCustom, Layers.RM } ) do
		if tostring(v):match("Sprite") then v:scale_or_crop_background() end
	end

	self:playcommand("On")		bitEye.setEffectTiming(self)
	bitEye.uiScale(Layers.Overlay)

end

local function onChangeRow(self)

	if self.isOff then return end

	OptionRow.canShow = false
	local isVisible = self.isVisible
	local screen = SCREENMAN:GetTopScreen()
	local index = screen:GetCurrentRowIndex( OptionRow.PlayerEnum )

	for i=7,18 do

		i = i > 11 and i + 5 or i

		if index == i then 
			OptionRow.canShow = true
			if isVisible then self.cooldown = 0 end
		break
		end
		
	end

	OptionRow.index = index

	if not OptionRow.canShow and isVisible then 
		self.isVisible = false		close(self) 
	end

end

-- Texture the window
local AFT = Def.ActorFrameTexture{ 

	InitCommand=function(self)

		local w = SCREEN_WIDTH * 2		local h = SCREEN_HEIGHT * 2

		self:setsize( w, h )
		self:EnableAlphaBuffer(true):EnableDepthBuffer(true)
		self:Create()

		OptionRow.Texture = self:GetTexture()
		
	end,

	Def.ActorFrame{
		InitCommand=function(self) OptionRow.AFT = self		self:Center() end
	}

}

local function refreshEditNoteField(self)

	self:RemoveAllChildren()		self.isOff = true

	local window = bitEye.EditNoteField			window.cooldown = window.limit
	window:playcommand("bitEye")

end

return Def.ActorFrame{

	Name="bitEye OptionRow", 	AFT,

	OffCommand=refreshEditNoteField,	CancelCommand=refreshEditNoteField,
	
	ChangeRowMessageCommand=onChangeRow,
	MenuLeftP1MessageCommand=onChangeRow,
	MenuRightP1MessageCommand=onChangeRow,

	OnCommand=function(self)

		self.isOff = false
		self.isVisible = false				self:diffusealpha(0)

		self:SetUpdateFunction( bitEye.createCooldown( self, "cooldown", "limit", function() Update( OptionRow.AFT )  end ) )

		SCREENMAN:GetTopScreen():AddInputCallback( function(event)

			local input = event.DeviceInput			local button = input.button
		
			if input.down then
	
				if button:match("_left alt") then

					self.isVisible = not self.isVisible

					local isVisible = self.isVisible

					if OptionRow.canShow and isVisible then
						self:stoptweening():linear(0.25):diffusealpha(1)
						Update( OptionRow.AFT ) 
					end
	
					if not isVisible then close(self) end

				end

				if button:match("_right ctrl") then

					self.isZoomed = not self.isZoomed

					local isZoomed = self.isZoomed
					for k,v in pairs( { ZoomOut = not isZoomed, ZoomIn = isZoomed } ) do
						if v then self:playcommand(k) break end
					end

				end

			end
					
		end )

	end,

	Def.Sprite{

		OnCommand=function(self)
			self.defaultZoom = 0.16
			self:CenterX():zoom(self.defaultZoom)
			self:SetTextureFiltering(false)
			self:SetTexture( OptionRow.Texture )
			self:y( self:GetZoomedHeight() * 0.5 )
			self:cropbottom( 0.25 ):croptop( 0.25 )
			self:faderight( 0.25 ):fadeleft( 0.25 )
		end,

		ZoomInCommand=function(self)
			self:stoptweening():linear(1):zoom(0.75):Center()
		end,

		ZoomOutCommand=function(self)
			self:stoptweening()
			self:linear(1):CenterX():zoom(self.defaultZoom)
			self:y( self:GetZoomedHeight() * 0.5 )
		end

	},

	loadfile( bitEye.Path .. "SearchBox.lua" )()

}