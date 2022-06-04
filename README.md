## ControllerBuddy-DCS-Integration

#### License Information:
GNU General Public License v3.0

#### Description:
This is a small Lua script for your DCS `Scripts` folder that makes using [ControllerBuddy](https://controllerbuddy.org) with [DCS World](https://www.digitalcombatsimulator.com) even more comfortable.  
The script automatically starts ControllerBuddy in local mode with a profile that matches the current player aircraft when entering a mission.  
When the player switches between aircraft the script will automatically intruct ControllerBuddy to load the correct profile for the newly selected aircraft.

#### Instructions:
1. Create a new folder called `ControllerBuddy-DCS-Integration` inside your `Saved Games\DCS\Scripts` folder.
2. Place `ControllerBuddy.lua` into this newly created folder.
3. Create a text file called `Export.lua` inside the `Saved Games\DCS\Scripts` with the following content:
   `dofile(lfs.writedir()..[[Scripts\ControllerBuddy-DCS-Integration\ControllerBuddy.lua]])`  
   If a file called `Export.lua` already exists, simply append the above line to the end of the file.
4. Create a new environment variable called `CONTROLLER_BUDDY_EXECUTABLE` that points to the `ControllerBuddy.exe` executable inside your ControllerBuddy installation folder.
5. Create a second environment variable called `CONTROLLER_BUDDY_PROFILES_DIR` that points to a folder that contains your ControllerBuddy profiles.
6. In order for ControllerBuddy to be able to match between a DCS aircraft and a profile, the profile filename must follow the following scheme: `DCS_$DCS_INTERNAL_AIRCRAFT_NAME.json` (e.g. `DCS_FA-18C_hornet.json`)

Please refer to the [author's profile repository](https://github.com/bwRavencl/ControllerBuddy-Profiles) for a complete set of correctly named ControllerBuddy profiles for DCS.
