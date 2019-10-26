function FileExists(path)
   local file = io.open(path, 'r')

   if file ~= nil then io.close(file)
       return true
   else
       return false
   end
end

local controllerBuddyExe = os.getenv("CONTROLLER_BUDDY_EXECUTABLE")
local profileDir = os.getenv("CONTROLLER_BUDDY_PROFILE_DIR")

if controllerBuddyExe == nil or profileDir == nil then
    return
end

local prevExport = {}
prevExport.LuaExportActivityNextEvent = LuaExportActivityNextEvent
prevExport.LuaExportBeforeNextFrame = LuaExportBeforeNextFrame

local lastName = nil

LuaExportActivityNextEvent = function(tCurrent)
    local data = LoGetSelfData()

    if data and lastName ~= data.Name then
        local profileFilename = 'DCS_'..data.Name..'.json'

        if FileExists(profileDir..'\\'..profileFilename) then
            os.execute('start %CONTROLLER_BUDDY_EXECUTABLE% -autostart local -tray -profile "%CONTROLLER_BUDDY_PROFILE_DIR%\\'..profileFilename..'"')
        end

        lastName = data.Name
    end

    pcall(function()
        if prevExport.LuaExportActivityNextEvent then
            prevExport.LuaExportActivityNextEvent(tCurrent)
        end
    end)

    return tCurrent + 0.1
end
