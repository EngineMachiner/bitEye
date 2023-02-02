return Def.Sprite{

    OnCommand=function(self)

        local texture = bitEye.EditNoteField.Texture
        local scale = SCREEN_HEIGHT / 720

        self:CenterX():zoom( 0.185 * scale )
        self:x( self:GetX() + 375 * scale )
        self:SetTextureFiltering(false)
            
        self:cropbottom( 0.25 ):croptop( 0.25 )
        self:faderight( 0.25 ):fadeleft( 0.25 )

        self:SetTexture( texture )
            
    end,

    bitEyeCommand=function(self)
        local notefield = SCREENMAN:GetTopScreen():GetChild("EditNoteField")
        if not notefield then return end
        self:y( notefield:GetY() )
    end
    
}
