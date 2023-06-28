
local SearchBox

return Def.ActorFrame {

	InitCommand=function(self) SearchBox = self:GetParent() end,

	Def.Quad {

		OnCommand=function(self)

			local scale = SCREEN_HEIGHT / 720

			self:zoomto( 320 * 0.75, 160 ):diffuse( Color.Black ):diffusealpha(0.5)

			local w = self:GetZoomedWidth()			local h = self:GetZoomedHeight()
			w, h = w * scale, h * scale
			
			SearchBox:SetWidth(w):xy( SCREEN_WIDTH - w * 0.675,	SCREEN_CENTER_Y - h )

		end

	},

	Def.BitmapText {
		
		Font="Common normal",
		OnCommand=function(self) self:maxwidth( SearchBox:GetWidth() ):diffuse( Color.White ) end,

		WriteCommand=function(self)

			self:settext( SearchBox.input )

			local w = self:GetZoomedWidth()
			if w > SearchBox:GetWidth() then self:zoom( w / SearchBox:GetWidth() ) end

		end

	},

	Def.BitmapText {
		
		Name="Subtitle",	Font="Common normal",
		OnCommand=function(self)

			self.defaultColor = color("#808080")

			self.formerText = "Waiting for input."
			self:y(30):diffuse( self.defaultColor ):settext( self.formerText )

		end,

		WriteCommand=function(self)

			SearchBox.results = {}

			local r = SearchBox.results				local s = SearchBox.input
			local lim = SearchBox.charLimit			local dir = SearchBox.directory

			local color = self.defaultColor			local text = "No results found."

			if #s == 0 then text = self.formerText end

			if #s >= lim then

				for i, path in ipairs(dir) do

					local path2 = path:gsub('%p', '')		local input = s:gsub('%p', '')

					-- Index needed to change row.
					if path2:match(input) then r[#r+1] = { Index = i, Path = path } end

				end

				color = Color.Orange
				if #r == 1 then color = Color.Green		text = "1 result." end
				if #r > 1 then color = Color.Yellow		text = #r .. " results." end

			end
			
			self:diffuse(color):settext(text)

		end

	}

}