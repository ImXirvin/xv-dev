

local playerFunctions = {
    tpToPlayer = function(src, data)
        TriggerClientEvent('xv-dev:client:teleport', src, data)
    end,
    tpToMe = function(src, data)
        local id = data.id
        data.id = src
        data.action = 'tpToPlayer'
        TriggerClientEvent('xv-dev:client:teleport', id, data)
    end,
    tpToCoords = function(src, data)
        -- print(json.encode(data))
        local id = data.id
        local coords = '['..data.coords..']'
        --turn the coords string into a table
        coords = json.decode(coords)
        coords = vector3(coords[1], coords[2], coords[3])
        print(coords)
        TriggerClientEvent('xv-dev:client:teleport', id, data)
    end,
    spawnVehicleForPlayer = function(src, data)
        local targetId = data.id
        local vehicle = data.vehicle
        TriggerClientEvent('xv-dev:client:spawnVehicle', targetId, vehicle)
    end,
    deleteVehiclePlayer = function(src, data)
        local targetId = data.id
        TriggerClientEvent('xv-dev:client:deleteVehicle', targetId)
    end,
    freezePlayer = function(src, data)
        local targetId = data.id
        TriggerClientEvent('xv-dev:client:freezePlayer', targetId, true)
    end,
    unfreezePlayer = function(src, data)
        local targetId = data.id
        TriggerClientEvent('xv-dev:client:freezePlayer', targetId, false)
    end,
}

RegisterNetEvent('xv-dev:server:playerAction', function(data)
    local src = source
    local action = data.action
    local id = data.id
    local perms = CheckPerms(src)

    if not perms.allowed then
        SendHook('Unauthorized access to dev menu', 'Player: ' .. GetPlayerName(src) .. ' tried to access the dev menu', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end
    if not  perms.managePly and ConfigForXVDev.StrictMode then
        SendHook('Unauthorized access to Player Tab', 'Player: ' .. GetPlayerName(src) .. ' tried to manage a player ('..GetPlayerName(id)..')', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end
    playerFunctions[action](src, data)
    local red = false
    local output = 'Player: ' .. GetPlayerName(id) .. ' has been ' .. action .. ' by ' .. GetPlayerName(src)
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'Player', red)
end)

--I tried to make a callback but i dont know how to rip
RegisterNetEvent('xv-dev:server:identifierCallback', function(id)
    local src = source
    local perms = CheckPerms(src)
    if not perms.allowed then
        SendHook('Unauthorized access to dev menu', 'Player: ' .. GetPlayerName(src) .. ' tried to access the dev menu', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end
    if not perms.managePly and ConfigForXVDev.StrictMode then
        SendHook('Unauthorized access to Player Tab', 'Player: ' .. GetPlayerName(src) .. ' tried to manage a player ('..GetPlayerName(id)..')', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end
    local identifiers = GetPlayerIdentifiers(id)
    TriggerClientEvent('xv-dev:client:identifierCallback', src, identifiers)
end)

RegisterNetEvent('xv-dev:server:kickPlayer', function(targetID, reason)
    local src = source
    local id = targetID
    local reason = reason
    local perms = CheckPerms(src)
    if not perms.allowed then
        SendHook('Unauthorized access to dev menu', 'Player: ' .. GetPlayerName(src) .. ' tried to access the dev menu', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end
    if not perms.managePly and ConfigForXVDev.StrictMode then
        SendHook('Unauthorized access to Player Tab', 'Player: ' .. GetPlayerName(src) .. ' tried to kick a player ('..GetPlayerName(id)..')', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end
    DropPlayer(id, reason .. ' - ' .. GetPlayerName(src))
    local red = false
    local output = 'Player: ' .. GetPlayerName(id) .. ' has been kicked by ' .. GetPlayerName(src) .. ' for ' .. reason
    SendHook('Player Kicked', output, 'red')
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'Player', red)
end)

RegisterNetEvent('xv-dev:server:banPlayer', function(targetID, reason)
    local src = source
    local id = targetID
    local reason = reason
    local perms = CheckPerms(src)
    if not perms.allowed then
        SendHook('Unauthorized access to dev menu', 'Player: ' .. GetPlayerName(src) .. ' tried to access the dev menu', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end
    if not perms.managePly and ConfigForXVDev.StrictMode then
        SendHook('Unauthorized access to Player Tab', 'Player: ' .. GetPlayerName(src) .. ' tried to ban a player ('..GetPlayerName(id)..')', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end

    local output = 'Player: ' .. player .. ' has been banned by ' .. GetPlayerName(src) .. ' for ' .. reason
    SendHook('Player Banned', output, 'red')
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'Player', red)
    DropPlayer(id, reason)

    --SET YOUR OWN BAN SYSTEM HERE
end)