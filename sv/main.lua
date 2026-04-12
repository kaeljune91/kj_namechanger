local core = exports['rsg-core']:GetCoreObject()

local function Notify(tgt, title, txt, type)
    TriggerClientEvent('kj_namechanger:cl:notify', tgt, title, txt, type)
end

local function pushLog()
    -- to do enter log system here
end

RegisterNetEvent('kj_namechanger:sv:changeName', function(dat)
    local src = source
    local playerId = dat.playerSelect
    local name = dat.name

    local ply = core.Functions.GetPlayer(playerId)

    if not name or name[1] == '' or name[2] == '' then Notify(src, 'Name Changer', 'Please enter a valid name!', 'error') return end

    local playerDat = ply.PlayerData

    playerDat.charinfo.firstname = name[1]
    playerDat.charinfo.lastname = name[2]

    ply.Functions.SetPlayerData('charinfo', playerDat.charinfo)

    Notify(playerId, 'Name Changer', 'Successfully changed Player ['..playerId..'] name to '..name[1]..' '..name[2], 'success')
    Notify(src, 'Name Changer', 'Successfully changed Player ['..playerId..'] name to'..name[1]..' '..name[2], 'success')
end)

lib.callback.register('kj_namechanger:sv:getPlayers', function(source)
    local allPlys = GetActivePlayers()
    return allPlys
end)