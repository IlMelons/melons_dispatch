if not lib.checkDependency("qbx_core", "1.21.0", true) then return end

---@diagnostic disable: duplicate-set-field

SVConfig = require "config.server"

server = {}
local QBX = exports.qbx_core

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