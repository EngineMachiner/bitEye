
local scl = SCREEN_HEIGHT/480

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

local scroll = { 1, 1.5, 2, 3, 4, 6, 8 }
local s_key = 1

local function SearchFiles(dir, tbl)
	for m=1,#dir do
		if dir[m]:match("/" .. tbl["file1"]) then
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
	self:y( 60 + 32 * ( tbl["start_beat"] - GAMESTATE:GetSongBeat() ) * scroll[s_key] )
	self:y( self:GetY() * scl )
end

local function BGA_Init(self, tbl)
	if not self.Name then
		self.Name = tbl["start_beat"]
		self:stoptweening():stopeffect()
		self:zoom(0.0625)
		self:x( SCREEN_CENTER_X + SCREEN_WIDTH * 0.1875 )
		self:y( 44 + 32 * ( tbl["start_beat"] - GAMESTATE:GetSongBeat() ) * scroll[s_key] )
		self:y( self:GetY() * scl )
		self:playcommand("GainFocus"):playcommand("On")
		CheckSprites(self)
	end
end

local function AddBGChangesPreviews(self)

	self:RemoveAllChildren()

	local BGA_dir = FILEMAN:GetDirListing("/BGAnimations/", true, true)
	local RM_dir = FILEMAN:GetDirListing("/RandomMovies/", false, true)
	local Song_dir = FILEMAN:GetDirListing(GAMESTATE:GetCurrentSong():GetSongDir(), false, true)

	local BGChanges = GAMESTATE:GetCurrentSong():GetBGChanges()

	for i=1,#BGChanges do

		local temp = BGChanges[i]

		if temp["start_beat"] >= 0 then

			if temp["start_beat"] >= GAMESTATE:GetSongBeat() - 2 * scroll[s_key]
			and temp["start_beat"] < GAMESTATE:GetSongBeat() + 13 * scroll[s_key] then
				
				if SearchFiles(BGA_dir,temp)
				or SearchFiles(RM_dir,temp)
				or SearchFiles(Song_dir,temp) then

					if not temp["file1"]:match( ".%p%a%a%a" )
					and SearchFiles(BGA_dir,temp) then

						self:AddChildFromPath("/Scripts/editmode-tool/BGA-RM-BG.lua")
						self:AddChildFromPath("/BGAnimations/"..temp["file1"].."/default.lua")
						self:AddChildFromPath("/Scripts/editmode-tool/BGA-RM-Front.lua")

						self:RunCommandsOnChildren(function(child)
							BGA_Init(child, temp)
						end)

					elseif temp["file1"]:match( ".%p%a%a%a" ) then 

						local path 
						if SearchFiles(RM_dir,temp) then
							path = "/RandomMovies/"
						elseif SearchFiles(Song_dir,temp) then 
							path = GAMESTATE:GetCurrentSong():GetSongDir()
						end
					
						if path then

							self:AddChildFromPath("/Scripts/editmode-tool/BGA-RM-BG.lua")
							ChildNaming(self, "BG")

							self:AddChildFromPath(path..temp["file1"]) --only videos
							ChildNaming(self, "Movie")

							self:AddChildFromPath("/Scripts/editmode-tool/BGA-RM-Front.lua")

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

					self:AddChildFromPath("/Scripts/editmode-tool/BGA-MissingInfo.lua")
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

		local val, show, show_2
		local count, count_2 = 0, 0
		self.Time = 0

		local function KeyTrigger(event)

			local val_2, val_3 = false
			if event["DeviceInput"].down then
		
				local b = event["DeviceInput"].button
				local function ButtonMachine( s_butt, value )
		
					local v = value
		
					if b:match( s_butt ) then
		
						if not v then
							v = true
						else
							v = false
						end
		
						--[[
						if s_butt == "_up"
						or s_butt == "_down" then 
							count_2 = count_2 + 1
							if count_2 <= 2 then
								return true
							else
								return false
							end
						else
							return v
						end
						]]
		
						return v
		
					else
		
						return value
		
					end
		
				end
		
				show = ButtonMachine( "_left alt", show )
				show_2 = ButtonMachine( "_up", show_2 )
				show_2 = ButtonMachine( "_down", show_2 )
		
				if b:match( "_left ctrl" ) then
					val_2, val_3 = false
					val = true
					count = count + 1
				end
		
				if b:match( "_up" ) and val then
					val_2 = true
					val_3 = false
				end
		
				if b:match( "_down" ) and val then
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
				count, count_2 = 0, 0
			end
		
		end
		SCREENMAN:GetTopScreen():AddInputCallback( KeyTrigger )

		self:SetUpdateFunction(function()

			if show_2 and show then
				AddBGChangesPreviews(self)
				show_2 = false
			end

			if not show or count_2 >= 3 then
				self:RemoveAllChildren()
			end	

			local screen = tostring(SCREENMAN:GetTopScreen())
			if not screen:match( "ScreenEdit" ) then
				show = false
			end

		end)

	end,

	OffCommand=function(self)
		self:RemoveAllChildren()
	end

}