
-- This won't work if there's files / folders with the same names.

local astro = Astro.Table

local Actor = tapLua.Actor


local config = bitEye.Config.EditNoteField

local path = bitEye.Path .. "Actors/"


local EditNoteField

local directories = { "/BGAnimations/", "/RandomMovies/" }

local function getPath(name)

    directories[3] = GAMESTATE:GetCurrentSong():GetSongDir()


    local isFile = name:Astro():endsWith("%....")

    if not isFile then name = name .. "/default.lua" end


    for i,v in ipairs(directories) do

        local path = v .. name          local exists = FILEMAN:DoesFileExist(path)
        
        if exists then return path end
        
    end

end

local function currentBGChange()

    local BGChanges = GAMESTATE:GetCurrentSong():GetBGChanges()

    local beat = GAMESTATE:GetSongBeat()

    local function isValid(k)
    
        local current = BGChanges[k]        local next = BGChanges[ k + 1 ]


        local isBefore = next and beat < next.start_beat

        local isFirst = k == 1 and isBefore

        local isMiddle = beat >= current.start_beat and isBefore

        local isLast = k == #BGChanges 


        return isFirst or isMiddle or isLast

    end

    return astro.find( BGChanges, isValid ).value

end

return Def.ActorFrame {

    -- 1. Create the preview texture.

    tapLua.Actor {

        Class = "ActorFrameTexture",

        InitCommand=function(self)

            local screenSize = tapLua.screenSize()          self:setSizeVector(screenSize)
            
            self:EnableAlphaBuffer(true):EnableDepthBuffer(true):Create()

        end,

        OnCommand=function(self)
            
            EditNoteField = bitEye.Actors.EditNoteField         EditNoteField.Texture = self:GetTexture()
    
            self:playcommand("Load")
    
        end,

        Def.ActorFrame {

            LoadCommand=function(self)

                if not EditNoteField.isVisible then return end


                local name = currentBGChange().file1            local path = getPath(name)

                if not path then EditNoteField:playcommand("Missing") return end


                bitEye.Load( self, path )

            end  

        }
    
    },

    tapLua.ActorFrame {

        InitCommand=function(self) self:zoom(0.25) end,

        OnCommand=function(self)

            local NoteField = SCREENMAN:GetTopScreen():GetChild("EditNoteField")

            if not NoteField then self:playcommand("Legacy") return end

            Actor.extend( NoteField )


            local function update()

                local pos = NoteField:GetPos() + config.Pos         self:setPos(pos)

            end

            self:SetUpdateFunction(update)

        end,

        LegacyCommand=function(self)

            EditNoteField:Center()          local pos = self:GetPos() + config.Pos

            self:setPos(pos)
            
        end,
    
        loadfile( path .. "Background.lua" )(),
    
        Def.Sprite {
    
            OnCommand=function(self)
    
                local texture = EditNoteField.Texture

                self:SetTextureFiltering(false):SetTexture(texture)
                    
            end
            
        },
    
        loadfile( path .. "Overlay.lua" )(),            loadfile( path .. "Missing.lua" )()
    
    }
    

}