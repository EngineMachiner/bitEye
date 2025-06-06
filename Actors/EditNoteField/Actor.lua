
local astro = Astro.Table


local scale = SCREEN_HEIGHT / 720


local path, EditNoteField = bitEye.Path .. "Actors/EditNoteField/"


local function isOff()

	local onEditor = GAMESTATE:InStepEditor()

	local isEditScreen = SCREENMAN:GetTopScreen():GetName() == "ScreenEdit"

    local isValid = isEditScreen and onEditor

    return not isValid

end

local function onAction(event)

    local isFirstPress = event.type:match("FirstPress")

	if not isFirstPress then return end


    local button = event.DeviceInput.button         local isAlt = button:match("left alt")

    local BGChanges = GAMESTATE:GetCurrentSong():GetBGChanges()

    local isValid = isAlt and #BGChanges > 0

	if not isValid then return end


    local self = EditNoteField              self.isVisible = not self.isVisible

    local isVisible = self.isVisible        local command = isVisible and "Open" or "Close"

    self:playcommand(command)

end

local buttons = { "MenuUp", "MenuDown" }

local function onScroll(event)

    local type = event.type         local isReleased = type:match("Release")
    
    if not isReleased then return end


    local button = event.GameButton

    local isValid = function(k) return button == buttons[k] end

	local isMoving = astro.contains( buttons, isValid )

	if isMoving then EditNoteField:playcommand("Load") end

end

local function input(event)

    if isOff() then return end          onScroll(event) onAction(event)

end

local function updateFunction()

    local field = EditNoteField


    local isVisible = field.isVisible       local isOff = isOff() and isVisible

    if isOff then field:playcommand("Close") end


    local alpha = field:GetDiffuseAlpha()

    local isPersistent = not isVisible and alpha > 0

    if isPersistent then field:diffusealpha(0) end

end

return Def.ActorFrame {

	Name="bitEye_EditNoteField",
    
    loadfile( path .. "Children.lua" )(),

	OpenCommand=function(self) 
        
        self:stoptweening()     self:playcommand("Load")
        
        self:linear(0.25):diffusealpha(1)
    
    end,

	CloseCommand=function(self)

        self:stoptweening():linear(0.25):diffusealpha(0)

		if self.isVisible then self.isVisible = false end

	end,

	OnCommand=function(self)

        EditNoteField = self        bitEye.Actors.EditNoteField = self
        
        self:diffusealpha(0):zoom(scale)


		local screen = SCREENMAN:GetTopScreen()

		screen:AddInputCallback(input):SetUpdateFunction(updateFunction)

	end

}