
-- Add sprites with textures
return Def.ActorFrame{ 
    Def.Sprite{
        bitEyeCommand=function(self)

            self.Index = self:GetParent().Index

            self:CenterX():zoom(0.0625)
            self:x( self:GetX() + 240 )
            self:SetTextureFiltering(false)
            
            self:cropbottom( 0.25 )
            self:croptop( 0.25 )
            self:faderight( 0.25 ) 
            self:fadeleft( 0.25 )

            local texs = bitEye.Info.Data.Textures
            self:SetTexture(texs[self.Index])

            self:queuecommand("Update")

        end,
        UpdateCommand=function(self)

            local BGChanges = bitEye.Info.BGChanges

            local amp = bitEye.Info.Amp
            
            local temp = BGChanges[self.Index]
            local temp_b = temp.start_beat
            local b = GAMESTATE:GetSongBeat()
            local scale = amp.SS[amp.Index]
            amp = amp.SS[amp.Index]

            local y = 32 * ( temp_b - b )
            y = y * amp
            y = ( y + 60 ) * SCREEN_HEIGHT / 480
            self.Y = y
                
            local c = bitEye.Info.Command or "SetPos"
            bitEye.Info.Command = c

            self:stoptweening():diffusealpha(1)
            self:queuecommand(c)

        end,
        SetPosCommand=function(self)
            self:y(self.Y)
        end,
        AmplitudeCommand=function(self)
            local i = bitEye.Info.Amp.Index
            local t = bitEye.Info.Amp.SS[i]
            self:linear(t * 0.25):diffusealpha(0)
            self:sleep(0):y(self.Y)
            self:linear(0.5):diffusealpha(1)
        end
    }
}