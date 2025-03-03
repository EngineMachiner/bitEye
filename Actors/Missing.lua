
return Def.ActorFrame {

	LoadCommand=function(self) self:visible(false) end,
	MissingCommand=function(self) self:visible(true) end,

	Def.Quad {

		OnCommand=function(self)

            self:FullScreen():xy(0,0)

			self:diffuse( Color.Black ):diffusealpha(0.75)

		end

	},

	Def.BitmapText {

		Font = "Common normal",

		OnCommand=function(self)

            self:Center():zoom(7.5)

            self:settext("MISSING"):diffuse( Color.Red )

		end

	}

}