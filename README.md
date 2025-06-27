[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

# bitEye

**bitEye** is a tool, a set of actors to **preview animations and images in-game** designed for simfile creators using **[StepMania 5](https://github.com/stepmania/stepmania) or [OutFox](https://github.com/TeamRizu/OutFox)**.

This simplifies the process of creating background changes (BGChanges) for the simfiles.

**bitEye** focuses to be compatible with newer game builds, so it may not be compatible with older versions.

## Features

- An actor for the editor's notefield.

- An actor for the background changes menu.
    - This actor includes a search box to browse through search results.

https://user-images.githubusercontent.com/15896027/213898537-2c43ed29-0e4f-40b9-8ab4-c883ab724bf8.mp4

## Usage

Be aware that to successfully install bitEye in your game build, it's important to have a basic understanding of **scripting and theme structure**.

  1. Use [tapLua](https://github.com/EngineMachiner/tapLua).

---

### Outfox

  2. Clone the repository in the fallback's Modules folder.
  3. Load tapLua first and then load bitEye just once through a script.
  ```lua
    LoadModule("tapLua/tapLua.lua")
    LoadModule("bitEye/bitEye.lua")
  ```

### Legacy

  2. Clone the repository in the same Modules folder following the same steps for tapLua cloning.
  3. Load tapLua first and then load bitEye just once through a script.
  ```lua
    dofile("Modules/tapLua/tapLua.lua")
    LoadModule("bitEye/bitEye.lua")
  ```

---

   4. Add the actors to each screen (top layer) so they can be loaded:
   ```lua
   bitEye.actor("OptionRow") -- ScreenMiniMenuBackgroundChange
   bitEye.actor("EditNoteField") -- ScreenEdit
   ```

   5. Use the [inputs](#Inputs) to interact with it.

---

## Inputs

- **LEFT ALT:** toggles the visibility of the preview.

### OptionRow Actor

- **LEFT CTRL:** toggles the visibility of the search box.

- **RIGHT CTRL** key zooms in and out the preview.

- The search box accepts input and performs a search based on it.
  - You can navigate through the results using the **arrow keys**.

---

Remember, if you're having problems with the texture being white, not showing up 
and you're using legacy builds, you should enable only OpenGL as renderer in 
your `Preferences.ini` due to D3D not being able to render textures in these builds.
```
VideoRenderers=opengl
```

---

## Credits

- [TeamRizu](https://github.com/TeamRizu)
- [Inori](https://github.com/Inorizushi)
- [leadbman](https://github.com/leadbman)
- [Accelerator](https://github.com/RhythmLunatic)

Thank you to everyone who contributed to the development of this project!
