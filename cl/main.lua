local Config = lib.load('config')
local core = exports['rsg-core']:GetCoreObject()

local function Notify(title, txt, type)
    lib.notify({
        title = title,
        description = txt,
        type = type,
        showduration = true,
        position = 'center-left',
        duration = 5000
    })
end

local function ChangeName()
    local allPlayers = lib.callback.await('kj_namechanger:sv:getPlayers', false)
    local playerSelect = lib.inputDialog('Choose Citizen 📋', {{type = 'number', label = 'Input Player ID', icon = 'filter'}})

    if not playerSelect or not playerSelect[1] then Notify('Name Changer', 'No Players Selected!', 'error') return end
    if not allPlayers[playerSelect[1]] then Notify('Name Changer', 'Player not found!', 'error') return end
    if playerSelect[1] == cache.serverId then Notify('Name Changer', 'Cannot choose yourself!', 'error') return end

    local name = lib.inputDialog('Change Name to:', {'First Name', 'Last Name'})
    if not name or name[1] == '' or name[2] == '' then Notify('Name Changer', 'Please enter both first and last names!', 'error') return end

    local dump = {
        playerSelect = playerSelect[1],
        name = name
    }

    TriggerServerEvent('kj_namechanger:sv:changeName', dump)
end

for k, v in pairs(Config.locations) do
    local point = lib.points.new({
        id = k,
        coords = v.coords,
        distance = 5,
        onEnter = function(self)
            lib.requestModel(v.pedModel)
            self.ped = CreatePed(v.pedModel, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, false, 0, 0)
            SetEntityAsMissionEntity(self.ped, true, true)
            SetEntityAlpha(self.ped, 150, false)
            SetRandomOutfitVariation(self.ped, true)
            SetEntityCanBeDamaged(self.ped, false)
            SetEntityInvincible(self.ped, true)
            FreezeEntityPosition(self.ped, true)
            SetBlockingOfNonTemporaryEvents(self.ped, true)
            SetPedCanBeTargetted(self.ped, false)
            for i = 0, 255, 51 do
                Wait(50)
                SetEntityAlpha(self.ped, i, false)
            end
            exports.ox_target:addModel(v.pedModel, {
                label = 'Change Name',
                distance = 3,
                icon = 'fa-solid fa-id-card',
                onSelect = function()
                    local plyJob = core.Functions.GetPlayerData().job.name
                    if plyJob ~= v.job then Notify('Name Changer', 'No job access!', 'error') return end
                    ChangeName()
                end
            })
        end,

        onExit = function(self)
            exports.ox_target:removeModel(v.pedModel)
            for i = 255, 0, -51 do
                Wait(50)
                SetEntityAlpha(self.ped, i, false)
            end
            DeletePed(self.ped)
        end,

        nearby = function()
            local function DrawText3D(x, y, z, text, r, g, b)
                local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
                if not onScreen then return end

                local factor = (string.len(text)) / 160

                SetTextScale(0.35, 0.35)
                SetTextFontForCurrentCommand(6)
                SetTextColor(255, 255, 255, 255) -- White
                SetTextCentre(1)

                DrawSprite("feeds", "toast_bg", _x, _y + 0.0150, (0.015 + factor), 0.032, 0.1, 0, 0, 0, 190, 0)
                DisplayText(CreateVarString(10, "LITERAL_STRING", text), _x, _y)
            end

            DrawText3D(v.coords.x, v.coords.y, v.coords.z + 1, v.label)
            DrawMarker(-1795314153, v.coords.x, v.coords.y, v.coords.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 255, 255, 255, 1.0, false, false, false, 1, false, false, false)
        end
    })
end

RegisterNetEvent('kj_namechanger:cl:notify', function(title, txt, type)
    Notify(title, txt, type)
end)