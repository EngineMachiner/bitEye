
local Vector = Astro.Vector

bitEye.Config = {

    AnimationSpeed = 1, -- Sprite animation and tweening.


    -- The EditNoteField preview is centered when the vector is zero.

    -- In newest versions it follows the edit notefield position.

    EditNoteField = { Pos = Vector { x = 425, y = 0 } },
    

    -- The OptionRow preview is at the center top when the vector is zero.

    OptionRow = { Pos = Vector(),   ZoomIn = 0.25 }
    
}