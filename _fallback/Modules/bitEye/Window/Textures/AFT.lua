
-- Texture the preview
return Def.ActorFrameTexture{

    OnCommand=function(self)
        
        local w = SCREEN_WIDTH * 2      local h = SCREEN_HEIGHT * 2
        
        self:EnableAlphaBuffer(true):EnableDepthBuffer(true)
        self:setsize( w, h ):Create()

        bitEye.EditNoteField.Texture = self:GetTexture()

        local s = bitEye.Path .. "Window/Textures/AFT-Children.lua"
        self:AddChildFromPath(s)

        self:playcommand("bitEye")

    end,

    bitEyeCommand=function(self)
		bitEye.BGChanges = GAMESTATE:GetCurrentSong():GetBGChanges()
        bitEye.setEffectTimingForChildren(self)
    end

}