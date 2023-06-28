
local function isPlaying()

	local screen = SCREENMAN:GetTopScreen()
	local getEditState = screen.GetEditState

	return getEditState and getEditState(screen) == "EditState_Playing"
	
end

local function logic( self, event )

	local input = event.DeviceInput			local button = input.button

	if not input.down or isPlaying() then return end

	local isMoving = button:match("_up") or button:match("_down")
	if isMoving then self.cooldown = 0 end

	if button:match("_left alt") then

		self.isVisible = not self.isVisible
	
		local isVisible = self.isVisible		local commands = { "Open", "Close" }

		for k,v in pairs { isVisible, not isVisible } do
			if v then self:playcommand( commands[k] ) break end
		end

	end

end

return Def.ActorFrame {

	Name="bitEye EditNoteField", 	loadfile( bitEye.Path .. "EditNoteField/Elements.lua" )(),

	OpenCommand=function(self)
		self:stoptweening():playcommand("Load"):linear(0.25):diffusealpha(1) 
	end,

	CloseCommand=function(self) 
		self:stoptweening():linear(0.25):diffusealpha(0) 
		if self.isVisible then self.isVisible = false end
	end,

	OnCommand=function(self)

		local screen = SCREENMAN:GetTopScreen()			bitEye.EditNoteField = self

		self.logic = logic

		self.createCooldown = bitEye.createCooldown		self:diffusealpha(0)

		screen:AddInputCallback( function(event) self:logic(event) end )
	
		local update = self:createCooldown( "cooldown", "limit", function() self:playcommand("Load") end )

		self:SetUpdateFunction( function()
	
			if isPlaying() then self:diffusealpha(0) self.isVisible = false end

			update()

		end )

	end

}