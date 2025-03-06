
local scale = SCREEN_HEIGHT / 720


local path = bitEye.Path .. "Actors/OptionRow/SearchBox/"


local function redirectInput(boolean)

	local p = "PlayerNumber_P"

	for i = 1, 2 do SCREENMAN:set_input_redirected( p .. i, boolean ) end

end

local function clear(self) self.input = ''      return self end

local inputCallbacks = {

    dofile( path .. "Input/Keys.lua" ),         dofile( path .. "Input/Actions.lua" )

}

local function addInputCallbacks()

    local screen = SCREENMAN:GetTopScreen()

    for i,v in ipairs(inputCallbacks) do screen:AddInputCallback(v) end

end

return tapLua.actorFrame {

	Name="SearchBox", 			loadfile( path .. "Children.lua" )(),

	InitCommand=function(self)

        self.clear = clear          self:diffusealpha(0):zoom(scale)

	end,

	OnCommand=function(self)

		addInputCallbacks()         self:clear():playcommand("ChangeRow")

	end,

    PosCommand=function(self)

        local w, h = self:GetZoomedSize()

        self:x( SCREEN_WIDTH - w * 0.75 ):y( SCREEN_CENTER_Y - h )

    end,

	OpenBoxCommand=function(self)
        
        redirectInput(true)

        self:stoptweening():linear(0.25):diffusealpha(1)
    
    end,

	CloseBoxCommand=function(self)

		redirectInput(false)
        
        self:stoptweening():linear(0.25):diffusealpha(0)

		if self.isVisible then self.isVisible = false end

	end,

	ChangeRowMessageCommand=function(self) self:clear() end

}
