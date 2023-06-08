
local EditNoteField

-- Get BGChange file path.
local function search( directory, bgChange )

    local fileName = bgChange.file1

	local songDirectory = GAMESTATE:GetCurrentSong():GetSongDir()

	for _, path in ipairs(directory) do

		local sub1, sub2 = path:gsub( '%p', '' ), fileName:gsub( '%p', '' )
		local onSongDirectory = path:match(songDirectory)

		if sub1:match(sub2) then
			if onSongDirectory then return songDirectory .. fileName else return path end
		end
		
	end

	return false

end

return Def.ActorFrame {

    -- 1. Create the preview texture.

    Def.ActorFrameTexture{

        InitCommand=function(self)

            self:EnableAlphaBuffer(true):EnableDepthBuffer(true)
            self:setsize( SCREEN_WIDTH, SCREEN_HEIGHT ):Create()

        end,

        OnCommand=function(self)
            
            EditNoteField = bitEye.EditNoteField

            EditNoteField.Texture = self:GetTexture()
    
            self:playcommand("Load")
    
        end,

        Def.ActorFrame{

            LoadCommand=function(self)

                if not EditNoteField.isVisible then return end

                local Layers = {}
                local bgChanges = GAMESTATE:GetCurrentSong():GetBGChanges()
                local songDirectory = GAMESTATE:GetCurrentSong():GetSongDir()
        
                local BGA_List = FILEMAN:GetDirListing("/BGAnimations/", false, true)
                local RM_List = FILEMAN:GetDirListing("/RandomMovies/", false, true)
                local SongList = FILEMAN:GetDirListing(songDirectory, false, true)
        
                local currentBeat, i = GAMESTATE:GetSongBeat()
                
                if #bgChanges == 1 and currentBeat == bgChanges[1].start_beat then i = 1 end
        
                for k = 2, #bgChanges do
        
                    local current = bgChanges[k - 1]
                    local nextChange = bgChanges[k]
        
                    local last = currentBeat == nextChange.start_beat and k == #bgChanges
        
                    -- In the middle.
                    local b = currentBeat >= current.start_beat
                    b = b and currentBeat < nextChange.start_beat and not last
        
                    -- Last BGChange.
                    if last then i = k break end
        
                    if b then i = k - 1 break end
        
                end
        
                if not i then EditNoteField:playcommand("Close") return end
        
                self:RemoveAllChildren()
        
                local bgChange = bgChanges[i]
        
                local BGA_Path = search(BGA_List, bgChange)
                BGA_Path = BGA_Path and BGA_Path .. "/default.lua"
        
                local RM_Path = search(RM_List, bgChange)
                local SongPath = search(SongList, bgChange)
        
                --

                if not BGA_Path and not RM_Path and not SongPath then 
                    self:GetParent():playcommand("Missing") 
                end

                if SongPath and ( BGA_Path or RM_Path ) then BGA_Path, RM_Path = false end
        
                --

                if SongPath then
                    if not bgChange.file1:match('%.') then SongPath = SongPath .. "/default.lua" end
                    self:AddChildFromPath(SongPath)
                end

                if BGA_Path then self:AddChildFromPath(BGA_Path) end
                if RM_Path then self:AddChildFromPath(RM_Path) end
        
                local last = bitEye.getLastChild(self)
                local isStatic = tostring(last):match("Sprite")
                if isStatic then last:scale_or_crop_background() end
        
                self:playcommand("On")
                
                bitEye.setEffectTimingForChildren(self)

            end  

        },

        loadfile( bitEye.Path .. "Interface/Missing.lua" )()
    
    },

    Def.ActorFrame{
    
        OnCommand=function(self)
    
            self:Center():SetUpdateFunction( function()
    
                local notefield = SCREENMAN:GetTopScreen():GetChild("EditNoteField")
                if not notefield then return end

                local config = bitEye.Config.EditNoteField      local pos = config.Pos
    
                self:xy( notefield:GetX() + pos.x, notefield:GetY() + pos.y )
    
            end )
    
        end,
    
        loadfile( bitEye.Path .. "Interface/Background.lua" )(),
    
        Def.Sprite {
    
            OnCommand=function(self)
    
                local texture = EditNoteField.Texture
                local scale = SCREEN_HEIGHT / 720
    
                self:GetParent():zoom( 0.185 * scale )
                self:SetTextureFiltering(false):SetTexture( texture )
                    
            end
            
        },
    
        loadfile( bitEye.Path .. "Interface/Overlay.lua" )()
    
    }
    

}