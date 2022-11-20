import { SendNUI } from "./sendNui";
import { luaOutput, debug, execHistory, activeGlobalVariables } from "../store/stores";
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
    updateExecHistory(code, eventType);
    SendNUI("ExecuteLua", {code: code, eventType: eventType, });
}

export function execQuickFunc(funcObject: any, variables: any) {
    let code = ``
    if (variables.length > 0) {
        for (let i = 0; i < variables.length; i++) {
            let scope = variables[i].global ? `_G` : `local`;
            code += `${scope} ${variables[i].value}\n`
        }
        updateVariables(variables);
    }

    code = code + funcObject.code;
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


function updateExecHistory(code: string, eventType: string) {
    let codeLine: string = `[${getDateTime()}][${eventType}]: ${code}`
    execHistory.update((n) => {
        if (n.includes(codeLine)) {
            n.splice(n.indexOf(codeLine), 1);
        }
        n.unshift(codeLine);
        if (n.length > 10) {
            n.pop();
        }
        console.log(n)
        return n;
    });
}

function updateVariables(variables: any) {
    activeGlobalVariables.update((n) => {
        for (let i = 0; i < variables.length; i++) {
            if (variables[i].global) {
                if (!n.includes(variables[i].value)) {
                    n.push(variables[i].value);
                }
            }
        }
        return n;
    });
}
