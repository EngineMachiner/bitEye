
local SearchBox

local function redirectInput(b)
	local pn = 'PlayerNumber_P'
	for i=1,2 do SCREENMAN:set_input_redirected( pn .. i, b ) end
end

local function inputToText(event)

	local isVisible = SearchBox.isVisible	
	
	local input = event.DeviceInput

	if not ( input.down and isVisible ) then return end

	-- Parsing.

	local s = SearchBox.input		local button = input.button
	button = button:gsub( "DeviceButton", '' )

	if #button > 2 then

		if button:match("_space") then button = ' '
		elseif button:match("_KP %d") then button = button:gsub( "_KP ", '' )
		elseif button:match("backspace") then s = s:sub( 1, #s - 1 )		button = ''
		else button = '' end

	end

	button = button:gsub( '_', '' )

	if SearchBox.capsOn then button = button:upper() end

	s = s .. button			SearchBox.input = s			SearchBox:playcommand("Write")
	
end

local choiceKeys = { ["KP enter"] = 1, ["KP %."] = -1 }

local function setChoice(button)

	local r = SearchBox.results        if #r < 1 then return end
    
    local i = SearchBox.currentChoice or 0      local key

    for k,v in pairs(choiceKeys) do
        
        if button:match(k) then key = k     i = i + v      break end 
    
    end

    if not SearchBox.currentChoice and key == "KP enter" then i = #r end
    
    i = i % #r          if not key then SearchBox.currentChoice = nil return end

    SearchBox.currentChoice = i         i = i + 1

	
	local pn = 'PlayerNumber_P1'	-- Main player.
	local screen = SCREENMAN:GetTopScreen()
	local index = screen:GetCurrentRowIndex(pn)
	local row = screen:GetOptionRow(index)

	local setChoice = row.SetChoiceInRowWithFocus
	if setChoice then setChoice( row, pn, r[i].Index - 1 ) else return end

	-- Update bitEye preview.
	bitEye.OptionRow:playcommand("Load")

end

local function showAction(button)

	local allow = button:match("left ctrl") and bitEye.OptionRow.isVisible

	if not allow then return end

	SearchBox.isVisible = not SearchBox.isVisible

	if SearchBox.isVisible then SearchBox:playcommand("OpenBox")
	else SearchBox:playcommand("CloseBox") end

end

local function logic(event)

	local input = event.DeviceInput			local button = input.button

	local isFirstPressed = event.type:match("FirstPress")
	local isReleased = event.type:match("Release")

	if input.down and isFirstPressed then

		showAction(button)		setChoice(button)

	end

	-- Uppercase.
	if button:match("left shift") then
		SearchBox.capsOn = true		if isReleased then SearchBox.capsOn = false end
	end

end

return Def.ActorFrame {

	Name="Search Box", 			loadfile( bitEye.Path .. "OptionRow/SearchBox/Elements.lua" )(),

	OpenBoxCommand=function(self) redirectInput(true)		self:tweenAlpha(1) end,

	CloseBoxCommand=function(self)

		redirectInput(false)	self:tweenAlpha(0)

		if self.isVisible then self.isVisible = false end

	end,

	InitCommand=function(self)

		SearchBox = self;           self:diffusealpha(0):zoom( SCREEN_HEIGHT / 720 )

		-- Two theme scale offsets. One here and one in Elements.lua in the first quad function.

        self.tweenAlpha = function( self, alpha ) self:stoptweening():linear(0.25):diffusealpha(alpha) end

        self.clear = function(self) self.results = {}		self.input = ''     return self	end

	end,

	OnCommand=function(self)

        self:clear():playcommand("ChangeRowMessage")

		local screen = SCREENMAN:GetTopScreen()

		screen:AddInputCallback(inputToText)	screen:AddInputCallback(logic)

	end,

	ChangeRowMessageCommand=function(self)

        self:clear():GetChild(''):GetChild("Subtitle"):playcommand("Init")

		local pn = 'PlayerNumber_P1'
		local screen = SCREENMAN:GetTopScreen()
		local index = screen:GetCurrentRowIndex(pn)
		local path = GAMESTATE:GetCurrentSong():GetSongDir()
		
		local isBGA, isRM = bitEye.isBGA(index), bitEye.isRM(index)
		local isCustomScript = bitEye.isCustom(index) == "isScript"
		local isCustomContent = not isCustomScript and not isBGA and not isRM

		local directory = FILEMAN:GetDirListing(path)
		local onlyDirectories = FILEMAN:GetDirListing( path, true, false )
		local onlyFiles = tapLua.OutFox.FILEMAN.getFilesBy( onlyDirectories, { "%.png", "%.avi" }, false )

		local charLimit = self.charLimit
		local data = {
			{ isCustomScript, onlyDirs, 1 },
			{ isCustomContent, onlyFiles, 1 },
			{ isBGA, FILEMAN:GetDirListing("/BGAnimations/", true, true), charLimit },
			{ isRM, FILEMAN:GetDirListing("/RandomMovies/"), charLimit }
		}

		self.directory = false

		for _, pair in ipairs(data) do

			if pair[1] then self.directory = pair[2]		self.charLimit = pair[3] break end
			
		end

		self.directory = self.directory or {}

	end

}
