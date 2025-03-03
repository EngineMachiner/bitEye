
--[[

    Actor that shows an animation preview based on the option row focused in the menu.

    Users can use the inputs to search animations through the search box.

]]


local currentIndex = bitEye.OptionRow.currentIndex

local path = bitEye.Path .. "Actors/OptionRow/"


-- Could use Astro.Table.find() here but it could be too verbose.

local functions, keys = {}, { "isCustom", "isBGA", "isMovie" }

for i,v in ipairs(keys) do functions[v] = bitEye.OptionRow[v] end

local function onRange(i)

    for k,v in pairs(functions) do if v(i) then return true end end

end

local function onChangeRow(self)

	local i = currentIndex()        local canShow = onRange(i)

    
    self.canShow = canShow      self.rowIndex = i

	if not self.isVisible then return end
    

    local command = canShow and "Load" or "Close"

	self:playcommand(command)

end

local function close(self) self:playcommand("Close") end

local input = dofile( path .. "Input.lua" )

local t = Def.ActorFrame {

	Name = "bitEye_OptionRow",

    OffCommand = close,   CancelCommand = close,

    ChangeRowMessageCommand = onChangeRow,

	OpenCommand=function(self) 

        self:stoptweening():linear(0.25):diffusealpha(1) 
    
    end,

	CloseCommand=function(self)

        self:stoptweening():linear(0.25):diffusealpha(0)

		if self.isVisible then self.isVisible = false end

        self:playcommand("CloseBox")

	end,
	
    InitCommand =function(self) bitEye.Actors.OptionRow = self end,

	OnCommand=function(self)

		SCREENMAN:GetTopScreen():AddInputCallback(input)

        self:diffusealpha(0)

	end,

    loadfile( path .. "Texture.lua" )(),        bitEye.actor( "OptionRow/SearchBox" )

}


return t