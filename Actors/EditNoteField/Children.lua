
-- This won't work if there's files / folders with the same names.

local astro = Astro.Table


local config = bitEye.Config.EditNoteField

local path = bitEye.Path .. "Actors/"


local EditNoteField

local directories = { "/BGAnimations/", "/RandomMovies/" }

local function getPath(name)

    directories[3] = GAMESTATE:GetCurrentSong():GetSongDir()

    for i,v in ipairs(directories) do
        

        local name = name

        if not name:match("%....$") then name = "/default.lua" end


        local path = v .. name

        local exists = FILEMAN:DoesFileExist(path)
        

        if exists then return path end
    
    end

end

local function currentBGChange()

    local BGChanges = GAMESTATE:GetCurrentSong():GetBGChanges()

    local beat = GAMESTATE:GetSongBeat()

    local function isValid(k)
    
        local current = BGChanges[k]

        local next = BGChanges[ k + 1 ]


        local isBefore = next and beat < next.start_beat

        local isFirst = k == 1 and isBefore

        local isMiddle = beat >= current.start_beat and isBefore

        local isLast = k == #BGChanges 


        return isFirst or isMiddle or isLast

    end

    return astro.find( BGChanges, isValid )

end

return Def.ActorFrame {

    -- 1. Create the preview texture.

    Def.ActorFrameTexture {

        InitCommand=function(self)

            self:setsize( SCREEN_WIDTH, SCREEN_HEIGHT )
            
            self:EnableAlphaBuffer(true):EnableDepthBuffer(true):Create()

        end,

        OnCommand=function(self)
            
            EditNoteField = bitEye.Actors.EditNoteField

            EditNoteField.Texture = self:GetTexture()
    
            self:playcommand("Load")
    
        end,

        Def.ActorFrame {

            LoadCommand=function(self)

                if not EditNoteField.isVisible then return end


                local name = currentBGChange().file1            local path = getPath(name)

                if not path then EditNoteField:playcommand("Missing") return end


                self:RemoveAllChildren()        self:AddChildFromPath(path)
        
                bitEye.onMediaActor(self)       self:playcommand("On")
                
                bitEye.setChildrenTiming(self)

            end  

        }
    
    },

    Def.ActorFrame{

        InitCommand=function(self) self:zoom(0.25) end,

        OnCommand=function(self)

            local NoteField = SCREENMAN:GetTopScreen():GetChild("EditNoteField")

            if not NoteField then self:playcommand("Legacy") return end


            local function update()
    
                local pos = config.Pos

                local x = NoteField:GetX() + pos.x          local y = NoteField:GetY() + pos.y

                self:xy( x, y )

            end

            self:SetUpdateFunction(update)

        end,

        LegacyCommand=function(self)

            EditNoteField:Center()          local pos = config.Pos

            local x = pos.x         local y = pos.y

            self:Center():x( self:GetX() + x ):y( self:GetY() + y )

        end,
    
        loadfile( path .. "Background.lua" )(),
    
        Def.Sprite {
    
            OnCommand=function(self)
    
                local texture = EditNoteField.Texture

                self:SetTextureFiltering(false):SetTexture( texture )
                    
            end
            
        },
    
        loadfile( path .. "Missing.lua" )(),        loadfile( path .. "Overlay.lua" )()
    
    }
    

}