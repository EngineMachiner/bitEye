
local Vector = Astro.Vector

bitEye.Config = {

    AnimationSpeed = 1, -- Sprite animation and tweening.


    -- The EditNoteField preview is centered at { x = 0, y = 0 }

    -- In newest versions it follows the edit notefield position.

    EditNoteField = {  Pos = Vector { x = 425, y = 0 }  },
    

    -- The OptionRow preview is at the center top when { x = 0, y = 0 }

    OptionRow = {  Pos = Vector { x = 0, y = 0 },   ZoomIn = 0.25 }
    
}