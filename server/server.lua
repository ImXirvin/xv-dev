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
    local perms = {}
    perms.allowed = IsPlayerAceAllowed(src, 'command.dev')

    if not perms.allowed then
        -- print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
        SendHook('Unauthorized access to dev menu', 'Player: ' .. GetPlayerName(src) .. ' tried to access the dev menu', 'red')
        DropPlayer(src, 'Unauthorized access to dev menu')
        return
    end

    if ConfigForXVDev.StrictMode then
        local identifierTable = GetPlayerIdentifiers(src)
        for k, v in pairs(ConfigForXVDev.Identifiers) do
            if v.licenses then
                for i, j in pairs(v.licenses) do
                    for x, y in pairs(identifierTable) do
                        if j == y then
                            if v.client then
                                perms.client = true
                            end
                            if v.server then
                                perms.server = true
                            end
                            if v.remote then
                                perms.remote = true
                            end
                            if v.manageRes then
                                perms.manageRes = true
                            end
                        end
                    end
                end
            end
        end
    end

    if ConfigForXVDev.StrictResEdit then
        local identifierTable = GetPlayerIdentifiers(src)
        for k, v in pairs(ConfigForXVDev.Identifiers) do
            if v.licenses then
                for i, j in pairs(v.licenses) do
                    for x, y in pairs(identifierTable) do
                        if j == y then
                            if v.manageRes then
                                perms.manageRes = true
                                perms.allowedEdit = true
                            end
                        end
                    end
                end
            end
        end
    end

    return perms
end

RegisterNetEvent('xv-dev:server:verifyExec', function(code, eventType, selectedSrc)
    local src = source
    -- local selectedSrc = nil
    local srcTable = {}
    --turn selectedSrc into a number or table of numbers
    if eventType == 'client' then
        selectedSrc = source
    elseif eventType == 'source' then
        local tempSrc = selectedSrc
        -- seperate tempSrc by comma

        for i in string.gmatch(tempSrc, '([^,]+)') do
            table.insert(srcTable, tonumber(i))
        end
    end

    local perms = CheckPerms(src)
    if not perms.allowed then
        return
    end
    if code == nil then
        TriggerClientEvent('openDevMenu', src)
        return
    end
    if eventType == 'client' then
        if not perms.client and ConfigForXVDev.StrictMode then
            TriggerClientEvent('chatMessage', src, 'Dev Menu', {255, 0, 0}, 'You are not allowed to execute client side code')
            -- print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
            SendHook('Unauthorized Client execution using Dev Menu', 'Player: ' .. GetPlayerName(src) .. ' tried to execute client side code', 'red')
            return
        end
        TriggerClientEvent('xv-dev:client:ExecLua', src, code)
    elseif eventType == 'server' then
        if not perms.server and ConfigForXVDev.StrictMode then
            TriggerClientEvent('chatMessage', src, 'Dev Menu', {255, 0, 0}, 'You are not allowed to execute server side code')
            -- print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
            SendHook('Unauthorized Sever execution using Dev Menu', 'Player: ' .. GetPlayerName(src) .. ' tried to execute server side code', 'red')
            return
        end
        TriggerEvent('xv-dev:server:ExecLua', src, code)
    elseif eventType =='both' then
        if not perms.client and not perms.server and ConfigForXVDev.StrictMode then
            TriggerClientEvent('chatMessage', src, 'Dev Menu', {255, 0, 0}, 'You are not allowed to execute client side code')
            -- print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
            SendHook('Unauthorized Client or Server execution using Dev Menu', 'Player: ' .. GetPlayerName(src) .. ' tried to execute client and server side code', 'red')
            return
        end
        TriggerClientEvent('xv-dev:client:ExecLua', src, code)
        TriggerEvent('xv-dev:server:ExecLua', src, code)
    elseif eventType == 'source' then
        if not perms.remote and ConfigForXVDev.StrictMode then
            TriggerClientEvent('chatMessage', src, 'Dev Menu', {255, 0, 0}, 'You are not allowed to execute server side code')
            SendHook('Unauthorized Client execution using Dev Menu', 'Player: ' .. GetPlayerName(src) .. ' tried to execute remote Sources ('.. json.encode(srcTable) .. ') side code', 'red')
            return
        end
        for k, v in pairs(srcTable) do
            TriggerClientEvent('xv-dev:client:ExecLua', v, code)
        end
    end
    TriggerEvent('xv-dev:server:updateResourceList', src)
end)



