
local Vector = Astro.Vector

local function searchBox()
    
    local main = bitEye.Actors.OptionRow        return main:GetChild("SearchBox")

end

local texts = { "Waiting for input.",       "No results found." }

local defaultColor = color("#808080")

local function textColor()

    local r = searchBox().results

    if #r == 1 then return Color.Green end

    if #r > 1 then return Color.Yellow end

    return Color.Orange

end

return Def.ActorFrame {

	tapLua.Quad {

		OnCommand=function(self)

            local size = Vector( 240, 160 )       self:diffuse( Color.Black ):diffusealpha(0.5)
			

            local SearchBox = searchBox()       local actors = { self, SearchBox }

            for i,v in ipairs(actors) do v:setSizeVector(size) end

            SearchBox:playcommand("Pos")

		end

	},

	Def.BitmapText {
		
		Font = "Common normal",

		OnCommand=function(self)

            local w = searchBox():GetWidth() * 0.75         self:diffuse( Color.White )

            self.MaxWidth = w
        
        end,

		UpdateCommand=function(self)

            local SearchBox = searchBox()       local text = SearchBox.input

            self:settext(text):zoom(1)


            local w1 = self:GetWidth()          local w2 = self.MaxWidth

			if w1 <= w2 then return end         self:zoom( w2 / w1 )

		end

	},

	Def.BitmapText {
		
		Name = "ResultsText",          Font = "Common normal",

        InitCommand=function(self) self:y(30) end,

		ChangeRowMessageCommand=function(self)

            self:diffuse( defaultColor ):settext( texts[1] )

		end,

		UpdateCommand=function(self)

            local SearchBox = searchBox()

			local input = SearchBox.input           local directory = SearchBox.directory


			if #input < 2 then self:playcommand("ChangeRow") return end


            local results = {}

            local function add( i, v )

                if not v:match(input) then return end       table.insert( results, i )

            end

            for i,v in ipairs(directory) do add( i, v ) end

            SearchBox.results = results
            

            local text = texts[2]
			
            if #results >= 1 then text = #results .. " results." end


            local color = textColor()

			self:diffuse(color):settext(text)

		end

	}

}