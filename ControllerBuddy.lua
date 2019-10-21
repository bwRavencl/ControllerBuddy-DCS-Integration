local prevExport = {}
prevExport.LuaExportActivityNextEvent = LuaExportActivityNextEvent
prevExport.LuaExportBeforeNextFrame = LuaExportBeforeNextFrame

local lastName = nil

LuaExportActivityNextEvent = function(tCurrent)
    local data = LoGetSelfData()

    if data and lastName ~= data.Name then
        os.execute('start %CONTROLLER_BUDDY_EXECUTABLE% -autostart local -tray -profile "%CONTROLLER_BUDDY_PROFILE_DIR%\\DCS_'..data.Name..'.json"')
        lastName = data.Name
    end

    pcall(function()
        if prevExport.LuaExportActivityNextEvent then
            prevExport.LuaExportActivityNextEvent(tCurrent)
        end
    end)

    return tCurrent + 0.1
end
