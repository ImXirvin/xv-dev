import { SendNUI } from "./SendNUI";
import { debugOutputStore, variablesLogStore, luaOutputStore, variablesHTMLStore } from "../store/stores";


function getDateTime() {
    let date = new Date();
    let hour = date.getHours();
    let min = date.getMinutes();
    let sec = date.getSeconds();
    let time = hour + ":" + min + ":" + sec;
    return time;
}

function updateOutput(output, eventType, red) {
    //add a string to luaOutputStore array
    luaOutputStore.update((n) => {
        if (red) {
            n.push(`<p class="text-[red]">[${getDateTime()}][${eventType}]: ${output}</p>`);
        } else {
            n.push(`<p>[${getDateTime()}][${eventType}]: ${output}</p>`);
        }
        return n = [...n]
    });
    // scrollToBottom(luaOutputElement);
}

function updateVariables(variables: any) {
    variablesHTMLStore.set([]);
    variablesLogStore.update((n) => {
        if (variables.length == 0) return n = {...n};
        for (let i = 0; i < variables.length; i++) {
            let varName = variables[i].value.split(" ")[0];
            if (variables[i].global) {
                if (n[varName]) {
                    n[varName] = variables[i].value;
                } else {
                    n[varName] = variables[i].value;
                }
                variablesHTMLStore.update((m) => {
                    let newEntry = `<p class="text-white">${variables[i].value}</p>`;
                    m.push(newEntry);
                    return m = {...m}
                });
            }
        }
        return n = {...n}
    });
}

function updateDebugOutput(code, eventType, source) {
    debugOutputStore.update((n) => {
        console.log(code)
        n.push(`<p>[${getDateTime()}][${eventType}${eventType == "source" ? `: ${source}` : ""}]: ${code}</p>`);
        return n = [...n]
    });
}

window.addEventListener("message", (event) => {
    const item = event.data;

    if (item.action === "updateOutput") {
        updateOutput(item.data.output, item.data.eventType, item.data.red);
    }
});


export class LuaHandler {

    
    ExecuteLua(lua: string, eventType: string, source: string) {
        let code = `(function() ${lua} end)())`
        updateDebugOutput(code, eventType, source);
        SendNUI("ExecuteLua", {code: code, eventType: eventType, source: source});
    }

    ExecuteQuickFunction(func: object, params: Array<any>, vars: object) {
        if (params.length == 0) {updateOutput(`${func.code} didn't have any parameters, skipping.`, 'INFO', true); return;}
        let code = `(function()`;
        if (vars.length > 0) {
            for (let i = 0; i < vars.length; i++) {
                if (vars[i].value.length > 0) {
                    if (vars[i].value.length > 0) {
                        let scope = vars[i].global ? `` : `local`;
                        code += `${scope} ${vars[i].value}\n`
                    }
                }
            }
            updateVariables(vars);
        }
        code = code + func.code;
        code = code + `(`;
        for (let i = 0; i < params.length; i++) {
            code = code + params[i];
            if (i < params.length - 1) {
                code = code + `, `;
            }
        }
        code = code + `)`;
        code = code + `end)()`;
        updateDebugOutput(code, `Quick: ${func.server ? "Server" : "Client"}`, null);
        this.ExecuteLua(code, (func.server ? "server" : "client"), null);
    }

}
