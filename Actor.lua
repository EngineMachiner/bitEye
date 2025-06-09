
local tapLua = tapLua.Type

local isSprite = tapLua.isSprite            local isActorFrame = tapLua.isActorFrame


local function actor(s)

    local path = bitEye.Path .. "Actors/"
    
    local endsWith = s:Astro():endsWith("%.lua")

	if not endsWith then s = s .. "/Actor.lua" end

    local actor = loadfile( path .. s )()       return actor

end

local function onSprite(self)

    if not isSprite(self) then return end

    self:set_use_effect_clock_for_texcoords(false)

end


local setChildrenTiming

local function setTiming(self)

	self:effectclock("timer"):set_tween_uses_effect_delta(false)

	onSprite(self)      setChildrenTiming(self)

end

setChildrenTiming = function(self)

    if not isActorFrame(self) then return end

	self:RunCommandsOnChildren( function(self) setTiming(self) end )

end


local function onMediaActor(self)

    local actor = self:GetChild("")

    if isSprite(actor) then actor:scale_or_crop_background() end

end

local function Load( self, path )

    self:RemoveAllChildren()        self:AddChildFromPath(path)

    onMediaActor(self)          self:playcommand("On")         setChildrenTiming(self)

end


-- Check if the option row position is in range.

local function inRange( i, n )  return i == n or i == n + 8  end

local optionRow = {

    currentIndex = function()
        
        return SCREENMAN:GetTopScreen():GetCurrentRowIndex(PLAYER_1)
    
    end,

    get = function(i) return SCREENMAN:GetTopScreen():GetOptionRow(i) end,

    isCustom = function(i)
       
        if inRange( i, 7 ) then return "script" end

        return inRange( i, 8 ) or inRange( i, 9 )
        
    end,

    isBGA = function(i) return inRange( i, 10 ) end,

    isMovie = function(i) 
        
        for n = 11, 13 do
            
            if inRange( i, n ) then return true end
            
        end

    end

}


local merge = { actor = actor, OptionRow = optionRow, Load = Load }

Astro.Table.merge( bitEye, merge )