
local astro = Astro.Table


local self

local function onAlt(button)

	if not button:match("left alt") then return end


    self.isVisible = not self.isVisible -- Switch!


    if not self.isVisible then self:playcommand("Close") return end

    if not self.canShow then return end


    self:playcommand("Open"):playcommand("Load")

end

local function onCtrl(button)

	if not button:match("right ctrl") then return end

    
    self.isZoomed = not self.isZoomed -- Switch!


    -- These commands are in Elements.lua
    
    local isZoomed = self.isZoomed

    local command = isZoomed and "ZoomOut" or "ZoomIn"

    self:playcommand(command)

end

local function onFirstPress(event)

    local isFirstPress = event.type:match("FirstPress")

	if not isFirstPress then return end

    
    local button = event.DeviceInput.button

    onAlt(button)   onCtrl(button)

end

local buttons = { "MenuLeft", "MenuRight" }

local function onRelease(event)

    local isReleased = event.type:match("Release")

	if not isReleased then return end
    
    
    local button = event.GameButton

    isValid = function(k) return button == buttons[k] end

	local isSwitching = astro.find( buttons, isValid )

    if isSwitching then self:playcommand("Load") end

end

return function(event)

    self = bitEye.Actors.OptionRow


    local SearchBox = self:GetChild("SearchBox")

    if SearchBox.isVisible then return end


    onFirstPress(event)     onRelease(event)

end