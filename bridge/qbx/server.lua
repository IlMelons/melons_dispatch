assert(lib.checkDependency("qbx_core", "1.18.1"), "qbx_core v1.18.1 or higher is required")

server = {}
local QBX = exports.qbx_core

---@param group string group name
---@param search string "count" or "ids"
---@description function to get count or ids of players on duty for one group
function server.GetOnDutyPlayers(group, search)
    local count, ids = QBX:GetDutyCountJob(group)

    if search == "count" then
        return count
    elseif search == "ids" then
        return ids
    end
end