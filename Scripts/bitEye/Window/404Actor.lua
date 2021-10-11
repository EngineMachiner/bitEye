
return Def.ActorFrame{

	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Black)
			self:diffusealpha(0.75)
			self:Center()
			self:zoomto( SCREEN_WIDTH, SCREEN_HEIGHT )
		end
	},

	Def.BitmapText{
		Font="Common normal",
		OnCommand=function(self)
			self:Center()
			self:settext("MISSING")
			self:zoom(7.5)
			self:diffuse(Color.Red)
		end
	}

}