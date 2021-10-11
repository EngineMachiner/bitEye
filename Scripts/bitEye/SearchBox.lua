

local SearchBox = { 
	String = "",
	Results = {},
	IsVisible = false,
	CharLim = 0
}

local Box = Def.ActorFrame{

	InitCommand=function(self)

		self:diffusealpha(0)
		self.Container = {}
		self.s = SearchBox.String
		self:SetUpdateFunction(function()

			local c = self.Container
			local v = SearchBox.IsVisible
			local s = SearchBox.String

			if s ~= self.s then
				self:playcommand("Update")
				self.s = s
			end

			if v and not c[1] then
				self:stoptweening()
				self:linear(0.25):diffusealpha(1)
				c[1] = true
			elseif not v and c[1] then
				self:stoptweening()
				self:linear(0.25):diffusealpha(0)
				c[1] = false
			end

		end)
		
	end,

	Def.Quad{
		Name="Background",
		InitCommand=function(self)
			self:zoomto( 320 * 0.75, 160 )
			self:diffuse(Color.Black)
			self:diffusealpha(0.5)
			local w = self:GetZoomedWidth()
			local h = self:GetZoomedHeight()
			local p = self:GetParent()
			p:x( SCREEN_WIDTH - w * 0.675 )
			p:y( SCREEN_CENTER_Y - h )
		end
	},

	Def.BitmapText{
		Name="Input",
		Font="Common normal",
		InitCommand=function(self)
			local p = self:GetParent()
			local w = p:GetChild("Background")
			self.w = w:GetZoomedWidth()
			self:maxwidth(self.w)
			self:diffuse(Color.White)
		end,
		UpdateCommand=function(self)
			self:settext(SearchBox.String)
			if self:GetZoomedWidth() > self.w then
				self:zoom( self:GetZoomedWidth() / self.w )
			end
		end
	},

	Def.BitmapText{
		Name="Subtitle",
		Font="Common normal",
		InitCommand=function(self)
			self.DefCol = color("#808080")
			self:y(30)
			self:settext("Waiting for input.")
			self:diffuse(self.DefCol)
		end,
		UpdateCommand=function(self)

			SearchBox.Results = {}
			local r = SearchBox.Results
			local s = SearchBox.String
			local lim = SearchBox.CharLim
			local dir = SearchBox.Dir
			local c = #s <= lim and self.DefCol or Color.Orange
			local text = "No results found"

			if #s >= lim then
				
				for i=1,#dir do
					if dir[i]:gsub("%p",""):match(s:gsub("%p","")) then 
						r[#r+1] = { i, dir[i] }
					end
				end

				r.Index = #r > 1 and 0
				r.Index = #r == 1 and 1 or r.Index
				if #r > 0 then
					c = #r == 1 and Color.Green or Color.Yellow
				end
				text = #r > 0 and #r .. " result" or text

			end
			
			self:diffuse(c)
			self:settext(text)

		end
	}

}

-- Inputs

local function InputToText( event )

	local v = SearchBox.IsVisible
	local DI = event.DeviceInput
	if DI.down and v then
			
		local s = SearchBox.String
		local rec = DI.button
		rec = rec:gsub("DeviceButton", "")
	
		if #rec > 2 then
			if rec:match("_space") then
				rec = " "
			elseif rec:match("_KP %d") then
				rec = rec:gsub( "_KP ", "" )
			elseif rec:match("backspace") then
				s = s:sub( 1, #s-1 )
				rec = ""
			else
				rec = ""
			end
		end
	
		rec = rec:gsub( "_", "" )
	
		if SearchBox.Caps then
			rec = rec:upper()
		end
		s = s .. rec
		SearchBox.String = s
	
	end
	
end

return Def.ActorFrame{

	Name="SearchBox", Box,

	OnCommand=function(self)

		local p = self:GetParent():GetParent()
		local function UpdateRow(i)
			local r = SearchBox.Results
			if not r[i] then return end
			local pn = 'PlayerNumber_P1'
			local screen = SCREENMAN:GetTopScreen()
			local index = screen:GetCurrentRowIndex(pn)
			local row = screen:GetOptionRow(index)
			local choice = row:GetChoiceInRowWithFocus(pn)
			row:SetChoiceInRowWithFocus(pn, r[i][1]-1)
			p:playcommand("MenuRightP1")
		end

		local function ExtraInputs(event)

			local DI = event.DeviceInput
			local a = event.type == "InputEventType_FirstPress"
	
			if DI.down and a then
		
				local butt = DI.button
				if butt:match("left ctrl") then
					local v = SearchBox.IsVisible
					SearchBox.IsVisible = not v
				end
			
				local r = SearchBox.Results
				if r.Index then

					local i = r.Index
					if butt:match("KP enter") then
							
						if #r > 1 then
							i = i < #r and i + 1 or i
						end
						UpdateRow(i)

					elseif butt:match("KP .") then
							
						if #r > 1 then
							i = i > 1 and i - 1 or i
							UpdateRow(i)
						end

					end
					SearchBox.Results.Index = i

				end

			end

			-- Uppercase
			a = event.type == "InputEventType_Release"
			if DI.button:match("left shift") then
				SearchBox.Caps = true
				if a then SearchBox.Caps = false end
			end

		end
		
		self:playcommand("ChangeRowMessage")
		SCREENMAN:GetTopScreen():AddInputCallback( InputToText )
		SCREENMAN:GetTopScreen():AddInputCallback( ExtraInputs )

	end,

	ChangeRowMessageCommand=function(self)
		local pn = 'PlayerNumber_P1'
		local screen = SCREENMAN:GetTopScreen()
		local index = screen:GetCurrentRowIndex(pn)
		if index == 10 then
			local d = FILEMAN:GetDirListing("/BGAnimations/", true, true)
			SearchBox.Dir = d SearchBox.CharLim = 5
		elseif index >= 11 and index <= 13 then
			local d = FILEMAN:GetDirListing("/RandomMovies/")
			SearchBox.Dir = d SearchBox.CharLim = 3
		end
	end

}