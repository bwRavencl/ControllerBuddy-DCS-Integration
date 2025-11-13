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

local function CBLog(level, str)
    log.write('CONTROLLERBUDDY', level, str)
end

local function FileExists(path)
    local file = io.open(path, 'r')
    if file ~= nil then
        file:close()
        return true
    end

    return false
end

CBLog(log.INFO, 'Initializing ControllerBuddy-DCS-Integration')

package.path = package.path..';.\\LuaSocket\\?.lua'
local socket = require('socket')

local isWine = FileExists('C:\\windows\\system32\\wineboot.exe')
CBLog(log.INFO, 'Running on '..(isWine and 'Wine' or 'Windows'))

local prevExport = {}
prevExport.LuaExportActivityNextEvent = LuaExportActivityNextEvent
prevExport.LuaExportBeforeNextFrame = LuaExportBeforeNextFrame

LuaExportActivityNextEvent = function(tCurrent)
    local function CallPrevExportAndReturn()
        pcall(function()
            if prevExport.LuaExportActivityNextEvent then
                prevExport.LuaExportActivityNextEvent(tCurrent)
            end
        end)

        return tCurrent + 0.1
    end

    local playerPlaneId = LoGetPlayerPlaneId()

    if lastPlayerPlaneId == playerPlaneId then
        return CallPrevExportAndReturn()
    end

    lastPlayerPlaneId = playerPlaneId

    local selfData = LoGetSelfData()
    if not selfData then
        return CallPrevExportAndReturn()
    end

    local profileFilename = 'DCS_'..selfData.Name..'.json'

    local controllerBuddyExe = os.getenv('CONTROLLER_BUDDY_EXECUTABLE')
    if not isWine then
        if controllerBuddyExe == nil then
            CBLog(log.WARNING, 'CONTROLLER_BUDDY_EXECUTABLE environment variable is not set')
            return CallPrevExportAndReturn()
        end

        if not FileExists(controllerBuddyExe) then
            CBLog(log.ERROR, 'ControllerBuddy executable does not exist: '..controllerBuddyExe)
            return CallPrevExportAndReturn()
        end
    end

    local profileDir = os.getenv('CONTROLLER_BUDDY_PROFILES_DIR')
    if profileDir == nil then
        CBLog(log.WARNING, 'CONTROLLER_BUDDY_PROFILES_DIR environment variable is not set')
        return CallPrevExportAndReturn()
    end

    if isWine and not string.match(profileDir, '^/.*') then
        CBLog(log.ERROR, 'CONTROLLER_BUDDY_PROFILES_DIR must be an absolute native Linux path on Wine')
        return CallPrevExportAndReturn()
    end

    if not isWine then
        profileDir = string.gsub(profileDir, '\\+$', '')
    elseif profileDir ~= '/' then
        profileDir = string.gsub(profileDir, '/+$', '')
    end

    local profilePath = profileDir..(isWine and '/' or '\\')..profileFilename
    local windowsProfilePath = isWine and 'Z:'..string.gsub(profilePath, '/', '\\') or profilePath

    if not FileExists(windowsProfilePath) then
        CBLog(log.WARNING, 'Profile file does not exist: '..windowsProfilePath)
        return CallPrevExportAndReturn()
    end

    local tmpDir
    if isWine then
        tmpDir = 'Z:\\tmp'
    else
        tmpDir = os.getenv('TMP')
        if tmpDir == nil then
            CBLog(log.WARNING, 'TMP environment variable is not set')
            return CallPrevExportAndReturn()
        end
        tmpDir = string.gsub(tmpDir, '\\+$', '')
    end
    local lockFilePath = tmpDir..'\\ControllerBuddy.lock'
    if not isWine and not FileExists(lockFilePath) then
        if controllerBuddyExe ~= nil then
            os.execute('start %CONTROLLER_BUDDY_EXECUTABLE% -autostart local -tray -profile "'..profilePath..'"')
        end
    else
        local file, err = io.open(lockFilePath, 'r')
        if not file then
            CBLog(log.ERROR, 'Could not open lockfile: '..err)
            return CallPrevExportAndReturn()
        end

        local portLine = file:read('*l')
        local tokenLine = file:read('*l')
        file:close()

        if not portLine or not tokenLine then
            CBLog(log.ERROR, 'Invalid lockfile')
            return CallPrevExportAndReturn()
        end

        local port = tonumber(portLine)
        if not port then
            CBLog(log.ERROR, 'Invalid port in lockfile')
            return CallPrevExportAndReturn()
        end

        local client = assert(socket.tcp())
        client:settimeout(5)

        local ok, connectErr = client:connect('127.0.0.1', port)
        if not ok then
            CBLog(log.ERROR, 'Connection failed: '..connectErr)
            return CallPrevExportAndReturn()
        end

    client:send(tokenLine..'\n'..'INIT\n'..'-autostart\n'..'local\n'..'-profile\n'..profilePath..'\n'..'EOF\n')

        local ackReceived = false
        for _ = 1, 5 do
            local response, _, partial = client:receive('*l')
            response = response or partial
            if response == 'ACK' then
                ackReceived = true
                break
            end
        end

        client:close()

        if not ackReceived then
            CBLog(log.ERROR, 'Did not receive ACK')
        end
    end

    return CallPrevExportAndReturn()
end
