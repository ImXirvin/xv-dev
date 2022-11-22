<script lang="ts">
  import Console from "./Console.svelte";
  import { execQuickFunc } from "../utils/luaHandler";
  import { tooltip } from "../utils/tooltip";
  import { activeVariables, quickFunctions } from "../store/stores";

    let selectedParam: number; // index of selected param

    function handleTab(e) {
        if (e.key === "Tab") {
            e.preventDefault();
            const start = e.target.selectionStart;
            const end = e.target.selectionEnd;
            e.target.value = e.target.value.substring(0, start) + "\t" + e.target.value.substring(end);
            e.target.selectionStart = e.target.selectionEnd = start + 1;
        }
    }

    function addVar() {
        $activeVariables.push({
            value: "",
            global: false,
        })
        $activeVariables = [...$activeVariables]
    }


    let searchTerm = "";
    let searchResults: any = [];
        
    $: {
        if (searchTerm.length > 0) {
            searchResults = $quickFunctions.filter((func) => {
                if (func.name) {
                    return func.name.toLowerCase().includes(searchTerm.toLowerCase())
                }
                return func.code.toLowerCase().includes(searchTerm.toLowerCase())
            })
            console.log(searchResults)
        } else {
            searchResults = $quickFunctions;
        }
    }


</script>



<div class="w-[100%] h-full self-end relative text-center gap-0 flex flex-col overflow-y-scroll ">
    <div class="w-[95%] h-[fit] variables-container relative rounded-[1rem] mx-5 flex flex-col gap-1 ">
        <div class="w-full max-h-[20rem] variables-container relative overflow-y-scroll  flex flex-col gap-1 ">
            {#each $activeVariables as varCon, i}
            <span class="flex flex-row gap-1 relative">
                <div class:toggle-on={varCon.global} on:click={()=>{varCon.global=!varCon.global}} class="selection grid place-items-center w-auto h-auto "><i class="fa-solid fa-earth-americas"></i></div>
                <textarea on:keydown={handleTab}  bind:value={varCon.value} rows="1" class="w-full h-full leading-6 text-[1.5rem] p-5" placeholder="Create variables ({varCon.global ? 'GLOBAL':'LOCAL'})"></textarea>
                <div  on:click={()=>{if ($activeVariables.length > 1){$activeVariables.splice(i,1);$activeVariables = [...$activeVariables] }}} class="selection grid place-items-center w-auto h-auto fa-solid fa-trash"></div>
            </span>
            {/each}
        </div>
        <button class="add-button relative w-[fit]" on:click={addVar}><i class="fa-solid fa-plus"></i></button>
    </div>
    <div class="w-[95%]  relative rounded-[1rem] mx-5 flex flex-col gap-1 ">
        <span class="text mb-3 mt-5 text-start">FUNCTIONS
            <input bind:value={searchTerm} class="search-input" placeholder="Search for a function" />
        </span>
        <div class="w-full max-h-[38rem] relative overflow-y-scroll flex flex-col gap-1 ">
            {#each searchResults as func}
            <!-- {#each $quickFunctions as func, i} -->
            <div class="flex flex-wrap w-full gap-1 h-fit relative overflow-visible  ">
                <button on:click={()=>execQuickFunc(func, $activeVariables)} class="button exec-button grid place-items-center">
                    <span class="fas fa-play p-3 w-auto h-auto" ></span>
                </button>
                {#if func.expectedParams}
                <p class=" code-text w-fit h-fit relative leading-6 text-[1.5rem] p-5" use:tooltip title={`(${func.expectedParams})`}>{func.name || func.code}</p>
                {:else}
                <p class=" code-text w-fit h-fit relative leading-6 text-[1.5rem] p-5" >{func.name || func.code}</p>
                {/if}
                {#each func.params as param, v}
                    <span role="textbox" contenteditable="true" on:focusout={()=>selectedParam=null} on:dblclick={()=>{if (selectedParam==v){ selectedParam=null } else { selectedParam=v;}}} class:toggle-on={(selectedParam==v)} bind:innerHTML={param} rows="1" class="param-item relative max-w-fit  h-fit leading-6 text-[1.5rem] p-5" ></span>
                {/each}
                <div  on:click={()=>{func.params.push(""); func.params = [...func.params]}} class="button grid place-items-center"><i class="fa-solid fa-plus p-3 w-auto h-auto"></i></div>
                
                {#if func.params.length > 0}
                <div   on:click={()=>{if (func.params.length > 0){func.params.splice(selectedParam,1);func.params = [...func.params] }}}  class="button grid place-items-center" ><i class="fa-solid fa-trash p-3 w-auto h-auto"></i></div>
                {/if}
            </div>
            {/each}
        </div>
    </div>

    <Console />



</div>


<style>

/* disable tab selection highlight for all element */
    *:focus {
        outline: none;
    }
    
    *::-webkit-scrollbar {
        width: 0px;
        height: 0px;
    }


    *::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0);
    }

    *::-webkit-scrollbar-thumb {
        background-color: var(--color-tertiary);
        border-radius: 10px;
    }

    .param-item::-webkit-scrollbar {
        height: 2px;
    }

    .code-text {
        background-color: var(--color-secondary);
        color: var(--color-tertiary);
        font-family: monospace, monospace;
        letter-spacing: 1px;
    }

    textarea, .param-item, .search-input {
        resize: none;
        background-color: var(--color-secondary);
        color: var(--color-tertiary);
        font-family: monospace, monospace;
        resize: none;
    white-space: nowrap;
    /* overflow-x: scroll; */
        overflow-y: hidden;
        overflow-x: auto;
    }

    .button {
        aspect-ratio : 1 / 1;
        color: var(--color-tertiary);
        font-weight: bold;
        font-size: 1.5rem;
        border-radius: 0.5rem;
        padding: 0.5rem;
        letter-spacing: 1px;
        background-color: var(--color-secondary);
        cursor: pointer;
    }

    .exec-button:active {
        background-color: var(--color-tertiary);
        color: var(--color-primary);
    }
    .exec-button:active > span {
        background-color: var(--color-tertiary);
        color: var(--color-primary);
    }


    .text {
        color: var(--color-tertiary);
        font-weight: bold;
        font-size: 1.5rem;
        letter-spacing: 1px;
    }



    .selection {
        aspect-ratio : 1 / 1;
        color: var(--color-tertiary);
        font-weight: bold;
        font-size: 1.5rem;
        border-radius: 0.5rem;
        letter-spacing: 1px;
        background-color: var(--color-secondary);
        padding: 0.5rem;
        cursor: pointer;
    }
    .add-button {
        color: var(--color-tertiary);
        font-weight: bold;
        font-size: 1.5rem;
        border-radius: 0.5rem;
        letter-spacing: 1px;
        background-color: var(--color-secondary);
        padding: 0.5rem;
        cursor: pointer;
    }

    .selection:hover ,.add-button:hover, .button:hover {
        color: var(--color-tertiary);
        filter: drop-shadow(0 0 0.5rem var(--color-tertiary));
    }


    .toggle-on {
        border: 2px solid var(--color-tertiary);
    }
</style>