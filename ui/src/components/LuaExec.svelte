<script lang="ts">
    import { SendNUI } from "../utils/sendNui";
    import { visibility } from "../store/stores";
    import { tooltip } from "../utils/tooltip";
  import Output from "./Output.svelte";
  import { execLuaRaw } from "../utils/luaHandler";


    let luaCode;
    let eventType: string;

    let hideOnExec: boolean = false;
    let wordWrap: boolean = true;



    function execLua() {
        // SendNUI("ExecuteLua", {code: luaCode, eventType: eventType, });
        execLuaRaw(luaCode, eventType);
        if (hideOnExec) {
            SendNUI("hideUI");
        }
    }

    function handleTab(e) {
        if (e.key === "Tab") {
            e.preventDefault();
            const start = e.target.selectionStart;
            const end = e.target.selectionEnd;
            e.target.value = e.target.value.substring(0, start) + "\t" + e.target.value.substring(end);
            e.target.selectionStart = e.target.selectionEnd = start + 1;
        }
    }
    

    






</script>

<div class="w-[100%] h-full self-end relative text-center gap-0 flex flex-col overflow-y-scroll">

    <div class="w-[95%] h-full rounded-[1rem] mx-5">
        <textarea on:keydown={handleTab} bind:value={luaCode} class="w-full h-full p-5 word-wrap" class:not-word-wrap={!wordWrap} placeholder="Enter Lua code here"></textarea>
    </div>

    <span class="flex flex-row px-5 gap-5 mt-5 ">    
        <button on:click={execLua} class="selection">
            EXECUTE
            <span class="fas fa-play use-selection text-[2rem]" ></span>
        </button>
        <select bind:value={eventType} class="selection">
            <option value="client">Client</option>
            <option value="server">Server</option>
        </select>

        <i on:click={()=>{hideOnExec=!hideOnExec}} class:toggle-on={hideOnExec} use:tooltip title="Toggle Hide On Execute" class="fa-solid fa-eye-slash selection grid place-items-center w-auto h-auto toggle-on"></i>
        <i on:click={()=>{wordWrap=!wordWrap}} class:toggle-on={wordWrap} class="selection grid place-items-center w-auto h-auto toggle-on "><i use:tooltip title="Toggle Word-Wrap" class="bi bi-text-wrap text-[2rem]"></i></i>
    </span>

    <Output/>
</div>


<style>

    *::-webkit-scrollbar {
        display: none;
    }


    textarea {
        resize: none;
        background-color: var(--color-secondary);
        color: var(--color-tertiary);
        font-family: monospace, monospace;
    }

    .word-wrap {
        white-space: pre-wrap;
    }

    .not-word-wrap {
        white-space: pre;
    }

    textarea:focus {
        outline: none;
    }

    .scrollbar-hide::-webkit-scrollbar {
    display: none;
}

    .selection {
        /* background-color: var(--color-secondary); */
        color: var(--color-tertiary);
        font-weight: bold;
        font-size: 1.5rem;
        /* border: 1px solid var(--color-tertiary); */
        border-radius: 0.5rem;
        letter-spacing: 1px;
        background-color: var(--color-secondary);
        padding: 0.5rem;
    }

    .text {
        color: var(--color-tertiary);
        font-weight: bold;
        font-size: 1.5rem;
        letter-spacing: 1px;
    }

    .use-selection {
        color: var(--color-tertiary);
    }

    .selection:hover {
        color: var(--color-tertiary);
        filter: drop-shadow(0 0 0.5rem var(--color-tertiary));
    }

    .toggle-on {
        border: 2px solid var(--color-tertiary);
    }

</style>