local players = {}
local inspectPlayer = false
local targetID = nil

local function updatePlayerList()
    players = {}
    local activePlayers = GetActivePlayers()
    local playerCount = #activePlayers
    for i = 1, playerCount do
        local id = GetPlayerServerId(activePlayers[i])
        local name = GetPlayerName(activePlayers[i])
        print(id, name)
        players[#players + 1] = {id = id, name = name}
    end
end

RegisterNetEvent('xv:client:updatePlayerList', function()
    updatePlayerList()
    SendNUIMessage({
        action = "UpdatePlayerList",
        data = {
            players = players
        }
    })
end)

RegisterNUICallback('GetPlayers', function(data, cb)
    TriggerEvent('xv:client:updatePlayerList')
    cb(1)
end)

local function RetrievePlyInfo(id)
    local id = id
    local player = GetPlayerFromServerId(id)
    local identifiers = nil
    TriggerServerEvent('xv-dev:server:identifierCallback', id)
    RegisterNetEvent('xv-dev:client:identifierCallback', function(data)
        identifiers = data
    end)
    while identifiers == nil do
        Wait(0)
    end
    print(json.encode(identifiers))
    local initial = false
    CreateThread(function()
        local name = GetPlayerName(player)
        while targetID == id do
            local ped = GetPlayerPed(player)
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local health = GetEntityHealth(ped)
            local armour = GetPedArmour(ped)
            local model = GetLabelText(GetHashKey(GetEntityModel(ped)))
            local inVehicle = IsPedInAnyVehicle(ped, false)
            local vehicle = nil
            local vehicleName = nil
            if inVehicle then
                vehicle = GetVehiclePedIsIn(ped, false)
                vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            end
            local data = {
                id = id,
                name = name,
                coords = coords,
                heading = heading,
                health = health,
                armour = armour,
                model = model,
                inVehicle = inVehicle,
                vehicleName = vehicleName,
                identifiers = identifiers,
            } --Ceebs splitting permanent data from dynamic data
            SendNUIMessage({
                action = "updatePlayerData",
                data = data
            })
            Wait(1000)
        end
    end)


end


RegisterNUICallback('startGetPlayerData', function(data, cb)
    local id = data.id
    targetID = id
    inspectPlayer = true
    RetrievePlyInfo(id)
    cb(1)
end)

RegisterNUICallback('stopGetPlayerData', function(data, cb)
    targetID = nil
    cb(1)
end)

RegisterNUICallback('playerAction', function(data, cb)
    TriggerServerEvent('xv-dev:server:playerAction', data)
    cb(1)
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    local id = data.id
    local reason = data.reason
    TriggerServerEvent('xv-dev:server:kickPlayer', id, reason)
    cb(1)
end)

RegisterNUICallback('banPlayer', function(data, cb)
    local id = data.id
    local reason = data.reason
    TriggerServerEvent('xv-dev:server:banPlayer', id, reason)
    cb(1)
end)


------------------------------------------------------------

RegisterNetEvent('xv-dev:client:teleport', function(data)
    local ped = PlayerPedId()
    local action = data.action
    if action == "tpToPlayer" then
        local id = data.id
        local player = GetPlayerFromServerId(id)
        local coords = GetEntityCoords(GetPlayerPed(player))
        SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
    elseif action == "tpToCoords" then
        local coords = data.coords
        local coords = '['..data.coords..']'
        coords = json.decode(coords)
        coords = vector3(coords[1], coords[2], coords[3])
        SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
    end
end)

RegisterNetEvent('xv-dev:client:spawnVehicle', function(model)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local vehicle = CreateVehicle(GetHashKey(model), coords.x, coords.y, coords.z, heading, true, false)
    SetPedIntoVehicle(ped, vehicle, -1)
end)

RegisterNetEvent('xv-dev:client:deleteVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    DeleteVehicle(vehicle)
end)

RegisterNetEvent('xv-dev:client:freezePlayer', function(bool)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, bool)
end)
