
return Def.ActorFrame{

	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Black)
			self:diffusealpha(0.5)
			self:Center()
			self:zoomto( SCREEN_WIDTH, SCREEN_HEIGHT )
		end
	},

	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Green)
			self:diffusealpha(0.5)
			self:Center():x( self:GetX() - SCREEN_WIDTH )
			self:zoomto( SCREEN_WIDTH, SCREEN_HEIGHT )
			self:cropleft(0.5)
		end
	},

	Def.Quad{
		OnCommand=function(self)
			self:diffuse(Color.Green)
			self:diffusealpha(0.5)
			self:Center():x( self:GetX() + SCREEN_WIDTH )
			self:zoomto( SCREEN_WIDTH, SCREEN_HEIGHT )
			self:cropright(0.5)
		end
	}

}