
--[[

    Returns the input callback function that reads inputs 
    to open, close and switch results in the search box.

]]

local find = Astro.Table.find


-- Get some option row functions to shorten things a little.

local optionRow = bitEye.OptionRow

local currentIndex = optionRow.currentIndex

local getOptionRow = optionRow.get


-- Get the option row preview actor.

local function main() return bitEye.Actors.OptionRow end

local function searchBox() return main():GetChild("SearchBox") end


local keys = { MenuLeft = -1,   MenuRight = 1 }

local function findButton(button)

    local isValid = function(k) return button:match(k) end

    return find( keys, isValid ).value

end

local function choice(event)

    local SearchBox = searchBox()           if not SearchBox.isVisible then return end
    
    
    local button = event.GameButton

    local i = SearchBox.choice              local r = SearchBox.results
    
    local a = findButton(button)
    

    local isValid = r and a         isValid = isValid and #r > 0

    if not isValid then return end
    
    
    -- If there's no choice, default to the button value in the keys table.

    i = i and i + a or a           i = i % #r
    
    SearchBox.choice = i            i = i + 1

    
	local rowIndex = currentIndex()        local row = getOptionRow(rowIndex)


    -- Check if the function exists, it could not exist in a different game version.

	local setChoice = row.SetChoiceInRowWithFocus           if not setChoice then return end


    i = r[i] - 1          setChoice( row, "PlayerNumber_P1", i )


	-- Update and load the bitEye preview with the result.

	main():playcommand("Load")

end

local function onAction(event)

    local button = event.DeviceInput.button

	local isValid = main().isVisible and button:match("left ctrl")

	if not isValid then return end


    local SearchBox = searchBox()           local isVisible = not SearchBox.isVisible

	SearchBox.isVisible = isVisible


    local command = isVisible and "OpenBox" or "CloseBox"

	SearchBox:playcommand(command)

end

local function onFirstPress(event)

    local isFirstPress = event.type:match("FirstPress")
    
    if not isFirstPress then return end


    onAction(event) choice(event)

end


local function onUppercase(event)

    local button = event.DeviceInput.button

    local isShift = button:match("left shift")

    if not isShift then return end


    local type = event.type

    local isReleased = type:match("Release")

    searchBox().capsOn = not isReleased

end

return function(event) onFirstPress(event) onUppercase(event) end