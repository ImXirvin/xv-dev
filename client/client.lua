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



RegisterCommand('dev', function()
    TriggerServerEvent('xv-dev:server:verifyExec')
end, false)


RegisterNetEvent('openDevMenu', function()
    SendNUIMessage({
        action = "DevMenu",
        data = {
            show = true,
        }
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('hideUI', function(data, cb)
    SendNUIMessage({
        action = "DevMenu",
        data = {
            show = false,
        }
    })
    SetNuiFocus(false, false)
end)

RegisterNetEvent('xv-dev:client:UpdateOutput', function(output, eventType)
    SendNUIMessage({
        action = "updateOutput",
        data = {
            output = output,
            eventType = eventType
        }
    })
end)

RegisterNetEvent('xv-dev:client:ExecLua', function(code)
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
    TriggerEvent('xv-dev:client:UpdateOutput', output, 'client')
end)

RegisterNUICallback('ExecuteLua', function(data, cb)
    local code = data.code
    local eventType = data.eventType
    TriggerServerEvent('xv-dev:server:verifyExec', code, eventType)
    cb(1)
end)
