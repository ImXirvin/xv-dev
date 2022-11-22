import { SendNUI } from "./SendNui";
import { luaOutput, debug, execHistory, activeGlobalVariables } from "../store/stores";

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
    execHistory.update((n) => n + `[${getDateTime()}][${eventType}]: ${code}\n`);
    SendNUI("ExecuteLua", {code: code, eventType: eventType, });
}

export function execQuickFunc(funcObject: any, variables: any) {
    if (funcObject.params.length == 0) updateOutput(`${funcObject.code} didn't have any parameters, therefore skipping.`, 'INFO');
    let code = ``
    if (variables.length > 0) {
        for (let i = 0; i < variables.length; i++) {
            if (variables[i].value.length > 0) {
                let scope = variables[i].global ? `_G` : `local`;
                code += `${scope} ${variables[i].value}\n`
            }
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
