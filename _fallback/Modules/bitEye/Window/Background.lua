
return Def.ActorFrame{

	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Black):Center()
			self:zoomto( SCREEN_WIDTH * 2, SCREEN_HEIGHT )
		end
	}

}