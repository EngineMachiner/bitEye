
local scale = SCREEN_HEIGHT / 720

local Vector = Astro.Vector


local path = bitEye.Path .. "Actors/OptionRow/SearchBox/"


local players = PlayerNumber

local function redirectInput(boolean)

	for i = 1, 2 do SCREENMAN:set_input_redirected( players[i], boolean ) end

end

local function clear(self) self.input = ''      return self end

local subPath = path .. "Input/"

local inputCallbacks = {

    dofile( subPath .. "Keys.lua" ),         dofile( subPath .. "Actions.lua" )

}

local function addInputCallbacks()

    local screen = SCREENMAN:GetTopScreen()

    for i,v in ipairs(inputCallbacks) do screen:AddInputCallback(v) end

end

return tapLua.ActorFrame {

	Name="SearchBox", 			loadfile( path .. "Children.lua" )(),

	InitCommand=function(self)

        self.clear = clear          self:diffusealpha(0):zoom(scale)

	end,

	OnCommand=function(self)

		addInputCallbacks()         self:clear():playcommand("ChangeRow")

	end,

    PosCommand=function(self)

        local pos = Vector( SCREEN_WIDTH, SCREEN_CENTER_Y ) - self:GetZoomedSize()

        self:setPos(pos)

    end,

	OpenBoxCommand=function(self)
        
        redirectInput(true)     self:stoptweening():linear(0.25):diffusealpha(1)
    
    end,

	CloseBoxCommand=function(self)

		redirectInput(false)    self:stoptweening():linear(0.25):diffusealpha(0)

		if self.isVisible then self.isVisible = false end

	end,

	ChangeRowMessageCommand=function(self) self:clear() end

}
