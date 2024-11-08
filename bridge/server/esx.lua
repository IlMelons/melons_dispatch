if GetResourceState("es_extended") ~= "started" then return end

ESX = exports["es_extended"]:getSharedObject()

SVConfig = require "config.server"

---@diagnostic disable: duplicate-set-field
server = {}

function server.GetOnDutyPlayers(group, search)
    local xPlayers = ESX.GetExtendedPlayers("job", group)
    local count, ids = 0, {}
    for i=1, #xPlayers do
        count = count + 1
        ids[count] = xPlayers[i].source
    end

    if search == "count" then
        return count
    elseif search == "ids" then
        return ids
    end
end

function server.HasWhitelistedJob(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    for i=1, #SVConfig.WhitelistedJobs do
        if xPlayer.job.name == SVConfig.WhitelistedJobs[i] then
            return true
        end
    end
    return false
end