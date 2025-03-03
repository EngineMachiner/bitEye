
return Def.Quad {

    InitCommand=function(self)

        self:FullScreen():xy(0,0)

        self:diffuse( Color.Black ):fadeleft(0.25):faderight(0.25)
        
        self:zoomx( self:GetZoomX() * 2 )

    end

}