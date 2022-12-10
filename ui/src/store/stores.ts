import { writable } from "svelte/store";

export const visibility = writable(false);
export const debugMode = writable(false);


//for theme
const selectedTheme = localStorage.theme;
export const theme = writable(selectedTheme || "merbivore_soft");
theme.subscribe((value) => localStorage.theme = value)

//for code
const savedCode = localStorage.code;
export const codeStore = writable(savedCode || "");
codeStore.subscribe((value) => localStorage.code = value)

//for variables
const savedVariables = localStorage.variables;
export const variablesStore = writable(savedVariables || "");
variablesStore.subscribe((value) => sessionStorage.variables = value)
