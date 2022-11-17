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

RegisterNetEvent('xv-dev:server:verifyExec', function(code, eventType)
    local src = source
    --check ace perms for source
    local allowed = IsPlayerAceAllowed(src, 'command.dev')
    if not allowed then
        DropPlayer(src, 'Unauthorized access to dev menu')
        print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
        return
    end
    if code == nil then
        TriggerClientEvent('openDevMenu', src)
        return
    end
    if eventType == 'client' then
        TriggerClientEvent('xv-dev:client:ExecLua', src, code)
    elseif eventType == 'server' then
        TriggerEvent('xv-dev:server:ExecLua', src, code)
    end
end)



RegisterNetEvent('xv-dev:server:ExecLua', function(source, code)
    local src = source
    local func, err = load(code)
    if func then
        local status, result = pcall(func)
        if status then
            output = "Executed"
        else
            output = "Error: " .. (result or "Unknown")
        end
    else
        output = "Error: " .. err
    end
    TriggerClientEvent('xv-dev:client:UpdateOutput', src, output)
end)