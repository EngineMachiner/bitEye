local tbl = {}
local ScaleVar = _screen.h/480

local function CheckSprites(self)

	local s = tostring(self)

	self:effectclock("timer")
	self:set_tween_uses_effect_delta(false)

	if string.match(s,"Sprite") then
		self:set_use_effect_clock_for_texcoords(false)
	else
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
		local name = row:GetName()
		local choice = row:GetChoiceInRowWithFocus(pn)

		if SCREENMAN:GetTopScreen():GetCurrentRowIndex('PlayerNumber_P1') == 10 then
			--SCREENMAN:SystemMessage( FILEMAN:GetDirListing("/BGAnimations/", true, true)[tonumber(choice) + 1] )
			tbl["dir"] = FILEMAN:GetDirListing("/BGAnimations/", true, true)[tonumber(choice) + 1]
			self:RemoveAllChildren()
			self:AddChildFromPath(tbl["dir"].."/default.lua")
			self:AddChildFromPath("/BGAnimations/Scripts/BG_RM_Content.lua")
			self:diffusealpha(1)
			self:xy( SCREEN_WIDTH - 640 * 0.25 * 0.5 * 3 * 0.8 * ScaleVar ,
				 480 * 0.25 * 0.5 * 0.25 * ScaleVar )
			self:zoom(0.25*0.5)
			self:RunCommandsOnChildren(function(child)
				child:playcommand("On"):playcommand("GainFocus")
				child:effectclock("timer")
				child:set_tween_uses_effect_delta(false)
				CheckSprites(child)
			end)
		elseif SCREENMAN:GetTopScreen():GetCurrentRowIndex('PlayerNumber_P1') == 11 then 
			tbl["dir"] = FILEMAN:GetDirListing("/RandomMovies/")[tonumber(choice) + 1]
			self:RemoveAllChildren()
				:AddChildFromPath("/RandomMovies/"..tbl["dir"])
			self:xy( SCREEN_WIDTH - 304 * 0.5 * ScaleVar , ( 176 + 25 ) * 0.5 * ScaleVar )
			self:diffusealpha(1)
			self:zoom( ScaleVar )
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