RegisterNetEvent('xv-dev:server:ExecLua', function(source, code)
    local src = source
    local perms = CheckPerms(src)
    if not perms.server and ConfigForXVDev.StrictMode then
        TriggerClientEvent('chatMessage', src, 'Dev Menu', {255, 0, 0}, 'You are not allowed to execute server side code')
        SendHook('Unauthorized Sever execution using Dev Menu', 'Player: ' .. GetPlayerName(src) .. ' tried to execute server side code', 'red')
        return
    end
    local red = false
    local output = ""
    local func, err = load('return ' .. code, '@xv-dev')
    if func then
        local status, result = pcall(func, '@xv-dev')
        if status then
            output = tostring(result or "Executed")
            red = false
        else
            output = "Error: " .. (result or "Unknown")
            red = true
        end
    else
        output = "Error: " .. err
        red = true
    end
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'server', red)
end)




function SendHook(title, message, color)
    if not ConfigForXVDev.Webhook then
        print('No webhook set in config')
        --send a chat message saying no webhook set
        TriggerEvent('chatMessage', 'Dev Menu', {255, 0, 0}, 'No webhook set in config')
        return
    end
    local embedData = {
        {
            ["title"] = title,
            ["color"] = ConfigForXVDev.Colors[color] or ConfigForXVDev.Colors['red'],
            ["footer"] = {
                ["text"] = os.date("%c"),
            },
            ["description"] = message,
        }
    }
    PerformHttpRequest(ConfigForXVDev.Webhook, function(err, text, headers) end, 'POST', json.encode({username = ConfigForXVDev.HookName,embeds = embedData, avatar_url = ConfigForXVDev.HookAvatar }), { ['Content-Type'] = 'application/json' })
end

--RESOURCE MANAGER

function GetAllResources(src)
    local src = src
    local perms = CheckPerms(src)
    if not perms.manageRes and ConfigForXVDev.StrictMode then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        return
    end
    local resources = {}
    local max = GetNumResources() - 1
    for i = 0, max do
        local resName = GetResourceByFindIndex(i)
        local resDesc = GetResourceMetadata(resName, 'description')

        if resDesc ~= nil and string.find(resDesc, "Louis.dll") then
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
    local src = optionalSrc or source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    if not perms.manageRes and ConfigForXVDev.StrictMode then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        return
    end
    local resources = GetAllResources(src)
    TriggerClientEvent('xv-dev:client:updateResourceList', src, resources)
    output = "Resources Updated"
    TriggerClientEvent('xv-dev:client:updateOutput', src, output, 'server', red)
end)

RegisterNetEvent('xv-dev:server:manageResource', function(resource, action)
    local src = source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    if not perms.manageRes and ConfigForXVDev.StrictMode then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
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
    local src = source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    if not perms.manageRes and ConfigForXVDev.StrictMode or not perms.allowedEdit and ConfigForXVDev.StrictResEdit then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
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
    local src = source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    local originalResource = LoadResourceFile(resource, route)
    if not perms.manageRes and ConfigForXVDev.StrictMode or not perms.allowedEdit and ConfigForXVDev.StrictResEdit then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        return
    end 
    if directory then 
        SaveResourceFile(resource, route, content, -1)
        if autoRestart then 
            StopResource(resource)
            StartResource(resource)
        end
        SendHook('Resource Edited', 'Player: ' .. GetPlayerName(src) .. '\n' ..'Edited resource: ' .. resource, 'yellow')
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
    end
end)

RegisterNetEvent('xv-dev:server:getData', function (resource, route) --Sends the file content to the client
    local src = source
    local perms = CheckPerms(src)
    local red = false
    local output = ""
    local extension = nil

    if not perms.manageRes and ConfigForXVDev.StrictMode or not perms.allowedEdit and ConfigForXVDev.StrictResEdit then 
        SendHook('Unauthorized Resource Manager Access', 'Player: ' .. GetPlayerName(src) .. ' tried to access the resource manager', 'red')
        return
    end
    local loadedResource = LoadResourceFile(resource, route)
    if loadedResource then
        TriggerClientEvent('xv-dev:client:sendData', src, resource, route, loadedResource)
    end
end)
