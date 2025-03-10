
return tapLua.Quad {

    InitCommand=function(self)

        self:setSizeVector( tapLua.screenSize() )

        self:diffuse( Color.Black ):fadeleft(0.25):faderight(0.25)
        
        self:zoomx( self:GetZoomX() * 2 )

    end

}