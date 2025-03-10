
-- It's the green overlay.

local w = SCREEN_WIDTH

local alpha = PREFSMAN:GetPreference("BGBrightness")

local function onChildren(self)

    local size = tapLua.screenSize()        self:setSizeVector(size)

end

return Def.ActorFrame {

    InitCommand=function(self) self:RunCommandsOnChildren(onChildren) end,

	tapLua.Quad {

		InitCommand=function(self)

            self:diffuse( Color.Black ):diffusealpha(alpha)

		end

	},

	tapLua.Quad {

		InitCommand=function(self)

            self:x( - w ):diffuse( Color.Green ):diffusealpha(0.5)
            
            self:cropleft(0.75):fadeleft(0.25)

		end
        
	},

	tapLua.Quad {

		InitCommand=function(self)

            self:x(w):diffuse( Color.Green ):diffusealpha(0.5)
            
            self:cropright(0.75):faderight(0.25)

		end
        
	}

}