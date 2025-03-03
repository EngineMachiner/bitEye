
-- It's the green overlay.

local w = SCREEN_WIDTH

local alpha = PREFSMAN:GetPreference("BGBrightness")

return Def.ActorFrame {

    InitCommand=function(self)

        self:RunCommandsOnChildren( function(self) self:FullScreen():xy(0,0) end )

    end,

	Def.Quad {

		InitCommand=function(self)

            self:diffuse( Color.Black ):diffusealpha(alpha)

		end

	},

	Def.Quad {

		InitCommand=function(self)

            self:x( -w ):diffuse( Color.Green ):diffusealpha(0.5)
            
            self:cropleft(0.75):fadeleft(0.25)

		end
        
	},

	Def.Quad {

		InitCommand=function(self)

            self:x(w):diffuse( Color.Green ):diffusealpha(0.5)
            
            self:cropright(0.75):faderight(0.25)

		end
        
	}

}