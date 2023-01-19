return Def.Sprite{

    OnCommand=function(self)

        local texture = bitEye.EditNoteField.Texture
        local scale = SCREEN_HEIGHT / 480

        local y = SCREENMAN:GetTopScreen():GetChild("EditNoteField"):GetY()

        self:CenterX():zoom(0.125 * 1.5)
        self:xy( self:GetX() + 250 * scale, y )
        self:SetTextureFiltering(false)
            
        self:cropbottom( 0.25 ):croptop( 0.275 )
        self:faderight( 0.25 ):fadeleft( 0.25 )

        self:SetTexture( texture )
            
    end
    
}