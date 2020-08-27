
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

local scroll = { 1, 1.5, 2, 3, 4, 6, 8 }
local s_key, show, show_2 = 1
local val, val_2, val_3
local count = 0

local function KeyTrigger(event)

	val_2, val_3 = false
	if event["DeviceInput"].down then

		local function ButtonMachine( s_butt, value )
			local v = value
			if string.match(event["DeviceInput"].button, s_butt ) then
				if not v then
					v = true
				else
					v = false
				end
				return v
			else
				return value
			end
		end

		show = ButtonMachine( "_left alt", show )
		show_2 = ButtonMachine( "_up", show_2 )
		show_2 = ButtonMachine( "_down", show_2 )

		if string.match(event["DeviceInput"].button, "_left ctrl" ) then
			val_2, val_3 = false
			val = true
			count = count + 1
		end

		if string.match(event["DeviceInput"].button, "_up" ) and val then
			val_2 = true
			val_3 = false
		end

		if string.match(event["DeviceInput"].button, "_down" ) and val then
			val_3 = true
			val_2 = false
		end

		if val then
			if count <= 3 then
				if val_2
				and s_key < 7 then 
					s_key = s_key + 1
					val, val_2, val_3 = false
				elseif val_3
				and s_key > 1 then 
					s_key = s_key - 1
					val, val_2, val_3 = false
				end
			else
				count = 0
			end
		end

	else
		val = false
		count = 0
	end

end

local function SearchFiles(dir, tbl)
	for m=1,#dir do
		if string.match( dir[m], "/" .. tbl["file1"]  ) then
			return true
		end
		if m == #dir then 
			return false
		end
	end
end

local function ChildNaming(frame, name)
	frame:RunCommandsOnChildren(function(child)
		if not child.Name then 
			child.Name = name
		end
	end)
end

local function Movies_Init(self, tbl)
	self.Name = tbl["start_beat"]
	self:stoptweening():stopeffect()
	self:Center()
	self:scale_or_crop_background()
	self:x( SCREEN_CENTER_X + SCREEN_WIDTH * 0.22 )
	self:zoom( self:GetZoom() * 0.0625 )
	self:y( 90 + 48 * ( tbl["start_beat"] - GAMESTATE:GetSongBeat() ) * scroll[s_key] )
end

local function BGA_Init(self, tbl)
	if not self.Name then
		self.Name = tbl["start_beat"]
		self:playcommand("GainFocus"):playcommand("On")
		CheckSprites(self)
		self:zoom(0.0625)
		self:x( SCREEN_CENTER_X + SCREEN_WIDTH * 0.1875 )
		self:y( 66 + 48 * ( tbl["start_beat"] - GAMESTATE:GetSongBeat() ) * scroll[s_key] )
	end
end


local BGA_dir = FILEMAN:GetDirListing("/BGAnimations/", true, true)
local RM_dir = FILEMAN:GetDirListing("/RandomMovies/", false, true)
local Song_dir = FILEMAN:GetDirListing(GAMESTATE:GetCurrentSong():GetSongDir(), false, true)

local function AddBGChangesPreviews(self)

	self:RemoveAllChildren()

	local BGChanges = GAMESTATE:GetCurrentSong():GetBGChanges()

	for i=1,#BGChanges do

		local temp = BGChanges[i]

		if temp["start_beat"] >= 0 then

			if temp["start_beat"] >= GAMESTATE:GetSongBeat() - 2 * scroll[s_key]
			and temp["start_beat"] < GAMESTATE:GetSongBeat() + 13 * scroll[s_key] then
				
				if SearchFiles(BGA_dir,temp)
				or SearchFiles(RM_dir,temp)
				or SearchFiles(Song_dir,temp) then

					if not string.match( temp["file1"], ".%p%a%a%a" )
					and SearchFiles(BGA_dir,temp) then

						self:AddChildFromPath("/Scripts/_editmode-tool/BGA-RM-BG.lua")
						self:AddChildFromPath("/BGAnimations/"..temp["file1"].."/default.lua")
						self:AddChildFromPath("/Scripts/_editmode-tool/BGA-RM-Front.lua")

						self:RunCommandsOnChildren(function(child)
							BGA_Init(child, temp)
						end)

					elseif string.match( temp["file1"], ".%p%a%a%a" ) then 

						local path 
						if SearchFiles(RM_dir,temp) then
							path = "/RandomMovies/"
						elseif SearchFiles(Song_dir,temp) then 
							path = GAMESTATE:GetCurrentSong():GetSongDir()
						end
					
						if path then

							self:AddChildFromPath("/Scripts/_editmode-tool/BGA-RM-BG.lua")
							ChildNaming(self, "BG")

							self:AddChildFromPath(path..temp["file1"]) --only videos
							ChildNaming(self, "Movie")

							self:AddChildFromPath("/Scripts/_editmode-tool/BGA-RM-Front.lua")

							self:RunCommandsOnChildren(function(child)
								if child.Name == "Movie" then
									Movies_Init(child, temp)
								else
									BGA_Init(child, temp)
								end
							end)

						end

					end

				else

					self:AddChildFromPath("/Scripts/_editmode-tool/BGA-MissingInfo.lua")
					self:RunCommandsOnChildren(function(child)
						if not child.Name then
							BGA_Init(child, temp)
						end
					end)

				end

			end

		end

	end

end

return Def.ActorFrame{

	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback( KeyTrigger )
		self:playcommand("Update")
	end,

	UpdateCommand=function(self)
		
		if show_2 and show then
			AddBGChangesPreviews(self)
			show_2 = false
		end

		if not show then
			self:RemoveAllChildren()
		end

		if not string.match( tostring(SCREENMAN:GetTopScreen()), "ScreenEdit" ) then
			show = false
		end

		self:sleep(0.001)
		self:queuecommand("Update")

	end,

	OffCommand=function(self)
		self:RemoveAllChildren()
	end

}