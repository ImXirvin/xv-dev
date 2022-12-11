import { SendNUI  } from "./SendNUI";

export class LuaHandler {

    ExecuteLua(code: string, eventType: string, source: string) {
        SendNUI("ExecuteLua", {code: code, eventType: eventType, source: source});
    }

    ExecuteQuickFunction(func: object, params: Array, vars: object) {

    }

}
