# ControllerBuddy-DCS-Integration

## 📖 Description

This Lua script integrates [ControllerBuddy](https://controllerbuddy.org) with [DCS World](https://www.digitalcombatsimulator.com), making it easier and more seamless to use.

When you enter a mission, the script automatically starts ControllerBuddy in local mode and loads the profile that matches your current player aircraft. 
If ControllerBuddy is already running, it will simply switch to the correct profile for you.

**Note for Linux users:**  
The script works with DCS on Linux (Wine), but cannot auto-start ControllerBuddy in this environment. Please start ControllerBuddy manually before launching DCS.

## ⬇️ Installation

> [!TIP]
> For the easiest way to install and update on Windows, use the [ControllerBuddy-Install-Script](https://github.com/bwRavencl/ControllerBuddy-Install-Script).  
> It automates all the steps below and much more!

1. Create a new folder named `ControllerBuddy-DCS-Integration` inside your `Saved Games\DCS\Scripts` folder.
2. Place `ControllerBuddy.lua` into this new folder.
3. Create a text file named `Export.lua` inside your `Saved Games\DCS\Scripts` folder with the following content:
   ```lua
   dofile(lfs.writedir()..[[Scripts\ControllerBuddy-DCS-Integration\ControllerBuddy.lua]])
   ```
   If a file named `Export.lua` already exists, simply append the above line to the end of the file.
4. Create a new environment variable named `CONTROLLER_BUDDY_EXECUTABLE` pointing to the `ControllerBuddy.exe` executable in your ControllerBuddy installation folder.  
   (This step can be skipped on Linux.)
5. Create a second environment variable named `CONTROLLER_BUDDY_PROFILES_DIR` pointing to the folder containing your ControllerBuddy profiles.
6. Profile filenames must use the following format: `DCS_<DCS_INTERNAL_AIRCRAFT_NAME>.json` (for example: `DCS_FA-18C_hornet.json`).

For a complete set of ControllerBuddy profiles for DCS, check out the official [ControllerBuddy-Profiles](https://github.com/bwRavencl/ControllerBuddy-Profiles) repository.

## ⚖️ License

[GNU General Public License v3.0](LICENSE)
