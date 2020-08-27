
local pn, screen, index, row, choice = 'PlayerNumber_P1'

local dir, show

local function PopPreview(event)
	if event["DeviceInput"].down then
		if string.match(event["DeviceInput"].button, "_left alt" ) then
			if not show then
				show = true
			else
				show = false
			end
		end
	end
end

local function CheckSprites(self)

		local s = tostring(self)

		self:effectclock("timer")
		self:set_tween_uses_effect_delta(false)

		if string.match(s,"Sprite") then
			self:set_use_effect_clock_for_texcoords(false)
		elseif string.match(s,"ActorFrame") and self:GetChildren() then
			self:RunCommandsOnChildren( function(child)
				CheckSprites(child)
			end )
		end

end

local function Resize(child)
	child:zoom(0.125)
	child:x( SCREEN_WIDTH * ( - 0.0625 + 0.5 ) )
	child:y( SCREEN_HEIGHT * ( - 0.0625 * 1.5 + 0.125 ) )
	child:playcommand("GainFocus"):playcommand("On")
	CheckSprites(child)
end

local t = Def.ActorFrame{

	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback( PopPreview )
		self:playcommand("Update")
	end,

	UpdateCommand=function(self)
		if show then
			self:diffusealpha(1)
		else
			self:diffusealpha(0)
			self:RunCommandsOnChildren( function(child)
				child:stoptweening():stopeffect()
			end )
		end
		self:sleep(0.1)
		self:queuecommand("Update")
	end,

	OffCommand=function(self)
		self:RemoveAllChildren()
	end

}

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

	self:AddChildFromPath("/Scripts/_editmode-tool/BGA-RM-SF.lua")
	self:RunCommandsOnChildren( function(child)
		child.Name = "SF"
	end)

	if check then 
		self:AddChildFromPath("/Scripts/_editmode-tool/BGA-RM-BG.lua")
		self:RunCommandsOnChildren( function(child)
			if not child.Name then 
				child.Name = "BG" 
			end
		end)
	end

	if index == 10 then

		dir = FILEMAN:GetDirListing("/BGAnimations/", true, true)[tonumber(choice) + 1]
		self:AddChildFromPath(dir.."/default.lua")

	else

		if check_2 then

			dir = FILEMAN:GetDirListing("/RandomMovies/")[tonumber(choice) + 1]

			self:AddChildFromPath("/RandomMovies/"..dir)
			self:RunCommandsOnChildren( function(child)
				if not child.Name then 
					child.Name = "Movie"
				end
			end )
		end

	end

	if check then
		self:AddChildFromPath("/Scripts/_editmode-tool/BGA-RM-Front.lua")
	end

	self:RunCommandsOnChildren( function(child)
		if child.Name == "Movie" then
			child:stoptweening():stopeffect()
			child:Center()
			child:scale_or_crop_background()
			child:zoom( child:GetZoom() * 0.125 )
			child:y( child:GetY() - SCREEN_HEIGHT * 0.406725 )	
		else
			if child.Name == "SF" then
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
		if show then
			RefreshBGA_RM(self)
		end
	end

	t.MenuRightP1MessageCommand=function(self)
		if show then
			RefreshBGA_RM(self)
		end
	end

return Def.ActorFrame{ t }