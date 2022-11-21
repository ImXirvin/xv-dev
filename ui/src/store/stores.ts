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

