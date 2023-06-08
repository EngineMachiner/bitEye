
local w, h = SCREEN_WIDTH, SCREEN_HEIGHT

return Def.ActorFrame{

	Def.Quad{
		OnCommand=function(self)
			local pref = PREFSMAN:GetPreference("BGBrightness")
			self:diffuse(Color.Black):diffusealpha(pref):zoomto(w, h)
		end
	},

	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Green):diffusealpha(0.5)
			self:x( - w ):fadeleft(0.5):cropleft(0.5):blend('add')
			self:zoomto(w, h)
		end
	},

	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Green):diffusealpha(0.5)
			self:x(w):faderight(0.5):cropright(0.5):blend('add')
			self:zoomto( w, h )
		end
	}

}