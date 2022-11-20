import { writable } from "svelte/store";

export const visibility = writable(false);

export const luaOutput = writable(`` || sessionStorage.getItem(`luaOutput`));

luaOutput.subscribe((n) => sessionStorage.setItem(`luaOutput`, n));

export const debug = writable<boolean>(false || localStorage.getItem(`debug`) === `true`);

debug.subscribe((value) => localStorage.enabled = String(value))

export const execHistory = writable<string[]>([] || JSON.parse(localStorage.getItem(`execHistory`)));

execHistory.subscribe((n) => localStorage.setItem(`execHistory`, JSON.stringify(n)));

export const activeGlobalVariables = writable<string[]>([] || JSON.parse(sessionStorage.getItem(`activeGlobalVariables`)));

