
-- This is very custom but it works.
-- Custom because some edit elements are inaccessible in the engine and this was improvised.

bitEye.Info = { 
	Amp = { Index = 1 },
	Input = {},
	Data = { Textures = {} }
}

local Info = bitEye.Info

-- Amplitude scales
Info.Amp.SS = { 1, 1.5, 2, 3, 4, 6, 8 }

local w = SCREEN_WIDTH * 2
local h = SCREEN_HEIGHT * 2

-- It seems like when there's a AFTSpin
-- The BGA AFT, the overlay and the background of bitEye zoom in.
-- This is a temporal fix?
local function AFT_IssueFix(self)
	local bga_aft
	local function FindAFT(a)
		local s = tostring(a)
		if s:match("ActorFrame")
		and not s:match("ActorFrameTexture") then
			a:RunCommandsOnChildren(function(b)
				FindAFT(b)
			end)
		elseif s:match("ActorFrameTexture") then
			bga_aft = a
		end
	end
	FindAFT(self)
	if bga_aft then
		local function Move(s)
			if s:GetX() then
				s:x( s:GetX() - w * 0.125 )
				s:y( s:GetY() - h * 0.125 )
				s:zoom(0.5)
			end
		end
		Move(bga_aft:GetParent())
		self:RunCommandsOnChildren(function(d)
			if d.Name == "bE-Overlay" then
				Move(d)
			end
		end)
	end
end
bitEye.AFT_IssueFix = AFT_IssueFix

local function ClockAllChildren(self)

	local s = tostring(self)

	self:effectclock("timer")
	self:set_tween_uses_effect_delta(false)

	if s:match("Sprite") then
		self:set_use_effect_clock_for_texcoords(false)
	elseif s:match("ActorFrame") and self:GetChildren() then
		self:RunCommandsOnChildren( function(c)
			ClockAllChildren(c)
		end )
	end

end
bitEye.CAC = ClockAllChildren

local function ChildNaming(frame, name)
	frame:RunCommandsOnChildren(function(child)
		child.Name = child.Name or name
	end)
end
bitEye.ChldName = ChildNaming

local function BigOperation(self)

	self.Container = {}
	self:diffusealpha(0)
		
	local screen = SCREENMAN:GetTopScreen()
	screen:AddInputCallback( function(event)

		local input = event.DeviceInput
		local butt = input.button
		
		if input.down and not Info.Input.CTRL then
			
			local function ButtonMachine( value, b )
				if butt:match( b ) then
					return not value and true
				else
					return value
				end
			end
		
			local alt = Info.Input.ALT
			alt = ButtonMachine( alt, "_left alt" )
		
			Info.Input.ALT = alt
		
		end
		
		local a = event.type == "InputEventType_Release"
		local unlock = butt:match("_up") or butt:match("_down")
		if unlock then

			Info.Input.UpDown = true
			if a then Info.Input.UpDown = false end

			if input.down then

				-- Up and Down Amplitude
				Info.Command = "SetPos"
				if Info.Input.CTRL then
					if butt:match("_up")
					and Info.Amp.Index <= 6 then
						Info.Amp.Index = Info.Amp.Index + 1
						Info.Command = "Amplitude"
					elseif butt:match("_down")
					and Info.Amp.Index >= 2  then
						Info.Amp.Index = Info.Amp.Index - 1
						Info.Command = "Amplitude"
					end
				end

				self:playcommand("Update")

			end

		end
		
		-- CTRL Amp
		if input.button:match("left ctrl") then
			Info.Input.CTRL = true
			if a then Info.Input.CTRL = false end
		end
		
	end )

	self:SetUpdateFunction(function()

		if Info.Input.UpDown then
			self.Container[2] = false
		end
		
		if bitEye.Refresh then
			self:sleep(0.2):queuecommand("Refresh")
			self:playcommand("Update")
			bitEye.Refresh = false
		end

		if Info.Input.ALT
		and not self.Container[2] then
			self:playcommand("Update")
			self.Container[2] = true
		end

		if Info.Input.ALT and self.Container[1] then
			self:stoptweening():linear(0.25)
			self:diffusealpha(1)
			self.Container[1] = false
		elseif not self.Container[1] and not Info.Input.ALT then
			self:stoptweening():linear(0.25)
			self:diffusealpha(0)
			self.Container[1] = true
			self.Container[2] = false
		end

		if not tostring(screen):match( "ScreenEdit" )
		or screen:GetEditState() == "EditState_Playing" then
			self:diffusealpha(0)
			Info.Input.ALT = false
		end

	end)

end

local s = bitEye.SPath .. "Window/Textures/"
s = s .. "BGChanges.lua"
return Def.ActorFrame{ 
	Name="bitEye beatWindow",
	Def.ActorFrameTexture{ 
		Def.ActorFrame{
			OnCommand=function(self)
				BigOperation(self)
			end,
			loadfile(s)()
		},
		InitCommand=function(self)
			self:setsize( w * 0.5, h * 0.5 )
			self:EnableAlphaBuffer(true)
			self:Create()
			bitEye.ScreenTex = self:GetTexture()
		end
	},
	Def.Sprite{
		InitCommand=function(self)
			self:Center()
			self:SetTexture(bitEye.ScreenTex)
		end
	}
}
