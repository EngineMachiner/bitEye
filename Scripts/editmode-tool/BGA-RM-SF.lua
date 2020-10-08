
local t = Def.ActorFrame{}

local r = {}
local s, caps, option, confirm = ""

local function LeftShift(event)

	if event["DeviceInput"].down then

		if string.match(event["DeviceInput"].button, "left shift" ) then
			caps = true
		end

		if string.match(event["DeviceInput"].button, "left ctrl" ) then
			if not option then
				option = true
			else
				s = ""
				option = false
			end
		end

		if string.match(event["DeviceInput"].button, "KP enter" )
		and confirm then
			if #r == 1 then
				local pn = 'PlayerNumber_P1'
				local screen = SCREENMAN:GetTopScreen()
				local index = screen:GetCurrentRowIndex(pn)
				local row = screen:GetOptionRow(index)
				local choice = row:GetChoiceInRowWithFocus(pn)
				row:SetChoiceInRowWithFocus(pn,r[1][1]-1)
			end
		end

	else
		caps = false
	end

end

local function InputToText( event )

	if event["DeviceInput"].down and option then

		local rec = event["DeviceInput"].button
		rec = string.gsub( rec, "DeviceButton", "" )

		if #rec > 2 then
			if string.match( rec, "_space" ) then
				rec = " "
			elseif string.match( rec, "_KP %d" ) then
				rec = string.gsub( rec, "_KP ", "" )
			elseif string.match( rec, "backspace" ) then
				s = string.sub( s, 1, #s-1 )
				rec = ""
			else
				rec = ""
			end
		end

		rec = string.gsub( rec, "_", "" )

		if caps then
			rec = string.upper(rec)
		end
		s = s .. rec

	end

end

local f = { InputToText, LeftShift }

local function RemoveInputs()
	if f then
		for i=1,#f do 
			SCREENMAN:GetTopScreen():RemoveInputCallback( f[i] ) 
		end
	end
end

	t[#t+1] = Def.Quad{
		Name="Block00",
		OnCommand=function(self)
			self:zoomto( 320 * 0.75, 160 )
			self:GetParent():xy( SCREEN_WIDTH - self:GetZoomedWidth() * 0.675, SCREEN_CENTER_Y - self:GetZoomedHeight() )
			self:diffuse(Color.Black)
			self:diffusealpha(0.5)
		end
	}


local copy

	t[#t+1] = Def.BitmapText{
		Font="Common normal",
		OnCommand=function(self)
		
			if not copy then 
				copy = s
				self:maxwidth(self:GetParent():GetChild("Block00"):GetZoomedWidth())
			end

			if copy ~= s or s == "" then
				self:settext(s)
			end

			if option then 
				self:GetParent():diffusealpha(1)
			else
				self:GetParent():diffusealpha(0)
			end

			self:sleep(0.1)
			self:queuecommand("On")
			self:diffuse(Color.White)

		end
	}

local dir, lim

	t[#t+1] = Def.BitmapText{
		Font="Common normal",
		OnCommand=function(self)

			self:y(30)

			if copy ~= s and lim and #s >= lim then

				r = {}

				for i=1,#dir do
					if dir[i] == s then
						r[#r+1] = { i, dir[i] }
					break
					end
					if string.match( dir[i], s ) then 
						r[#r+1] = { i, dir[i] }
					end
				end


				if #r == 1 then
					self:settext(#r .. " result")
					self:diffuse(Color.Green)
					confirm = true
				else
					self:settext(#r .. " results")
					self:diffuse(Color.Red)
					confirm = false
				end

			end

			if #r == 0 or #s < lim or not lim then
				self:settext("No results found")
				self:diffuse(color("#808080"))
				confirm = false
			end

			self:sleep(0.1)
			self:queuecommand("On")

		end
	}

return Def.ActorFrame{

	OnCommand=function(self)

		self.Name = "SF-Actor"
		self:playcommand("ChangeRowMessage")

		SCREENMAN:GetTopScreen():AddInputCallback( f[1] )
		SCREENMAN:GetTopScreen():AddInputCallback( f[2] )

		local pn = 'PlayerNumber_P1'
		local screen = SCREENMAN:GetTopScreen()
		local index = screen:GetCurrentRowIndex(pn)
		if index == 10 then
			dir = FILEMAN:GetDirListing("/BGAnimations/", true, true)
			lim = 5
		elseif index > 10 and index <= 13 then 
			lim = 3
			dir = FILEMAN:GetDirListing("/RandomMovies/")
		end
		
		s = ""

	end,

	OffCommand=function(self)
		s = ""
		RemoveInputs()
	end,

	t

}