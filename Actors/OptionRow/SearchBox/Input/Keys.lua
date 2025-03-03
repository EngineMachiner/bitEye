
-- Returns the input callback function that reads the keys pressed to search.

local find = Astro.Table.find

local isFunction = Astro.Type.isFunction


local SearchBox

local function searchBox()
    
    local main = bitEye.Actors.OptionRow        return main:GetChild("SearchBox")

end


local specials = {

    ["^space"] = ' ',
    
    ["^KP %d"] = function(key) return key:gsub( "KP ", '' ) end

}

local function special( key, val )
    
    return isFunction(val) and val(key) or val

end

local function onSpecial(key)

    if #key <= 2 then return key end -- If it's not special return.


    local val = find( specials, function(k) return key:match(k) end )

    if not val then return '' end

    
    return special( key, val )

end

local function key(button)

    button = button:gsub( "DeviceButton_", '' )         button = onSpecial(button)

    local capsOn = SearchBox.capsOn

    return capsOn and button:upper() or button

end

local function onFirstPress(event)

    local isFirstPress = event.type:match("FirstPress")

	if not isFirstPress then return end


	-- Store and pass the inputs onto the string.

    local button = event.DeviceInput.button         local input = SearchBox.input
    
    local concat = table.concat { input, key(button) }
    
    if input ~= concat then SearchBox.input = concat end

    SearchBox:playcommand("Update")

end


local function erase()

    local s = SearchBox.input       SearchBox.input = s:sub( 1, -2 )

end

local function onRepeat(event)

    local type = event.type

    local isRepeated = type:match("FirstPress") or type:match("Repeat")

	if not isRepeated then return end


	-- Backspace.

    local button = event.DeviceInput.button

    button = button:gsub( "DeviceButton_", '' )

    if not button:match("^backspace") then return end

    erase()     SearchBox:playcommand("Update")

end


return function(event)

	SearchBox = searchBox()           local isVisible = SearchBox.isVisible
    
    if not isVisible then return end

    
    onFirstPress(event)     onRepeat(event)
	
end