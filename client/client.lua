QBCore = nil
ESX = nil

CreateThread(function()
    --get resource state of qb-core
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
    --get resource state of esx
    if GetResourceState('es_extended') == 'started' then
        ESX = exports["es_extended"]:getSharedObject()
    end
end)

local initial = false

RegisterCommand('dev', function()
    if not initial then
        TriggerServerEvent('xv-dev:server:updateResourceList')
        initial = true
    end

    TriggerServerEvent('xv-dev:server:verifyExec')
end, false)

local inMenu = false
RegisterNetEvent('openDevMenu', function()
    local bool = not inMenu
    SendNUIMessage({
        action = "DevMenu",
        data = {
            show = bool,
        }
    })
    SetNuiFocus(bool , bool)
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

RegisterNetEvent('xv-dev:client:updateOutput', function(output, eventType, red)
    SendNUIMessage({
        action = "updateOutput",
        data = {
            output = output,
            eventType = eventType,
            red = red,
        }
    })
end)

RegisterNetEvent('xv-dev:client:ExecLua', function(code)
    local func, err = load('return ' .. code, '@xv-dev')
    local red = false
    local output = ""
    if func then
        local status, result = pcall(func, '@xv-dev')
        if status then
            output = tostring(result or "Executed")
            red = false
        else
            output = "Error: " .. (result or "Unknown")
        end
    else
        output = "Error: " .. err
        red = true
    end
    TriggerEvent('xv-dev:client:updateOutput', output, 'client', red)
end)

RegisterNUICallback('ExecuteLua', function(data, cb)
    local code = data.code
    local eventType = data.eventType
    local selectedSrc = data.source
    TriggerServerEvent('xv-dev:server:verifyExec', code, eventType, selectedSrc)
    cb(1)
end)


--ResouceManager    

RegisterNUICallback('UpdateResourceList', function(data, cb)
    TriggerServerEvent('xv-dev:server:updateResourceList')
    cb(1)
end)

RegisterNetEvent('xv-dev:client:updateResourceList', function(resources)
    SendNUIMessage({
        action = "updateResourceList",
        data = {
            resources = resources,
        }
    })
end)

RegisterNUICallback('ManageResource', function(data, cb)
    local action = data.action
    local resource = data.resource
    TriggerServerEvent('xv-dev:server:manageResource', resource, action)
    cb(1)
end)

RegisterNUICallback('SaveResource', function(data, cb) --Saves the edited file to the new resource
    local resource = data.resource
    local route = data.route
    local content = data.content
    local autoRestart = data.autoRestart
    TriggerServerEvent('xv-dev:server:saveResource', resource, route, content, autoRestart)
    cb(1)
end)

RegisterNUICallback('clickEdit', function(data, cb)
    local resource = data.resource
    TriggerServerEvent('xv-dev:server:editResource', resource)
    cb(1)
end)

RegisterNetEvent('xv-dev:client:sendData', function(resource, route, data) --Sends the data of the file to the UI
    -- print(resource, route, data, 'sendData')
    SendNUIMessage({
        action = "LoadData",
        data = {
            resource = resource,
            route = route,
            data = data,
        }
    })
end)

RegisterNetEvent('xv-dev:client:openEdit', function(resourceFiles) --Sends the files list for the resource to the UI
    SendNUIMessage({
        action = 'LoadFiles',
        data = {
            resourceFiles = resourceFiles,
        },
    })
end)


RegisterNUICallback('getFileData', function(data, cb) --Gets the data of the file
    local resource = data.resource
    local route = data.route
    -- print(resource, route)
    TriggerServerEvent('xv-dev:server:getData', resource, route)
    cb(1)
end)
