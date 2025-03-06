
local OptionRow, SearchBox

local Config = bitEye.Config.OptionRow

local path = bitEye.Path .. "Actors/"


local function row(i) return SCREENMAN:GetTopScreen():GetOptionRow(i) end

local function choice(row) -- Index starts at 0.
    
    local choice = row:GetChoiceInRowWithFocus("PlayerNumber_P1") 

    return tonumber(choice)

end


-- Songs with custom backgrounds or animations.

local function customPath()

    local bitEye = bitEye.OptionRow

    local i = OptionRow.rowIndex            local isCustom = bitEye.isCustom(i)

    if not isCustom then return end         local isScript = isCustom == "script"


    local directory = GAMESTATE:GetCurrentSong():GetSongDir()

    SearchBox.directory = directory


    -- Get the row title.

    local title = row(i):GetChild(""):GetChild("Item"):GetText()

    local path = directory .. title

    return isScript and path .. "/default.lua" or path

end

local function bgaPath()

    local bitEye = bitEye.OptionRow

    local i = OptionRow.rowIndex        local isBGA = bitEye.isBGA(i)

    if not isBGA then return end


    local directories = FILEMAN:GetDirListing( "/BGAnimations/", true, true )

    SearchBox.directory = directories


    local row = row(i)          local choice = choice(row)
    
    local directory = directories[ choice + 1 ]

    return directory .. "/default.lua"

end

local function moviePath()

    local bitEye = bitEye.OptionRow

    local i = OptionRow.rowIndex        local isMovie = bitEye.isMovie(i)

    if not isMovie then return end


    local directories = FILEMAN:GetDirListing( "/RandomMovies/", false, true )

    SearchBox.directory = directories


    local row = row(i)          local choice = choice(row)

    return directories[ choice + 1 ]

end

local functions = { customPath, bgaPath, moviePath }

return Def.ActorFrame {

    -- 1. Create the preview texture.

    Def.ActorFrameTexture { 

        InitCommand=function(self)

            self:setsize( SCREEN_WIDTH, SCREEN_HEIGHT )
            
            self:EnableAlphaBuffer(true):EnableDepthBuffer(true):Create()

        end,

        OnCommand=function(self)

            OptionRow = bitEye.Actors.OptionRow

            OptionRow.Texture = self:GetTexture()

            SearchBox = OptionRow:GetChild("SearchBox")

        end,

        Def.ActorFrame {

            LoadCommand=function(self)

                local path
                
                for i,v in ipairs(functions) do path = path or v() end

                if not path then return end


                self:RemoveAllChildren()        self:AddChildFromPath(path)

                bitEye.onMediaActor(self)       self:playcommand("On")
                
                bitEye.setChildrenTiming(self)

            end

        }
        
    },

    -- 2. Elements and texture.

    Def.ActorFrame {

        InitCommand=function(self)

            self.setZoom = setZoom

            local zoom = Config.ZoomIn        self.ZoomIn = zoom

            self:setsize( SCREEN_WIDTH, SCREEN_HEIGHT )

            self:setZoom(zoom):queuecommand("Pos")
        
        end,

        PosCommand=function(self)

            local h = self:GetZoomedHeight()            local pos = Config.Pos

            local x = SCREEN_CENTER_X + pos.x           local y = h * 0.75 + pos.y

            self:xy( x, y )         self.Pos = { x = x, y = y }

        end,

        loadfile( path .. "Background.lua" )(),

        Def.Sprite {

            OnCommand=function(self)

                local texture = OptionRow.Texture

                self:SetTexture(texture):SetTextureFiltering(false)

            end,

            ZoomInCommand=function(self)
                
                local p = self:GetParent()
                
                local pos, zoom = p.Pos, p.ZoomIn
                
                p:stoptweening():linear(1):setZoom(zoom)
                
                p:xy( pos.x, pos.y ):diffusealpha(1)
                
            
            end,

            ZoomOutCommand=function(self)

                local p = self:GetParent()

                p:stoptweening():linear(1):setZoom(0.75)

                p:Center():diffusealpha( 0.375 )

            end,

        },

        loadfile( path ..  "Overlay.lua" )()

    }

}