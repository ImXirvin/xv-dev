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
const savedCode = localStorage.code;
export const codeStore = writable(savedCode || "");
codeStore.subscribe((value) => localStorage.code = value)

//for variables
const savedVariables = localStorage.variables;
export const variablesStore = writable(savedVariables || []);
variablesStore.subscribe((value) => sessionStorage.variables = value)

//for quick functions
const savedQuickFunctions = localStorage.quickFunctions;
export const quickFunctionsStore = writable(savedQuickFunctions || QuickFunctionDefault);
quickFunctionsStore.subscribe((value) => localStorage.quickFunctions = value)