local isOpen = false

RegisterCommand('xv-dev:toggleMenu', function()
    isOpen = not isOpen
    SendNUIMessage({
        action = "DevMenu",
        data = {
            show = isOpen,
        }
    })
    SetNuiFocus(isOpen, isOpen)
end, 'admin')

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
    local eventType = data.eventType
    if eventType == 'client' then
        local func, err = load(code)
        if func then
            local status, result = pcall(func)
            if not status then
                print(result)
            end
        else
            print(err)
        end
    elseif eventType == 'server' then
        --Create a callback for the server event
    end
end)


RegisterNetEvent('xirvin-test', function()
    print('test')
end)