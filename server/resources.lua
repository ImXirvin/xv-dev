function GetAllResources(src)
    -- print('getting Resources')
    local src = src
    local perms = CheckPerms(src)
    if not perms.manageRes and ConfigForXVDev.StrictMode then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        print('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager')
        return
    end
    local resources = {}
    local max = GetNumResources() - 1
    for i = 0, max do
        local resName = GetResourceByFindIndex(i)
        local resDesc = GetResourceMetadata(resName, 'description')

        if resDesc ~= nil then
            resDesc = nil
        end

        local currentRes = {
            name = resName,
            status = GetResourceState(resName),
            author = GetResourceMetadata(resName, 'author'),
            version = GetResourceMetadata(resName, 'version'),
            description = resDesc
        }
        table.insert(resources, currentRes)
    end
    Wait(200)
    return resources

end

RegisterNetEvent('xv-dev:server:updateResourceList', function(optionalSrc)
    -- print('updating Resources')
    local src = optionalSrc or source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    if not perms.manageRes and ConfigForXVDev.StrictMode then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        print('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager')
        return
    end
    local resources = GetAllResources(src)
    TriggerClientEvent('xv-dev:client:updateResourceList', src, resources)
    output = "Resources Updated"
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'server', red)
end)

RegisterNetEvent('xv-dev:server:manageResource', function(resource, action)
    -- print('managing Resources')
    local src = source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    if not perms.manageRes and ConfigForXVDev.StrictMode then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        print('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager')
        return
    end 
    if action == 'start' then
        StartResource(resource)
        if ConfigForXVDev.HookOnResourceEvents then
            SendHook('Resource Started', 'Player: ' .. GetPlayerName(src).. '\n' ..'Started resource: ' .. resource, 'green')
        end 
        output = 'Started resource: ' .. resource
        
    elseif action == 'stop' then
        StopResource(resource)
        if ConfigForXVDev.HookOnResourceEvents then
            SendHook('Resource Stopped', 'Player: ' .. GetPlayerName(src) .. '\n' .. 'Stopped resource: ' .. resource, 'red')
        end
        output = 'Stopped resource: ' .. resource
    elseif action == 'restart' then
        StopResource(resource)
        Wait(100)
        StartResource(resource)
        if ConfigForXVDev.HookOnResourceEvents then
            SendHook('Resource Restarted', 'Player: ' .. GetPlayerName(src).. '\n' ..'Restarted resource: ' .. resource, 'yellow')
        end
        output = 'Restarted resource: ' .. resource
    end
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'server', red)
    Wait(200)
    TriggerEvent('xv-dev:server:updateResourceList', src)
end)

local directory = nil
RegisterNetEvent('xv-dev:server:editResource', function(resName) --sends the client the resource files
    -- print('editing Resources')
    local src = source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    if not perms.manageRes and ConfigForXVDev.StrictMode or not perms.allowedEdit and ConfigForXVDev.StrictResEdit then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        print('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager')
        return
    end 
    local _res = LoadResourceFile(resName, "__resource.lua")
    local _fx = LoadResourceFile(resName, "fxmanifest.lua")
    local res = _res or _fx
    if res then
        local resource = scandir(GetResourcePath(resName))
        directory = GetResourcePath(resName)
        TriggerClientEvent('xv-dev:client:openEdit', src, resource)
        output = "Opened and Editting" .. resName
    else
        output = "Error: Resource not found (fxmanifest.lua or __resource.lua)"
        red = true
    end
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'server', red)
end)

RegisterNetEvent('xv-dev:server:saveResource', function(resource, route, content, autoRestart) --Saves the changes to the resource
    -- print('saving Resources')
    local src = source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    local originalResource = LoadResourceFile(resource, route)
    if not perms.manageRes and ConfigForXVDev.StrictMode or not perms.allowedEdit and ConfigForXVDev.StrictResEdit then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        print('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager')
        return
    end 
    if directory then 
        SaveResourceFile(resource, route, content, -1)
        if autoRestart then 
            StopResource(resource)
            StartResource(resource)
        end
        SendHook('Resource Edited', 'Player: ' .. GetPlayerName(src) .. '\n' ..'Edited resource: ' .. resource, 'yellow')
        print('Resource Edited', 'Player: ' .. GetPlayerName(src) .. '\n' ..'Edited resource: ' .. resource)
        output = "Saved " .. resource
    else
        output = "No directory found"
        red = true
    end
    if not directory then 
        TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'server', red)
        return
    end
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'server', red)
    
    if originalResource then 
        if string.find(route, '.lua') then 
            extension = '.lua'
        elseif string.find(route, '.js') then
            extension = '.js'
        elseif string.find(route, '.css') then
            extension = '.css'
        elseif string.find(route, '.html') then
            extension = '.html'
        elseif string.find(route, '.json') then
            extension = '.json'
        else
            extension = '.txt'
        end
        local date = os.date("%d-%m-%Y-%H-%M-%S")
        -- print(date)
        -- print(originalResource)
        local route = string.gsub(route, '/', '-')
        local path = '/backups/'..resource..route.."-backup-["..date..']'..extension..""
        SaveResourceFile(GetCurrentResourceName(), path, originalResource, -1)
        SendHook('Resource Backup', 'Player: ' .. GetPlayerName(src) .. '\n'..'Backed Up Resource: '.. resource..'\n'..'Path: '..path.."", 'yellow')
        print('Resource Backup', 'Player: ' .. GetPlayerName(src) .. '\n'..'Backed Up Resource: '.. resource..'\n'..'Path: '..path.."")
    end
end)

RegisterNetEvent('xv-dev:server:getData', function (resource, route) --Sends the file content to the client
    -- print('getting data')
    local src = source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    local extension = nil

    if not perms.manageRes and ConfigForXVDev.StrictMode or not perms.allowedEdit and ConfigForXVDev.StrictResEdit then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        print('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager')
        return
    end
    local loadedResource = LoadResourceFile(resource, route)
    if loadedResource then
        TriggerClientEvent('xv-dev:client:sendData', src, resource, route, loadedResource)
    end
end)