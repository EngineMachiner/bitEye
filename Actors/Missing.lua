
return Def.ActorFrame {

	LoadCommand=function(self) self:visible(false) end,
	MissingCommand=function(self) self:visible(true) end,

	Def.BitmapText {

		Font = "Common normal",

		OnCommand=function(self)

            self:zoom(7.5):settext("MISSING"):diffuse( Color.Red )

		end

	}

}