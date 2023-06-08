
local Config, OptionRow

return Def.ActorFrame { 
    
    -- 1. Create the preview texture.

    Def.ActorFrameTexture { 

        InitCommand=function(self)
            self:setsize( SCREEN_WIDTH, SCREEN_HEIGHT )
            self:EnableAlphaBuffer(true):EnableDepthBuffer(true):Create()
        end,

        OnCommand=function(self)
            OptionRow = bitEye.OptionRow        OptionRow.Texture = self:GetTexture() 
        end,

        Def.ActorFrame {

            LoadCommand=function(self)

                -- Directiory will be defined later on...
                local Layers, rowIndex, directory = {}, OptionRow.rowIndex
                
                local screen = SCREENMAN:GetTopScreen()
                local row = screen:GetOptionRow(rowIndex)
                local choice = tonumber( row:GetChoiceInRowWithFocus('PlayerNumber_P1') )
            
                local isCustom, isBGA = bitEye.isCustom(rowIndex), bitEye.isBGA(rowIndex)
                local isRM = bitEye.isRM(rowIndex)
            
                self:RemoveAllChildren()
            
                -- Song custom.
                if isCustom then
            
                    local songDir = GAMESTATE:GetCurrentSong():GetSongDir()
            
                    local fileName = row:GetChild(""):GetChild("Item"):GetText()
                    local filePath = songDir .. fileName
                    if isCustom == "isScript" then filePath = filePath .. "/default.lua" end
            
                    self:AddChildFromPath(filePath)
            
                end
            
                -- BGAnimations.
                if isBGA then
            
                    directory = FILEMAN:GetDirListing("/BGAnimations/", true, true)
                    local filePath = directory[ choice + 1 ] .. "/default.lua"
            
                    self:AddChildFromPath(filePath)
            
                end
            
                -- RandomMovies.
                if isRM then 
            
                    directory = FILEMAN:GetDirListing("/RandomMovies/")
                    local filePath = "/RandomMovies/" .. directory[ choice + 1 ]
            
                    self:AddChildFromPath(filePath)
            
                end
            
                local last = bitEye.getLastChild(self)
                local isStatic = tostring(last):match("Sprite")
                if isStatic then last:scale_or_crop_background() end
            
                self:playcommand("On")		bitEye.setEffectTiming(self)

            end

        }
        
    },

    -- 2. Elements and texture.

    Def.ActorFrame {

        loadfile( bitEye.Path .. "Interface/Background.lua" )(),

        Def.Sprite {

            OnCommand=function(self)

                self:SetTextureFiltering(false):SetTexture( OptionRow.Texture )

                self.init = function(tweenTime)

                    local p = self:GetParent()      Config = bitEye.Config.OptionRow

                    if tweenTime then p:stoptweening():linear(tweenTime) end

                    p:zoom( Config.Zoom )
                    p:CenterX():y( self:GetZoomedHeight() * 0.75 * p:GetZoom() )
                    p:queuecommand("Config")
                    
    
                end

                self.init()

            end,

            ConfigCommand=function(self)

                local p, pos = self:GetParent(), Config.Pos
                p:x( p:GetX() + pos.x, p:GetY() + pos.y )

            end,

            ZoomInCommand=function(self)

                local p = self:GetParent()

                p:stoptweening():linear(1):zoom(0.75):Center()

            end,

            ZoomOutCommand=function(self) self.init(1) end

        },

        loadfile( bitEye.Path .. "Interface/Overlay.lua" )()

    },

    loadfile( bitEye.Path .. "OptionRow/SearchBox/Actor.lua" )()

}