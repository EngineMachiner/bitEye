
local ScaleVar = _screen.h/480

local dir

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

local function RefreshBGA_RM(self)
	
	if SCREENMAN:GetTopScreen():GetName() == "ScreenMiniMenuBackgroundChange" then

		local pn = 'PlayerNumber_P1'
		local screen = SCREENMAN:GetTopScreen()
		local index = screen:GetCurrentRowIndex(pn)
		local row = screen:GetOptionRow(index)
		local choice = row:GetChoiceInRowWithFocus(pn)

		if index == 10 then
			--SCREENMAN:SystemMessage( FILEMAN:GetDirListing("/BGAnimations/", true, true)[tonumber(choice) + 1] )
			dir = FILEMAN:GetDirListing("/BGAnimations/", true, true)[tonumber(choice) + 1]
			self:RemoveAllChildren()
			self:AddChildFromPath(dir.."/default.lua")
			self:AddChildFromPath("/Themes/_fallback/BGAnimations/BGA-RM-Screen.lua")
			self:RunCommandsOnChildren(function(child)
				child:finishtweening():stopeffect()
				child:playcommand("GainFocus"):playcommand("On")
				child:effectclock("timer")
				child:set_tween_uses_effect_delta(false)
				child:zoom(0.25*0.5)
				child:x( self:GetX() + SCREEN_WIDTH * 0.575 )
				child:y( self:GetY() + SCREEN_HEIGHT * 0.25 * 0.25 )
				CheckSprites(child)
			end)
		elseif index == 11 then 
			dir = FILEMAN:GetDirListing("/RandomMovies/")[tonumber(choice) + 1]
			self:RemoveAllChildren()
			self:AddChildFromPath("/RandomMovies/"..dir)
			self:AddChildFromPath("/Themes/_fallback/BGAnimations/BGA-RM-Screen.lua")
			self:RunCommandsOnChildren(function(child)
				child:zoomto( 640 * 0.25 * 0.5, 480 * 0.25 * 0.5 )
				child:x( SCREEN_WIDTH * 0.625 )
				child:y( SCREEN_HEIGHT * 0.25 * 0.5 )
			end)
		end

	end

end

local t = Def.ActorFrame{

	Def.ActorFrame{

		OnCommand=function(self)
			self:RemoveAllChildren()
		end,

		ChangeRowMessageCommand=function(self)
			self:RemoveAllChildren()
		end,

		MenuLeftP1MessageCommand=function(self)
			RefreshBGA_RM(self)
		end,

		MenuRightP1MessageCommand=function(self)
			RefreshBGA_RM(self)
		end

	}

}

return t
