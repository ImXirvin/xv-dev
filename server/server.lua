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