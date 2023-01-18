
local path = bitEye.Path .. "Window/Textures/BGChanges.lua"

local function init(self)
	self.isVisible = false			self:diffusealpha(0)
end

return Def.ActorFrame{

	Def.ActorFrameTexture{

		InitCommand=function(self)

			local p = self:GetParent()
			local w = SCREEN_WIDTH		local h = SCREEN_HEIGHT

			self:setsize( w, h )
			self:EnableAlphaBuffer(true):EnableDepthBuffer(true)
			self:Create()

			p.Texture = self:GetTexture()		p:queuecommand("Draw")
			
		end,

		Def.ActorFrame{

			loadfile(path)(),
			HideCommand=function(self) self:stoptweening():linear(0.25):diffusealpha(0) end,
			ShowCommand=function(self) self:stoptweening():linear(0.25):diffusealpha(1) end,
			OnCommand=function(self)

				local update = bitEye.createCooldown( self, "cooldown", "limit", function(self) self:playcommand("bitEye") end )
				local screen = SCREENMAN:GetTopScreen()
				bitEye.EditNoteField = self				init(self)
				self.Layers = {}
			
				screen:AddInputCallback( function(event)
			
					local input = event.DeviceInput			local button = input.button

					if input.down then

						local isMoving = button:match("_up") or button:match("_down")
						if isMoving then self.cooldown = 0 end

						if button:match("_left alt") then

							self.isVisible = not self.isVisible
						
							local isVisible = self.isVisible		local commands = { "Hide", "Show" }
							for k,v in pairs( { not isVisible, isVisible } ) do
								if v then self:playcommand( commands[k] ) break end
							end

						end
			
					end
			
				end )
			
				self:SetUpdateFunction( function()
			
					local isPlaying = not tostring(screen):match( "ScreenEdit" )
					isPlaying = isPlaying or screen:GetEditState() == "EditState_Playing"
					if isPlaying then init(self) end

					update()

				end )

			end

		},

	},

	Def.Sprite{
		DrawCommand=function(self) self:Center():SetTexture( self:GetParent().Texture ) end
	}

}