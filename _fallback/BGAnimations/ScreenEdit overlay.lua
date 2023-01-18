-- WARNING: BitEye: You were not supposed to replace files, this could cause many issues!
-- It's better to add bitEye manually!

local t = Def.ActorFrame{
	OnCommand=function(self)
		local c = self:GetChildren()
		c.Beat:xy( 10, SCREEN_BOTTOM-10 ):align(0,1)
		c.SnapType:xy( SCREEN_RIGHT-10, SCREEN_BOTTOM-10 ):align(1,1)
		c.MarkerRange:xy( SCREEN_RIGHT-10, SCREEN_BOTTOM-40 ):align(1,1)
		c.TapNoteType:xy( SCREEN_RIGHT-10, SCREEN_BOTTOM-10 ):align(1,1)
		--c.Second:xy( 180, SCREEN_BOTTOM-10 )
	end,
	EditorStateChangedMessageCommand = function(self,param)
		self:visible( param.EditState ~= "EditState_Playing" )
	end,
	EditorUpdateMessageCommand=function(self,params)
		local formatting = "Beat: %.3f\nSeconds: %.3f\nBPM: %.3f"
		self:GetChild("Beat"):settext( string.format( formatting , params.Beat, params.Second, params.BPM ) )

		if params.SnapType then
			self:GetChild("SnapType"):settext( params.SnapType )
		end
		
		self:GetChild("MarkerRange"):settext( params.MarkerRange or "" )

		if params.TapNoteType then
			self:GetChild("TapNoteType"):settext( params.TapNoteType )
		end
	end
}

t[#t+1] = Def.BitmapText{ Name="Beat", Font="Common Normal" }

t[#t+1] = Def.BitmapText{ Name="SnapType", Font="Common Normal" }
t[#t+1] = Def.BitmapText{ Name="MarkerRange", Font="Common Normal" }
t[#t+1] = Def.BitmapText{ Name="TapNoteType", Font="Common Normal" }

local bitEye = LoadModule("bitEye/bitEye.lua")
t[#t+1] = bitEye.spawn("EditNoteField")

return t