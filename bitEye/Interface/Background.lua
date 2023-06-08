return Def.ActorFrame{

	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Black):fadeleft(0.25):faderight(0.25)
			self:zoomto( SCREEN_WIDTH * 2, SCREEN_HEIGHT )
		end
	}

}