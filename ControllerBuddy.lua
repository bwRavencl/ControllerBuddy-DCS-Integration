--[[
Copyright (C) 2022  Matteo Hausner

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

function FileExists(path)
   local file = io.open(path, 'r')

   if file ~= nil then io.close(file)
       return true
   else
       return false
   end
end

local controllerBuddyExe = os.getenv('CONTROLLER_BUDDY_EXECUTABLE')
local profileDir = os.getenv('CONTROLLER_BUDDY_PROFILES_DIR')

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
            os.execute('start %CONTROLLER_BUDDY_EXECUTABLE% -autostart local -tray -profile "%CONTROLLER_BUDDY_PROFILES_DIR%\\'..profileFilename..'"')
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
