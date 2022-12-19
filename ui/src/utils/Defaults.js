export let QuickFunctionDefault = 
[
    {
        "code": "TriggerEvent",
        "name": "TriggerServerEvent",
        "server": true,
        "expectedParams": ['event', 'params'],
        "tags": ["server"],
        "params": [],
    },
    {
        "code": "TriggerEvent",
        "name": "TriggerClientEvent",
        "expectedParams": ['event', 'params'],
        "tags": ["client"],
        "params": [],
    },
    {
        "code": "PlayAnim",
        "expectedParams": ["dict", "anim", "flag", "duration"],
        "tags": ["client", "animation", "ped", "player"],
        "params": [],
    },
    
    {
        "code": "ClearPedTasks",
        "expectedParams": ['ped'],
        "tags": ["client", "animation", "ped", "player"],
        "params": [],
    },
    {
        "code": "ClearPedTasksImmediately",
        "expectedParams": ['ped'],
        "tags": ["client", "animation", "ped", "player"],
        "params": [],
    },
    {
        "code": "SetEntityCoords",
        "expectedParams": ['entity', 'x', 'y', 'z', 'alive', 'deadFlag', 'ragdollFlag', 'clearArea'],
        "tags": ["client", "entity", "ped", "player", "vehicle", "coords"],
        "params": [],
    },
    {
        "code": "SetEntityCoordsNoOffset",
        "expectedParams": ['entity', 'x', 'y', 'z', 'p4', 'p5', 'p6'],
        "tags": ["client", "entity", "ped", "player", "vehicle", "coords"],
        "params": [],
    },
    {
        "code": "SetEntityRotation",
        "expectedParams": ['entity', 'pitch', 'roll', 'yaw', 'rotationOrder', 'p5'],
        "tags": ["client", "entity", "ped", "player", "vehicle", "coords"],
        "params": [],
    },
    {
        "code": "SetEntityVisible",
        "expectedParams": ['entity', 'toggle'],
        "tags": ["client", "entity", "ped", "player", "vehicle"],
        "params": [],
    },
    {
        "code": "SetEntityHeading",
        "expectedParams": ['entity', 'heading'],
        "tags": ["client", "entity", "ped", "player", "vehicle", "heading"],
        "params": [],
    },
    {
        "code": "SetEntityInvincible",
        "expectedParams": ['entity', 'toggle'],
        "tags": ["client", "entity", "ped", "player", "vehicle"],
        "params": [],
    },
    {
        "code": "SetEntityCanBeDamaged",
        "expectedParams": ['entity', 'toggle'],
        "tags": ["client", "entity", "ped", "player", "vehicle"],
        "params": [],
    },
    {
        "code": "GetEntityCoords",
        "expectedParams": ['entity'],
        "tags": ["client", "entity", "ped", "player", "vehicle", "coords"],
        "params": [],
    },
    {
        "code": "GetEntityHeading",
        "expectedParams": ['entity'],
        "tags": ["client", "entity", "ped", "player", "vehicle", "heading"],
        "params": [],
    },
    {
        "code": "GetEntityRotation",
        "expectedParams": ['entity'],
        "tags": ["client", "entity", "ped", "player", "vehicle", "rotation", "heading"],
        "params": [],
    },
]



export let ConfigDefault = {
    "theme": "merbivore_soft",

}