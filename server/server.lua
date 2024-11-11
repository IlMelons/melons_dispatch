SVConfig = require "config.server"
AlertID = 0

function SendAlertToJobs(alertdata, action)
    if type(alertdata.jobs) == "table" then
        players = {}
        for i = 1, #alertdata.jobs do
            jobplayers = server.GetOnDutyPlayers(alertdata.jobs[i], "ids")
            lib.table.merge(players, jobplayers)
        end
    else
        players = server.GetOnDutyPlayers(alertdata.jobs, "ids")
    end
    lib.triggerClientEvent("melons_dispatch:client:DispatchAlert", players, alertdata, action)
end

function DispatchAlert(coords, type)
    AlertID += 1
    local alertdata = {
        id = AlertID,
        coords = coords,
        jobs = SVConfig.Alerts[type].jobs,
        title = SVConfig.Alerts[type].title,
        message = SVConfig.Alerts[type].message,
        code = SVConfig.Alerts[type].code,
        icon = SVConfig.Alerts[type].icon,
        blip = SVConfig.Alerts[type].blip,
        priority = SVConfig.Alerts[type].priority,
    }
    SendAlertToJobs(alertdata, "add")
end
exports("DispatchAlert", DispatchAlert)

RegisterServerEvent("melons_dispatch:server:AlertAccepted", function(data)
    SendAlertToJobs(data, "remove")
end)

lib.callback.register("melons_dispatch:server:HasWhitelistedJob", function(source)
    return server.HasWhitelistedJob(source)
end)

lib.addCommand("togglealerts", { help = "Toggle the Dispatch Alerts", restricted = false}, function(source, args, raw)
    if not server.HasWhitelistedJob(source) then return end
    TriggerClientEvent("melons_dispatch:client:SettingsAlerts", source, "toggle")
end)

lib.addCommand("mutealerts", { help = "Mute the Dispatch Alerts", restricted = false}, function(source, args, raw)
    if not server.HasWhitelistedJob(source) then return end
    TriggerClientEvent("melons_dispatch:client:SettingsAlerts", source, "mute")
end)

lib.addCommand("opendispatch", { help = "Opens Dispatch Menu", restricted = false}, function(source, args, raw)
    if not server.HasWhitelistedJob(source) then return end
    TriggerClientEvent("melons_dispatch:client:OpenDispatchMenu", source)
end)