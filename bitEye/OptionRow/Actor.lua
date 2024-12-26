
-- Basically actor that loads depending on the option row focused in the editor.
-- The previews are handled by a cooldown and inputs to show and hide + SearchBox.

local function onChangeRow(self)

	local screen = SCREENMAN:GetTopScreen()
	local currentIndex = screen:GetCurrentRowIndex('PlayerNumber_P1')
	
	self.rowIndex = currentIndex

	local isAny = bitEye.isCustom(currentIndex) or bitEye.isBGA(currentIndex)
	isAny = isAny or bitEye.isRM(currentIndex)
	
	self.canShow = isAny

	if not self.isVisible then return end

	if isAny then self.cooldown = 0 else self:playcommand("Close") end

end

local function closeAll(self) self:playcommand("Close") end

local function logic( self, event )

	local input = event.DeviceInput			local button = input.button
		
	if not input.down then return end

	if button:match("_left alt") then

		self.isVisible = not self.isVisible

		if self.isVisible then

			if self.canShow then self:playcommand("Load"):playcommand("Open") end

		else self:playcommand("Close") end

	end

	if button:match("_right ctrl") then

		self.isZoomed = not self.isZoomed

		-- These commands are on Elements.lua
		
		local isZoomed = self.isZoomed
		for k,v in pairs { ZoomOut = not isZoomed, ZoomIn = isZoomed } do
			if v then self:playcommand(k) break end
		end

	end

end

return Def.ActorFrame {

	Name="bitEye OptionRow",	loadfile( bitEye.Path .. "OptionRow/Elements.lua" )(),

	OffCommand=closeAll,	CancelCommand=closeAll,

	ChangeRowMessageCommand=onChangeRow,	MenuLeftP1MessageCommand=onChangeRow,
	MenuRightP1MessageCommand=onChangeRow,

	OpenCommand=function(self) self:stoptweening():linear(0.25):diffusealpha(1) end,

	-- Close SearchBox as well.
	CloseCommand=function(self)
		self:stoptweening():playcommand("CloseBox"):linear(0.25):diffusealpha(0)
		if self.isVisible then self.isVisible = false end
	end,
	
	OnCommand=function(self)

		bitEye.OptionRow = self							self.logic = logic

		self.createCooldown = bitEye.createCooldown		self:diffusealpha(0)

		self:SetUpdateFunction( self:createCooldown( "cooldown", "limit", function() self:playcommand("Load") end ) )

		SCREENMAN:GetTopScreen():AddInputCallback( function(event) self:logic(event) end )

	end

}