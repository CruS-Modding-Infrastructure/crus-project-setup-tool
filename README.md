# Cruelty Squad Project Setup Tool

Tool consisting of a batch script and folder of every game script in Cruelty Squad, which strikes a balance between copyright infringement and ease of setup by only automating the most unpleasant part of creating a modding copy of the game.

It copies scripts that have already been decompiled and fixed, then deletes their .gdc and .gd.remap counterparts. 

Fixes have been applied to:
- Help the intro cutscene play properly
- Improve game performance
- Clean up extraneous whitespace

## How to use

For complete instructions on setting up your own modding copy, take a look at [this guide](https://hackmd.io/@OsM6oUcXSwG3mLNvTlPMZg/rk56jogV_).

1. Download the [latest release](https://github.com/crustyrashky/crus-project-setup-tool/releases/download/1.0.0/crus-project-setup-tool-1.0.0.zip)
2. Extract `_SETUP_PROJECT_` folder into project root directory
3. Run `setup_scripts.bat`

## Credits

All game scripts outside of the addons folder belong to Consumer Softproducts  
BitmapFontCutter addon from https://github.com/nobuyukinyuu/BitmapFontCutter  
Screen Space Decals addon from https://github.com/Mr-Slurpy/Screen-Space-Decals  
Qodot addon from https://github.com/Shfty/qodot-plugin
