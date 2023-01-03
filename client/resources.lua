RegisterNUICallback('UpdateResourceList', function(data, cb)
    -- print('Updating Resource List')
    TriggerServerEvent('xv-dev:server:updateResourceList')
    cb(1)
end)

RegisterNetEvent('xv-dev:client:updateResourceList', function(resources)
    -- print('Updating Resource List Event')
    SendNUIMessage({
        action = "updateResourceList",
        data = {
            resources = resources,
        }
    })
end)

RegisterNUICallback('ManageResource', function(data, cb)
    -- print('Managing Resource')
    local action = data.action
    local resource = data.resource
    TriggerServerEvent('xv-dev:server:manageResource', resource, action)
    cb(1)
end)

RegisterNUICallback('SaveResource', function(data, cb) --Saves the edited file to the new resource
    -- print('Save Resource')
    local resource = data.resource
    local route = data.route
    local content = data.content
    local autoRestart = data.autoRestart
    TriggerServerEvent('xv-dev:server:saveResource', resource, route, content, autoRestart)
    cb(1)
end)

RegisterNUICallback('clickEdit', function(data, cb)
    -- print('Click Edit')
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
    -- print('openEdit')
    SendNUIMessage({
        action = 'LoadFiles',
        data = {
            resourceFiles = resourceFiles,
        },
    })
end)


RegisterNUICallback('getFileData', function(data, cb) --Gets the data of the file
    -- print('getFileData')
    local resource = data.resource
    local route = data.route
    -- print(resource, route)
    TriggerServerEvent('xv-dev:server:getData', resource, route)
    cb(1)
end)