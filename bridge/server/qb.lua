if GetResourceState("qb-core") ~= "started" then return end

QBCore = exports["qb-core"]:GetCoreObject()

SVConfig = require "config.server"

---@diagnostic disable: duplicate-set-field
server = {}

function server.GetOnDutyPlayers(group, search)
    local count, ids = 0, {}
    local Players = QBCore.Functions.GetQBPlayers()
    for _, player in pairs(Players) do
        if player.PlayerData.job.name == group and player.PlayerData.job.onduty then
            count = count + 1
            ids[count] = player.PlayerData.source
        end
    end

    if search == "count" then
        return count
    elseif search == "ids" then
        return ids
    end
end

function server.HasWhitelistedJob(source)
    local Player = QBCore.Functions.GetPlayer(source)
    for i=1, #SVConfig.WhitelistedJobs do
        if Player.PlayerData.job.name == SVConfig.WhitelistedJobs[i] then
            return true
        end
    end
    return false
end