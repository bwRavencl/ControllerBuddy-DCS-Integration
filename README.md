## ControllerBuddy-DCS-Integration

#### License Information:
GNU General Public License v2.0

#### Description:
This is a small Lua script for your DCS `Scripts` folder that makes using [ControllerBuddy](https://github.com/bwRavencl/ControllerBuddy) with [DCS World](https://www.digitalcombatsimulator.com) even more comfortable.  
The script automatically starts ControllerBuddy in local mode with a profile that matches the current player aircraft when entering a mission.  
When the player switches between aircraft the script will automatically intruct ControllerBuddy to load the correct profile for the newly selected aircraft.

#### Instructions:
- In order to install the script, place both `Export.lua` and `ControllerBuddy.lua` into your `Saved Games\DCS\Scripts` folder.
- Create a new environment variable called `CONTROLLER_BUDDY_EXECUTABLE` that points to the `ControllerBuddy.exe` executable inside your ControllerBuddy installation folder.
- Create a second environment variable called `CONTROLLER_BUDDY_PROFILE_DIR` that points to a folder that contains your ControllerBuddy profiles.
- In order for ControllerBuddy to be able to match between a DCS aircraft and a profile, the profile filename must follow the following scheme: `DCS_$DCS_INTERNAL_AIRCRAFT_NAME.json` (e.g. `DCS_FA-18C_hornet.json`)

Please refer to the [author's profile repository](https://github.com/bwRavencl/ControllerBuddy-Profiles) for a complete set of correctly named ControllerBuddy profiles for DCS.
