
local SearchBox = {
	input = "",		results = {},		charLimit = 0
}

local function redirectInput(b)
	local pn = 'PlayerNumber_P'
	for i=1,2 do SCREENMAN:set_input_redirected( pn .. i, b ) end
end

local Box = Def.ActorFrame{

	InitCommand=function(self)

		bitEye.SearchBox = self

		self:diffusealpha(0)
		self.s = SearchBox.input

		self:SetUpdateFunction( function()

			local s = SearchBox.input
			local isVisible = SearchBox.isVisible
			local wasVisible = SearchBox.wasVisible

			if s ~= self.s then
				self:playcommand("Update")		self.s = s
			end

			if isVisible and not wasVisible then
				self:stoptweening():linear(0.25):diffusealpha(1)
				SearchBox.wasVisible = true			redirectInput(true)
			elseif not isVisible and wasVisible then
				self:stoptweening():linear(0.25):diffusealpha(0)
				SearchBox.wasVisible = false		redirectInput(false)
			end

		end )
		
	end,

	ForceCloseCommand=function(self) SearchBox.isVisible = false end,

	Def.Quad{

		Name="Background",
		InitCommand=function(self)

			self:zoomto( 320 * 0.75, 160 ):diffuse(Color.Black):diffusealpha(0.5)

			local w = self:GetZoomedWidth()			local h = self:GetZoomedHeight()
			local p = self:GetParent()

			p:xy( SCREEN_WIDTH - w * 0.675,	SCREEN_CENTER_Y - h )

		end

	},

	Def.BitmapText{
		
		Name="Input",		Font="Common normal",
		InitCommand=function(self)

			local p = self:GetParent()			local w = p:GetChild("Background")

			self.w = w:GetZoomedWidth()
			self:maxwidth(self.w):diffuse(Color.White)

		end,

		UpdateCommand=function(self)

			self:settext(SearchBox.input)

			local w = self:GetZoomedWidth()
			if w > self.w then self:zoom( w / self.w ) end

		end

	},

	Def.BitmapText{
		
		Name="Subtitle",		Font="Common normal",
		InitCommand=function(self)
			self.defaultColor = color("#808080")
			self:y(30):settext("Waiting for input.")
			self:diffuse(self.defaultColor)
		end,

		UpdateCommand=function(self)

			SearchBox.results = {}

			local r = SearchBox.results				local s = SearchBox.input
			local lim = SearchBox.charLimit			local dir = SearchBox.directory
			local color = #s <= lim and self.defaultColor or Color.Orange
			local text = "No results found"

			if #s >= lim then
				
				for i=1,#dir do
					local filePath = dir[i]:gsub("%p","")
					local input = s:gsub("%p","")
					if filePath:match( input ) then r[#r+1] = { i, dir[i] } end
				end

				r.Index = #r > 1 and 0
				r.Index = #r == 1 and 1 or r.Index
				if #r > 0 then color = #r == 1 and Color.Green or Color.Yellow end
				text = #r > 0 and #r .. " result" or text

			end
			
			self:diffuse(color):settext(text)

		end
	}

}

-- Inputs

local function inputToText( event )

	local isVisible = SearchBox.isVisible		local input = event.DeviceInput

	if input.down and isVisible then
			
		local s = SearchBox.input		local button = input.button
		button = button:gsub("DeviceButton", "")
	
		if #button > 2 then

			if button:match("_space") then button = " "
			elseif button:match("_KP %d") then button = button:gsub( "_KP ", "" )
			elseif button:match("backspace") then s = s:sub( 1, #s-1 )		button = ""
			else button = "" end

		end
	
		button = button:gsub( "_", "" )
	
		if SearchBox.capsOn then button = button:upper() end

		s = s .. button			SearchBox.input = s
	
	end
	
end

return Def.ActorFrame{

	Name="SearchBox", 	Box,
	OnCommand=function(self)

		local screen = SCREENMAN:GetTopScreen()
		local p = self:GetParent():GetParent()

		local function updateRow(i)

			local r = SearchBox.results

			if not r[i] then return end

			local pn = 'PlayerNumber_P1'
			local screen = SCREENMAN:GetTopScreen()
			local index = screen:GetCurrentRowIndex(pn)
			local row = screen:GetOptionRow(index)
			local choice = row:GetChoiceInRowWithFocus(pn)

			row:SetChoiceInRowWithFocus(pn, r[i][1]-1)
			p:playcommand("MenuRightP1")

		end

		local function logic(event)

			local input = event.DeviceInput			local button = input.button

			local isFirstPressed = event.type == "InputEventType_FirstPress"
			local isReleased = event.type == "InputEventType_Release"

			if input.down and isFirstPressed then

				local r = SearchBox.results

				if button:match("left ctrl") then SearchBox.isVisible = not SearchBox.isVisible end

				if r.Index then

					local i = r.Index

					if button:match("KP enter") then
							
						if #r > 1 then i = i < #r and i + 1 or i end
						updateRow(i)

					elseif button:match("KP .") then
							
						if #r > 1 then 
							i = i > 1 and i - 1 or i		updateRow(i)
						end

					end

					SearchBox.results.Index = i

				end

			end

			-- Uppercase
			if input.button:match("left shift") then
				SearchBox.capsOn = true
				if isReleased then SearchBox.capsOn = false end
			end

		end
		
		self:playcommand("ChangeRowMessage")
		screen:AddInputCallback( inputToText )
		screen:AddInputCallback( logic )

	end,

	ChangeRowMessageCommand=function(self)

		local pn = 'PlayerNumber_P1'
		local screen = SCREENMAN:GetTopScreen()
		local index = screen:GetCurrentRowIndex(pn)

		if index == 10 then
			SearchBox.directory = FILEMAN:GetDirListing("/BGAnimations/", true, true)
			SearchBox.charLimit = 5
		elseif index >= 11 and index <= 13 then
			SearchBox.directory = FILEMAN:GetDirListing("/RandomMovies/")
			SearchBox.charLimit = 3
		end

	end

}