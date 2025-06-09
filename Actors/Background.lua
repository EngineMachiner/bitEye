
return tapLua.Quad {

    InitCommand=function(self)

        local size = tapLua.screenSize()        self:setSizeVector(size)

        self:diffuse( Color.Black ):fadeleft(0.25):faderight(0.25)
        
        self:zoomx( self:GetZoomX() * 2 )

    end

}