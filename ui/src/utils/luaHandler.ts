import { SendNUI } from "./SendNUI";
import { debugOutputStore, variablesLogStore, variablesStore, luaOutputStore, variablesHTMLStore } from "../store/stores";


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
            n.push(`<pre class="text-[red]">[${getDateTime()}][${eventType}]: ${output}</pre>`);
        } else {
            n.push(`<pre>[${getDateTime()}][${eventType}]: ${output}</pre>`);
        }
        return n = [...n]
    });
    // scrollToBottom(luaOutputElement);
}
function updateVariables(variables) {
    // variablesHTMLStore.set([]);
    variablesLogStore.update((n) => {
        if (variables.length == 0) return n = [...n];
        for (let i = 0; i < variables.length; i++) {
            let varName = variables[i].value.split(" ")[0];
            if (variables[i].global) {
                // if (n) {
                //     n = n.filter((item) => {item.name != varName});
                //     n = [...n];
                // }
                for (let i = 0; i < n.length; i++) {
                    if (n[i].name == varName) {
                        n.splice(i, 1);
                    }
                }
                // n.push({`${varName}` : `<p class="text-white"> ${variables[i].value} </p>`});
                n.push({
                    "name": varName,
                    "html": `<pre class="text-white"> ${variables[i].value} </pre>`});
                // n = [...n];
            }
        }
        n = [...n];
        // console.log('updateVarriable', n)
        return n
    });
}

function updateDebugOutput(code, eventType, source) {
    debugOutputStore.update((n) => {
        // console.log(code)
        let htmlString = `<pre>[${getDateTime()}][${eventType}${eventType == "source" ? `: ${source}` : ""}]: `;
        htmlString = htmlString + code
        htmlString = htmlString + ` </pre>`;
        n.push(htmlString);
        return n = [...n]
    });
}

window.addEventListener("message", (event) => {
    const item = event.data;
    // console.log(item)
    if (item.action === "updateOutput") {
        updateOutput(item.data.output, item.data.eventType, item.data.red);
    }
});


export class LuaHandler {
    
    ExecuteLua(lua: string, eventType: string, source: string) {
        let code = `(function() return (function() \n
            ${lua} \n
            end)() end)()`
        updateDebugOutput(lua, eventType, source);
        SendNUI("ExecuteLua", {code: code, eventType: eventType, source: source});
    }

    ExecuteQuickFunction(func: object, params: Array<any>, vars: object) {
        if (params.length == 0) {updateOutput(`${func.code} didn't have any parameters, skipping.`, 'INFO', true); return;}
        let code = "";
        if (vars.length > 0) {
            for (let i = 0; i < vars.length; i++) {
                if (vars[i].value.length > 0) {
                    if (vars[i].value.length > 0) {
                        let scope = vars[i].global ? `` : `local`;
                        code += `${scope} ${vars[i].value}\n`
                    }
                }
            }
        }
        code = code + 'return '
        code = code + func.code;
        code = code + `(`;
        for (let i = 0; i < params.length; i++) {
            code = code + params[i];
            if (i < params.length - 1) {
                code = code + `, `;
            }
        }
        code = code + `)`;
        updateDebugOutput(code, `Quick: ${func.server ? "Server" : "Client"}`, null);
        this.ExecuteLua(code, (func.server ? "server" : "client"), null);
        updateVariables(vars)
    }

    ResourceManage(resource: string, action: string) {
        SendNUI("ManageResource", {resource: resource, action: action});
        updateDebugOutput(`${action} ${resource}`, "Resource", null);
    }
}
