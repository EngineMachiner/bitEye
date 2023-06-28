[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

# bitEye
bitEye is a library and tool to preview RandomMovies and BGAnimations when creating simfiles or charts in OutFox and StepMania 5+.

bitEye has been tested through from StepMania 5.0.12 to 5.3 / OutFox.

https://user-images.githubusercontent.com/15896027/213898537-2c43ed29-0e4f-40b9-8ab4-c883ab724bf8.mp4

## How to use

0. Make sure you have the tapLua library. ( https://github.com/EngineMachiner/tapLua )
1. Copy the bitEye folder to fallback Modules folder.
2. Load the tapLua and bitEye module using LoadModule() on the initial fallback screen.

   For example the ScreenInit overlay script should look like this using LoadModule(): <br><br>
   <img src=https://github.com/EngineMachiner/bitEye/assets/15896027/53af2402-f49d-46e2-8a46-f46d68b3ed37 width=400>
   <br><br>

3. Load bitEye's EditNoteField preview window actor to a fallback's ScreenEdit top layer:
```lua 
return Def.ActorFrame{ bitEye.spawn("EditNoteField/Actor") }
```

4. Load bitEye's OptionRow preview window actor to a fallback's ScreenMiniMenuBackgroundChange top layer:
```lua 
return Def.ActorFrame{ bitEye.spawn("EditNoteField/Actor") }
```

5. Use the inputs while on these screens.

## Inputs
* The **Left Alt** key shows and hides the preview on both screens.

#### ScreenMiniMenuBackgroundChange
* The **Left Ctrl** key opens the search box. 
* Write the keywords while focusing the search box and switch the option row between results by using the **DOT** and **ENTER** keys. **Only available on OutFox.**

* The **Right Ctrl** key zooms in and out the preview.

## Credits
- Project Moondance developers
- Inori
- leadbman
- Accelerator

