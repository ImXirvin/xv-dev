QBCore = nil
ESX = nil

CreateThread(function()
    --get resource state of qb-core
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
    --get resource state of esx
    if GetResourceState('es_extended') == 'started' then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)


local function CheckPerms(source)
    local src = source
    local allowedServer = false
    local allowedClient = false
    local allowed = IsPlayerAceAllowed(src, 'command.dev')

    if not allowed then
        DropPlayer(src, 'Unauthorized access to dev menu')
        print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
        return
    end

    if Config.StrictMode then
        local identifierTable = GetPlayerIdentifiers(src)
        for k, v in pairs(Config.Identifiers) do
            if v.licenses then
                for i, j in pairs(v.licenses) do
                    for x, y in pairs(identifierTable) do
                        if j == y then
                            if v.client then
                                if eventType == "client" then
                                    allowedClient = true
                                end
                            end
                            if v.server then
                                if eventType == "server" then
                                    allowedServer = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return allowed, allowedClient, allowedServer
end

RegisterNetEvent('xv-dev:server:verifyExec', function(code, eventType)
    local src = source
    local allowed, allowedClient, allowedServer = CheckPerms(src)
    if code == nil then
        TriggerClientEvent('openDevMenu', src)
        return
    end
    if eventType == 'client' then
        if not allowedClient and Config.StrictMode then
            TriggerClientEvent('chatMessage', src, 'Dev Menu', {255, 0, 0}, 'You are not allowed to execute client side code')
            print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
            return
        end
        TriggerClientEvent('xv-dev:client:ExecLua', src, code)
    elseif eventType == 'server' then
        if not allowedServer and Config.StrictMode then
            TriggerClientEvent('chatMessage', src, 'Dev Menu', {255, 0, 0}, 'You are not allowed to execute server side code')
            print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
            return
        end
        TriggerEvent('xv-dev:server:ExecLua', src, code)
    end
end)



RegisterNetEvent('xv-dev:server:ExecLua', function(source, code)
    local src = source
    local allowed, allowedClient, allowedServer = CheckPerms(src)
    if not allowedServer and Config.StrictMode then
        TriggerClientEvent('chatMessage', src, 'Dev Menu', {255, 0, 0}, 'You are not allowed to execute server side code')
        print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
        return
    end
    local red = false
    local output = ""
    local func, err = load(code)
    if func then
        local status, result = pcall(func)
        if status then
            output = "Executed"
            red = false
        else
            output = "Error: " .. (result or "Unknown")
            red = true
        end
    else
        output = "Error: " .. err
        red = true
    end
    TriggerClientEvent('xv-dev:client:UpdateOutput', src, output, 'server', red)
end)