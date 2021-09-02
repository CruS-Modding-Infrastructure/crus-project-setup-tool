# Cruelty Squad Project Setup Tool

Tool consisting of a batch script and folder of every game script in Cruelty Squad, which strikes a balance between copyright infringement and ease of setup by only automating the most unpleasant part of creating a modding copy of the game.

It copies scripts that have already been decompiled and fixed, then deletes their .gdc and .gd.remap counterparts. In addition, a few small fixes in `Scripts/E_Grunt_Movement_New.gd` have been applied to help the intro cutscene play properly.

## How to use

1. Extract `_SETUP_PROJECT_` folder into project root directory
2. Run `setup_scripts.bat`

## Credits

All game scripts outside of the addons folder belong to Consumer Softproducts  
BitmapFontCutter addon from https://github.com/nobuyukinyuu/BitmapFontCutter  
Screen Space Decals addon from https://github.com/Mr-Slurpy/Screen-Space-Decals  
Qodot addon from https://github.com/Shfty/qodot-plugin
