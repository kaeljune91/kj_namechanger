local core = exports['rsg-core']:GetCoreObject()
local Config = lib.load('config')

-- Change webhookURL here
local webhookURL = 'https://discord.com/api/webhooks/1493241067036872794/dc0-URStLrupQK2EvmS2p8QwPJd8xb4AqpCyol7gQUtpDCwrnJR58jJx9UWEUvBsaa9W'

local function Notify(tgt, title, txt, type)
    TriggerClientEvent('kj_namechanger:cl:notify', tgt, title, txt, type)
end

local function pushLog(source, playerId, oldName, newName)
    local changer = core.Functions.GetPlayer(source)
    local changerName = changer.PlayerData.charinfo.firstname..' '..changer.PlayerData.charinfo.lastname
    newName = newName[1]..' '..newName[2]
    local dump = {
        {
            ["title"] = "Name Changer Log",
            ["description"] = changerName..' Player ID ['..source..'] has changed '..oldName..' player\'s ['..playerId..'] name. \n New Name: ' .. newName,
            ["color"] = 16744192,
            ["footer"] = {
                ["text"] = "Name Changer by kaeljune#0091 \n"..os.date("%x %X %p")
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Name Changer", embeds = dump}), { ['Content-Type'] = 'application/json' })
end

local function CheckPerms(ply)
    local hasJob = false
    local isAdmin = IsPlayerAceAllowed(ply, 'admin') or IsPlayerAceAllowed(ply, 'god')
    local jobCheck = core.Functions.GetPlayer(ply).PlayerData.job.name

    for k, v in pairs(Config.locations) do
        if jobCheck == v.job then
            hasJob = true
            break
        end
    end

    if isAdmin or hasJob then
        return true
    end
    return false
end

RegisterNetEvent('kj_namechanger:sv:changeName', function(dat)
    local src = source
    local playerId = dat.playerSelect
    local newName = dat.name
    local ply = core.Functions.GetPlayer(playerId)
    local playerDat = ply.PlayerData
    local oldName = playerDat.charinfo.firstname..' '..playerDat.charinfo.lastname
    local hasPerm = CheckPerms(src)

    if hasPerm then
        if not newName or newName[1] == '' or newName[2] == '' then Notify(src, 'Name Changer', 'Please enter a valid name!', 'error') return end

        playerDat.charinfo.firstname = newName[1]
        playerDat.charinfo.lastname = newName[2]

        ply.Functions.SetPlayerData('charinfo', playerDat.charinfo)

        pushLog(src, playerId, oldName, newName)

        Notify(playerId, 'Name Changer', 'Successfully changed Player ['..playerId..'] name to '..newName[1]..' '..newName[2], 'success')
        Notify(src, 'Name Changer', 'Successfully changed Player ['..playerId..'] name to'..newName[1]..' '..newName[2], 'success')
    else
        Notify(src, 'Name Changer', 'You do not have permission to use this!', 'error')
        Wait(3000)
        DropPlayer(src, 'Kicked | Reason: Exploiting Name Changer')
    end
end)

lib.callback.register('kj_namechanger:sv:getPlayers', function(source)
    local allPlys = GetActivePlayers()
    return allPlys
end)