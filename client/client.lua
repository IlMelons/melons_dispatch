Alerts = {}
local AlertsDisabled = false
local SilentAlerts = false

function DeleteAlert(alertdata)
    for k, data in pairs(Alerts) do
        if data.id == alertdata.id then
            Alerts[k] = nil
            break
        end
    end
end

function ConvertColor(priority)
    if priority == "normal" then
        return "#FFFF00"
    elseif priority == "medium" then
        return "#FFA500"
    elseif priority == "high" then
        return "#FF0000"
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

    if action == "add" then
        TriggerEvent("melons_dispatch:client:EditAlerts", alertdata, true)
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
        Alerts[#Alerts + 1] = alertdata
    elseif action == "remove" then
        DeleteAlert(alertdata)
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

local OpenDispatchMenu = lib.addKeybind({
    name = 'OpenDispatchMenu',
    description = 'Open Dispatch Menu',
    defaultKey = "F10",
    onPressed = OpenDispatchMenu,
})