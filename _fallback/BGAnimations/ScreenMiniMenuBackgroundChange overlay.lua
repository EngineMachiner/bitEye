
local pn, screen, index, row, choice = 'PlayerNumber_P1'

local dir, show
local count = 0

local function PopPreview(event)

	if event["DeviceInput"].down then

		if event["DeviceInput"].button:match("_left alt") then
			if not show then
				show = true
			else
				show = false
			end
		end

		-- Delay for crashing
		--[[
		if show 
		and ( event["DeviceInput"].button:match("_left")
		or event["DeviceInput"].button:match("_right") ) then
			 => count = count + 1
		end

	else
		count = 0
		
		]]

	end

end

local function CheckSprites(self)

		local s = tostring(self)

		self:effectclock("timer")
		self:set_tween_uses_effect_delta(false)

		if s:match("Sprite") then
			self:set_use_effect_clock_for_texcoords(false)
		elseif s:match("ActorFrame") and self:GetChildren() then
			self:RunCommandsOnChildren( function(child)
				CheckSprites(child)
			end )
		end

end

local function Resize(child)
	child:stoptweening():stopeffect()
	child:zoom(0.125)
	child:x( SCREEN_WIDTH * ( - 0.0625 + 0.5 ) )
	child:y( SCREEN_HEIGHT * ( - 0.0625 * 1.5 + 0.125 ) )
	child:playcommand("On")
	CheckSprites(child)
end

local t = Def.ActorFrame{

	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback( PopPreview )
		self:SetUpdateFunction(function()
			if show then
				self:diffusealpha(1)
			else
				self:diffusealpha(0)
			end		
		end)
	end,

	OffCommand=function(self)
		self:RemoveAllChildren()
	end

}

local BGA_dir = FILEMAN:GetDirListing("/BGAnimations/", true, true)
local RM_dir = FILEMAN:GetDirListing("/RandomMovies/")

local function RefreshBGA_RM(self)

	self:RemoveAllChildren()

	local check, check_2
	screen = SCREENMAN:GetTopScreen()
	index = screen:GetCurrentRowIndex(pn)
	row = screen:GetOptionRow(index)
	choice = row:GetChoiceInRowWithFocus(pn)

	for i = 10,13 do
		if index == i then 
			check = true
			if index > 10 then 
				check_2 = true
			end
		end
	end

	self:AddChildFromPath("/Scripts/editmode-tool/BGA-RM-SF.lua")
	self:RunCommandsOnChildren( function(child)
		child.Name = "SF"
	end)

	if check then 
		self:AddChildFromPath("/Scripts/editmode-tool/BGA-RM-BG.lua")
		self:RunCommandsOnChildren( function(child)
			if not child.Name then 
				child.Name = "BG" 
			end
		end)
	end

	if index == 10 then

		dir = BGA_dir[tonumber(choice) + 1]
		self:AddChildFromPath(dir.."/default.lua")

	else

		if check_2 then

			dir = RM_dir[tonumber(choice) + 1]

			self:AddChildFromPath("/RandomMovies/"..dir)
			self:RunCommandsOnChildren( function(child)
				if not child.Name then 
					child.Name = "Movie"
				end
			end )

		end

	end

	if check then
		self:AddChildFromPath("/Scripts/editmode-tool/BGA-RM-Front.lua")
	end

	self:RunCommandsOnChildren( function(child)
		if child.Name == "Movie" then
			child:Center()
			child:scale_or_crop_background()
			child:zoom( child:GetZoom() * 0.125 )
			child:y( child:GetY() - SCREEN_HEIGHT * 0.406725 )	
		else
			if child.Name == "SF" then
				child:stoptweening()
				child:playcommand("On")
			else
				Resize(child)
			end
		end
	end )

end

	t.ChangeRowMessageCommand=function(self)
		if show then
			RefreshBGA_RM(self)
		else
			self:RemoveAllChildren()
		end
	end

	t.MenuLeftP1MessageCommand=function(self)
		if show and count <= 3 then
			RefreshBGA_RM(self)
		else
			self:RemoveAllChildren()
		end
	end

	t.MenuRightP1MessageCommand=function(self)
		if show and count <= 3 then
			RefreshBGA_RM(self)
		else
			self:RemoveAllChildren()
		end
	end

return Def.ActorFrame{ t }