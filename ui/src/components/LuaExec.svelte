<script lang="ts">
    import { SendNUI } from "../utils/sendNui";
    import { visibility } from "../store/stores";
    import { tooltip } from "../utils/tooltip";
    import { afterUpdate } from 'svelte';
  import { ReceiveNUI } from "../utils/ReceiveNUI";

    let luaCode;
    let selectedType: string;
    let luaOutput: string = "";
    let luaOutputElement: HTMLTextAreaElement;


    let hideOnExec: boolean = false;
    let wordWrap: boolean = true;

    function getDateTime() {
        let date = new Date();
        let hour = date.getHours();
        let min = date.getMinutes();
        let sec = date.getSeconds();
        let time = hour + ":" + min + ":" + sec;
        return time;
    }

    function execLua() {
        SendNUI("ExecuteLua", {code: luaCode, eventType: selectedType, });
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
    
    function updateOutput(output) {
        luaOutput += `[${getDateTime()}][${selectedType}]: ${output}\n`;
        scrollToBottom(luaOutputElement);
    }
    
    ReceiveNUI("updateOutput", (data) => {
        updateOutput(data.output);
    });


    afterUpdate(() => {
		if(luaOutputElement) scrollToBottom(luaOutputElement);
    });

    const scrollToBottom = async (node) => {
    node.scroll({ top: (node.scrollHeight), behavior: 'auto' });
  }; 

</script>

<div class="w-[100%] h-full self-end relative text-center gap-0 flex flex-col">

    <div class="w-[95%] h-1/2 rounded-[1rem] mx-5">
        <textarea on:keydown={handleTab} bind:value={luaCode} class="w-full h-full p-5 word-wrap" class:not-word-wrap={!wordWrap} placeholder="Enter Lua code here"></textarea>
    </div>

    <span class="flex flex-row px-5 gap-5 mt-5 ">    
        <button on:click={execLua} class="selection">
            EXECUTE
            <span class="fas fa-play use-selection text-[2rem]" ></span>
        </button>
        <select bind:value={selectedType} class="selection">
            <option value="client">Client</option>
            <option value="server">Server</option>
        </select>

        <i on:click={()=>{hideOnExec=!hideOnExec}} class:toggle-on={hideOnExec} use:tooltip title="Toggle Hide On Execute" class="fa-solid fa-eye-slash selection grid place-items-center w-auto h-auto toggle-on"></i>
        <i on:click={()=>{wordWrap=!wordWrap}} class:toggle-on={wordWrap} class="selection grid place-items-center w-auto h-auto toggle-on "><i use:tooltip title="Toggle Word-Wrap" class="bi bi-text-wrap text-[2rem]"></i></i>
    </span>

    <div class="w-[95%] h-[33.5rem] rounded-[1rem] mx-5 my-5 gap-5 align-bottom">
        <p class="text mb-3 text-start">Output</p>
        <textarea bind:this={luaOutputElement} readonly bind:value={luaOutput} class="w-full h-full p-5 overflow-y-scroll scrollbar-hide " placeholder="Output will be here"></textarea>
    </div>
</div>


<style>

    *::-webkit-scrollbar {
        height: 8px;
        width: 8px;
    }

    *::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0);
    }

    *::-webkit-scrollbar-thumb {
        background-color: var(--color-tertiary);
        border-radius: 10px;
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