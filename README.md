# ControllerBuddy-DCS-Integration

## 📖 Description

This is a small Lua script for your DCS `Scripts` folder that makes using [ControllerBuddy](https://controllerbuddy.org) with [DCS World](https://www.digitalcombatsimulator.com) even more comfortable.

The script automatically starts ControllerBuddy in local mode with a profile that matches the current player aircraft when entering a mission.

## ⬇️ Installing

> [!TIP]
> For the easiest way to install and update, use the [ControllerBuddy-Install-Script](https://github.com/bwRavencl/ControllerBuddy-Install-Script).  
> It automates all the steps below and much more!

1. Create a new folder named `ControllerBuddy-DCS-Integration` inside your `Saved Games\DCS\Scripts` folder.
2. Place `ControllerBuddy.lua` into this new folder.
3. Create a text file named `Export.lua` inside your `Saved Games\DCS\Scripts` folder with the following content:
   ```lua
   dofile(lfs.writedir()..[[Scripts\ControllerBuddy-DCS-Integration\ControllerBuddy.lua]])
   ```
   If a file named `Export.lua` already exists, simply append the above line to the end of the file.
4. Create a new environment variable named `CONTROLLER_BUDDY_EXECUTABLE` pointing to the `ControllerBuddy.exe` executable in your ControllerBuddy installation folder.
5. Create a second environment variable named `CONTROLLER_BUDDY_PROFILES_DIR` pointing to a folder containing your ControllerBuddy profiles.
6. In order for ControllerBuddy to be able to match between a DCS aircraft and a profile, the profile filename must follow the following scheme: `DCS_$DCS_INTERNAL_AIRCRAFT_NAME.json` (e.g. `DCS_FA-18C_hornet.json`)

Please refer to the [author's profile repository](https://github.com/bwRavencl/ControllerBuddy-Profiles) for a complete set of correctly named ControllerBuddy profiles for DCS.

## ⚖️ License

[GNU General Public License v3.0](LICENSE)
