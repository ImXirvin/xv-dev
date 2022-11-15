local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('dev', function()
    SendNUIMessage({
        action = "DevMenu",
        data = {
            show = true,
        }
    })
    SetNuiFocus(true, true)
end, false)

RegisterNUICallback('hideUI', function(data, cb)
    SendNUIMessage({
        action = "DevMenu",
        data = {
            show = false,
        }
    })
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ExecuteLua', function(data, cb)
    local code = data.code
    local func, err = load(code)
    if func then
        local status, result = pcall(func)
        if not status then
            print(result)
            cb({status = false, result = result})
        end
    else
        print(err)
        cb(err)
    end
end)

RegisterNetEvent('xirvin-test', function()
    print('test')
end)