import { writable } from "svelte/store";

export const visibility = writable(false);
export const debugMode = writable(false);


const selectedTheme = localStorage.theme;
export const theme = writable(selectedTheme || "merbivore_soft");

theme.subscribe((value) => localStorage.theme = value)