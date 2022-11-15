

local function catch(what)
    return what[1]
end
 
 local function try(what)
    status, result = pcall(what[1])
    if not status then
       what[2](result)
    end
    return result
end


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
            print('worked')
            cb({status = false, result = result})
        end
    else
        print(err)
        cb(err)
    end
end)