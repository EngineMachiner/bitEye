
local Info = { Row = { 0 }, Conditions = {} }

local keys = {}
keys["_left alt"] = "ALT"
keys["_right ctrl"] = "CTRL"

local w = SCREEN_WIDTH * 2
local h = SCREEN_HEIGHT * 2

-- Handle inputs
local function InputControl(event)
	local input = event.DeviceInput
	if input.down and Info.Conditions.Row then
		for k,v in pairs(keys) do
			if input.button:match(k) then
				local a = Info.Conditions[v]
				a = not a and true
				Info.Conditions[v] = a
			end
		end
	end
end

local function Update(self)

	self:RemoveAllChildren()
	
	local a, b, c = Info.Row.Index
	b = Info.Screen:GetOptionRow(a)
	c = b:GetChoiceInRowWithFocus(Info.Enum)

	Info.Row.OptRow = b
	Info.Row.Choice = c

	local a = a == 9 or a == 17
	Info.Type = a and "SongCustom"

	a = Info.Row.Index
	a = a == 10 or a == 18
	Info.Type = a and "BGA" or Info.Type

	a = Info.Row.Index
	if a > 10 and a < 14
	or a > 18 and a < 22 then Info.Type = "RM" end

	if not Info.Conditions.Row then return end

	self:AddChildFromPath(bitEye.SPath .. "Window/Background.lua")
	bitEye.ChldName(self, "bE-Background")

	if Info.Type == "BGA" then
		local dir = FILEMAN:GetDirListing("/BGAnimations/", true, true)
		Info.Dir = dir[tonumber(c) + 1]
		Info.Dir = Info.Dir .. "/default.lua"
		self:AddChildFromPath(Info.Dir)
	end

	if Info.Type == "RM" then
		local dir = FILEMAN:GetDirListing("/RandomMovies/")
		Info.Dir = dir[tonumber(c) + 1]
		Info.Dir = "/RandomMovies/" .. Info.Dir
		self:AddChildFromPath(Info.Dir)
	end

	if Info.Type == "SongCustom" then
		local cur = GAMESTATE:GetCurrentSong():GetSongDir()
		local dir = FILEMAN:GetDirListing(cur, false, true)
		Info.Dir = dir[tonumber(c) + 1]
		self:AddChildFromPath(Info.Dir)
	end

	bitEye.ChldName(self, "bE-Custom")

	self:AddChildFromPath(bitEye.SPath .. "Window/Overlay.lua")
	bitEye.ChldName(self, "bE-Overlay")

	self:RunCommandsOnChildren(function(c)
		local s = Info.Dir
		if s and s:sub(#s-3,#s) ~= ".lua"
		and c.Name == "bE-Custom" then
			c:scale_or_crop_background()
		end
		c:playcommand("On")
		bitEye.CAC(c)
	end)
	
	bitEye.AFT_IssueFix(self)

end

local window = Def.ActorFrame{
	OnCommand=function(self)

		self.Container = {}
		local function LockUp(n, s, f1, f2)
			local c = self.Container
			if Info.Conditions[s] and not c[n] then 
				c[n] = true f1()
			elseif c[n] and not Info.Conditions[s] then
				c[n] = false f2() 
			end
		end

		Info.Screen = SCREENMAN:GetTopScreen()
		Info.Screen:AddInputCallback( InputControl )
		Info.Enum = 'PlayerNumber_P1'

		local p = self:GetParent():GetParent()
		p = p:GetParent()
		p:diffusealpha(0)

		self:SetUpdateFunction(function()

			-- Allow to show
			LockUp(1, "ALT",
			function()
				if Info.Conditions.Row then
					p:stoptweening()
					p:linear(0.25)
					p:diffusealpha(1)
					Update(self)
				end
			end,
			function()
				p:stoptweening()
				p:linear(0.25)
				p:diffusealpha(0)
			end)

			-- Zoom feature
			LockUp(2, "CTRL",
			function() p:playcommand("ZoomIn") end,
			function() p:playcommand("ZoomOut") end)

		end)
	end
}

window.ChangeRowMessageCommand=function(self)

	Info.Conditions.Row = false
	local a = Info.Screen:GetCurrentRowIndex(Info.Enum)
	for i=9,13+5 do
		i = i > 13 and i + 3 or i
		if a == i then 
			Info.Conditions.Row = true
			if Info.Conditions.ALT then
				Update(self)
			end
		break 
		end
	end
	Info.Row.Index = a

	if not Info.Conditions.Row then
		Info.Conditions.ALT = false
	end

end
window.MenuLeftP1MessageCommand=window.ChangeRowMessageCommand
window.MenuRightP1MessageCommand=window.ChangeRowMessageCommand

-- Texture the window
local aft = Def.ActorFrameTexture{ 
	InitCommand=function(self)
		self:setsize( w, h )
		self:EnableAlphaBuffer(true)
		self:EnableDepthBuffer(true)
		self:Create()
		bitEye.WindowTex = self:GetTexture()
	end,
	Def.ActorFrame{
		InitCommand=function(self)
			self:Center()
		end,
		window
	}
}

local function Reset(self)
	self:RemoveAllChildren()
	bitEye.Refresh = true
end

return Def.ActorFrame{

	Name="bitEye OptionRow", aft,

	OffCommand=Reset,
	CancelCommand=Reset,

	Def.Sprite{
		OnCommand=function(self)
			self:CenterX():zoom(0.1625)
			self:SetTextureFiltering(false)
			self:SetTexture(bitEye.WindowTex)
			self:y( self:GetZoomedHeight() * 0.5 )
			self:cropbottom( 0.25 )
			self:croptop( 0.25 )
			self:faderight( 0.25 ) 
			self:fadeleft( 0.25 )
		end,
		ZoomInCommand=function(self)
			self:stoptweening()
			self:linear(1):zoom(0.75):Center()
		end,
		ZoomOutCommand=function(self)
			self:stoptweening()
			self:linear(1)
			self:CenterX():zoom(0.1625)
			self:y( self:GetZoomedHeight() * 0.5 )
		end
	},

	loadfile(bitEye.SPath .. "SearchBox.lua")()

}