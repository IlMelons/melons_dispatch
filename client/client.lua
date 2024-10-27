Alerts = {}
AlertsBlips = {Blips = {}, Radius = {}}

local AlertsDisabled = false
local SilentAlerts = false

function ConvertColor(priority)
    if priority == "normal" then
        return "#FFFF00"
    elseif priority == "medium" then
        return "#FFA500"
    elseif priority == "high" then
        return "#FF0000"
    end
end

function ConvertBlipColor(priority)
    if priority == "normal" then
        return 5
    elseif priority == "medium" then
        return 47
    elseif priority == "high" then
        return 1
    end
end

function HandleAlerts(alertdata, action)
    if action == "add" then
        Alerts[#Alerts + 1] = alertdata
    elseif action == "remove" then
        for k, data in pairs(Alerts) do
            if data.id == alertdata.id then
                Alerts[k] = nil
                break
            end
        end
    end
end

function HandleBlips(alertdata, action)
    if action == "add" then
        local id = alertdata.id
        local coords = alertdata.coords
        local color = ConvertBlipColor(alertdata.priority)

        local alertBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        local alertBlipRadius = AddBlipForRadius(coords.x, coords.y, coords.z, 30.0)
        SetBlipSprite(alertBlip, alertdata.blip or 2)
        SetBlipColour(alertBlip, color or 5)
        SetBlipScale(alertBlip, 0.8)
        SetBlipDisplay(alertBlip, 2)
        SetBlipCategory(alertBlip, 1)
        SetBlipColour(alertBlipRadius, color or 84)
        SetBlipAlpha(alertBlipRadius, 128)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(alertdata.title or id)
        EndTextCommandSetBlipName(alertBlip)

        AlertsBlips.Blips[id] = alertBlip
        AlertsBlips.Radius[id] = alertBlipRadius
    elseif action == "remove" then
        local id = alertdata.id
        RemoveBlip(AlertsBlips.Blips[id])
        RemoveBlip(AlertsBlips.Radius[id])
        AlertsBlips.Blips[id] = nil
        AlertsBlips.Radius[id] = nil
    end
end

RegisterNetEvent("melons_dispatch:client:SettingsAlerts", function(action)
    if action == "toggle" then
        AlertsDisabled = not AlertsDisabled
        local status = AlertsDisabled and locale("disabled") or locale("enabled")
        lib.notify({title = locale("alerts_toggle_title"), description = locale("alerts_toggle_message")..status, position = "top", type = AlertsDisabled and "error" or "success"})
    elseif action == "mute" then
        SilentAlerts = not SilentAlerts
        local status = SilentAlerts and locale("enabled") or locale("disabled")
        lib.notify({title = locale("alerts_mute_title"), description = locale("alerts_mute_message")..status, position = "top", type = SilentAlerts and "success" or "error"})
    end
end)

RegisterNetEvent("melons_dispatch:client:DispatchAlert", function(alertdata, action)
    if AlertsDisabled then return end

    HandleAlerts(alertdata, action)
    HandleBlips(alertdata, action)

    if action == "add" then
        if not SilentAlerts then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end

        lib.notify({
            title = alertdata.code.." | "..alertdata.title,
            description = alertdata.message,
            duration = 10000,
            showDuration = true,
            position = "top",
            icon = alertdata.icon,
            iconColor = ConvertColor(alertdata.priority)
        })
    end
end)

function SetWaypoint(data)
    SetNewWaypoint(data.coords.x, data.coords.y)
    TriggerServerEvent("melons_dispatch:server:AlertAccepted", data)
    lib.notify({ description = "Waypoint Set", position = "top", type = "success" })
end

function OpenDispatchMenu()
    local options = {}
    for k, data in pairs(Alerts) do
        local option = {
            id = k,
            title = data.code.." | "..data.title,
            description = data.message,
            icon = data.icon,
            iconColor = ConvertColor(data.priority),
            onSelect = function()
                TriggerServerEvent("melons_dispatch:server:AlertAccepted", data)
                SetWaypoint(data)
            end,
        }
        options[#options + 1] = option
    end

    lib.registerContext({
        id = "dispatch_menu",
        title = "Dispatch Menu",
        options = options
    })
    lib.showContext("dispatch_menu")
end

RegisterNetEvent("melons_dispatch:client:OpenDispatchMenu", function()
    OpenDispatchMenu()
end)

OpenDispatchMenu = lib.addKeybind({
    name = 'OpenDispatchMenu',
    description = 'Open Dispatch Menu',
    defaultKey = "F10",
    onPressed = OpenDispatchMenu,
})