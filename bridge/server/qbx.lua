if GetResourceState("qbx_core") ~= "started" then return end

QBX = exports.qbx_core

SVConfig = require "config.server"

---@diagnostic disable: duplicate-set-field
server = {}

function server.GetOnDutyPlayers(group, search)
    local count, ids = QBX:GetDutyCountJob(group)
    if search == "count" then
        return count
    elseif search == "ids" then
        return ids
    end
end

function server.HasWhitelistedJob(source)
    for i=1, #SVConfig.WhitelistedJobs do
        if QBX:HasPrimaryGroup(source, SVConfig.WhitelistedJobs[i]) then
            return true
        end
    end
    return false
end