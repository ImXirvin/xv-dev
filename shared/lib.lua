

function PlayAnim(animDict, animName, duration, flag)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 8.0, duration, flag, 0, false, false, false)
    RemoveAnimDict(animDict)
end


function PrintTable(input)

    print(json.encode(input, {indent = 2}))
end

function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..directory..'" /b /s /A-D /o:gn')
    for filename in pfile:lines() do
        i = i + 1
        directory2 = directory:gsub("//", "/")
        directory3 = directory2:gsub("]", "")
        directory4 = directory3:gsub("%[", "")
        filename2 = filename:gsub("\\", "/")
        filename3 = filename2:gsub("]","")
        filename4 = filename3:gsub("%[","")
        filename5 = filename4:gsub("-", "")
        real = filename5:gsub(directory4, "")
        t[i] = real
    end
    pfile:close()
    return t
end