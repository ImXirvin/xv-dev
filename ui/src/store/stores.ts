import { writable } from "svelte/store";
import { QuickFunctionDefault } from "../utils/QuickFunctions";

export const visibility = writable(false);

export const outputMode = writable(false);
export const debugMode = writable(false);


//for theme
const selectedTheme = localStorage.theme;
export const theme = writable(selectedTheme || "merbivore_soft");
theme.subscribe((value) => localStorage.theme = value)

//for code
export const codeStore = writable( localStorage.getItem('code') || "");
codeStore.subscribe((value) => {
    localStorage.setItem('code', value);
})

//for variables
export const variablesStore = writable([]);

//for quick functions

export const quickFunctionsStore = writable( JSON.parse(localStorage.getItem('quickFunctions')) || QuickFunctionDefault);
quickFunctionsStore.subscribe((value) => {
    localStorage.setItem('quickFunctions', JSON.stringify(value));
})


export const paramListStore = writable([]);

