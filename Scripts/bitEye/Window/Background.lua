
return Def.ActorFrame{
	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Black)
			self:Center()
			self:zoomto( SCREEN_WIDTH * 2, SCREEN_HEIGHT )
		end
	}
}