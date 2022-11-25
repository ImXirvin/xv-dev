import type { variables, quickFuncs } from "src/@types";
import { writable } from "svelte/store";

export const visibility = writable(false);

sessionStorage.setItem("luaOutput", "");
export const luaOutput = writable(`` || sessionStorage.getItem(`luaOutput`));
luaOutput.subscribe((n) => sessionStorage.setItem(`luaOutput`, n));



export const debug = writable<boolean>(false || localStorage.getItem(`debug`) === `true`);


debug.subscribe((value) => localStorage.enabled = String(value))

sessionStorage.setItem("execHistory", "");
export const execHistory = writable(`` || sessionStorage.getItem(`execHistory`));
execHistory.subscribe((n) => sessionStorage.setItem(`execHistory`, n));

export const activeGlobalVariables = writable<string[]>([] || JSON.parse(sessionStorage.getItem(`activeGlobalVariables`)));

export const activeVariables = writable<variables[]>([]);




let quickFunc: Partial<quickFuncs>[] = [
    {
        code: "TriggerEvent",
        name: "TriggerServerEvent",
        server: true,
        params: [],
        expectedParams: ['event', 'params'],
    },
    {
        code: "TriggerClientEvent",
        params: [],
        server: true,
        expectedParams: ['event', 'params'],
    },
    {
        code: "PlayAnim",
        params: [],
        expectedParams: ["dict", "anim", "flag", "duration"],
    },
    {
        code: "ClearPedTasks",
        params: [],
        expectedParams: ['ped'],
    },
    {
        code: "ClearPedTasksImmediately",
        params: [],
        expectedParams: ['ped'],
    },
    {
        code: "SetEntityCoords",
        params: [],
        expectedParams: ['entity', 'x', 'y', 'z', 'alive', 'deadFlag', 'ragdollFlag', 'clearArea'],
    },
    {
        code: "SetEntityCoordsNoOffset",
        params: [],
        expectedParams: ['entity', 'x', 'y', 'z', 'p4', 'p5', 'p6'],
    },
    {
        code: "SetEntityRotation",
        params: [],
        expectedParams: ['entity', 'pitch', 'roll', 'yaw', 'rotationOrder', 'p5'],
    },
    {
        code: "SetEntityVisible",
        params: [],
        expectedParams: ['entity', 'toggle'],
    },
    {
        code: "SetEntityHeading",
        params: [],
        expectedParams: ['entity', 'heading'],
    },
    {
        code: "SetEntityInvincible",
        params: [],
        expectedParams: ['entity', 'toggle'],
    },
    {
        code: "SetEntityCanBeDamaged",
        params: [],
        expectedParams: ['entity', 'toggle'],
    },
    {
        code: "GetEntityCoords",
        params: [],
        expectedParams: ['entity'],
    },
    {
        code: "GetEntityHeading",
        params: [],
        expectedParams: ['entity'],
    },
    {
        code: "GetEntityRotation",
        params: [],
        expectedParams: ['entity'],
    },
]

export const quickFunctions = writable<Partial<quickFuncs>[]>(quickFunc);

export const luaCode = writable<string>(``);