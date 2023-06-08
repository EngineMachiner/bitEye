return Def.ActorFrame {

	LoadCommand=function(self) self:diffusealpha(0) end,
	MissingCommand=function(self) self:diffusealpha(1) end,

	Def.Quad {

		OnCommand=function(self)
			self:diffuse(Color.Black):diffusealpha(0.75):Center()
			self:zoomto( SCREEN_WIDTH, SCREEN_HEIGHT )
		end
		
	},

	Def.BitmapText {

		Font="Common normal",
		OnCommand=function(self)
			self:Center():settext("MISSING"):zoom(7.5):diffuse(Color.Red)
		end

	}

}