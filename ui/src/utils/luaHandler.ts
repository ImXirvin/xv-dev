import { SendNUI } from "./sendNui";
import { luaOutput, debug } from "../store/stores";
import { onMount, onDestroy } from "svelte";

let isDebug = false;
debug.subscribe((n) => (isDebug = n));



function getDateTime() {
    let date = new Date();
    let hour = date.getHours();
    let min = date.getMinutes();
    let sec = date.getSeconds();
    let time = hour + ":" + min + ":" + sec;
    return time;
}

function updateOutput(output, eventType) {
    luaOutput.update((n) => n + `[${getDateTime()}][${eventType}]: ${output}\n`);
    // scrollToBottom(luaOutputElement);
}

export function execLuaRaw(code: string, eventType: string) {
    let debugString = `Raw Lua: ${code}`;
    if (isDebug) {
        updateOutput(debugString, 'DEBUG');
    }

    SendNUI("ExecuteLua", {code: code, eventType: eventType, });
}

export function execQuickFunc(funcObject: any) {
    let code = ``
    code = funcObject.code;
    if (funcObject.params.length > 0) {
        code = code + `(`;
        for (let i = 0; i < funcObject.params.length; i++) {
            code = code + funcObject.params[i];
            if (i < funcObject.params.length - 1) {
                code = code + `, `;
            }
        }
        code = code + `)`;
    }
    let eventType: string = `client`;
    if (funcObject.server) {
        eventType = `server`;
    }
    execLuaRaw(code, eventType);
}

window.addEventListener("message", (event) => {
    const item = event.data;

    if (item.action === "updateOutput") {
        updateOutput(item.data.output, item.data.eventType);
    }
});
