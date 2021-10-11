-- Texture the preview
return Def.ActorFrameTexture{
    bitEyeCommand=function(self)

        local w = SCREEN_WIDTH * 2
        local h = SCREEN_HEIGHT * 2
        
        self:setsize( w, h )
        self:EnableAlphaBuffer(true)
        self:EnableDepthBuffer(true)
        self:Create()

        local texs = bitEye.Info.Data.Textures
        texs[#texs+1] = self:GetTexture()

        local s = bitEye.SPath
        s = s .. "Window/Textures/AFT-Children.lua"
        self:AddChildFromPath(s)

        -- Looks I need a tween to stack
        -- and to change the timers
        self:sleep(0):queuecommand("Timer")

    end,
    TimerCommand=function(self)
        self:RunCommandsOnChildren(function(c)
            if not c.Name then bitEye.CAC(c) end
        end)
    end
}