

function PlayAnim(animDict, animName, duration, flag)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 8.0, duration, flag, 0, false, false, false)
    RemoveAnimDict(animDict)
end