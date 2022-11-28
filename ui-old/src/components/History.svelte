<script lang="ts">
    import { activeGlobalVariables, execHistory, luaOutput } from "../store/stores";
    import Console from "./Console.svelte";


</script>



<div class="w-[100%] h-full self-end relative text-center gap-0 flex flex-col overflow-y-scroll ">
    {#if $activeGlobalVariables.length > 0}
    <div class="w-[95%] h-[fit] variables-container relative rounded-[1rem] mx-5 flex flex-col gap-1 ">
        <p class="text mb-3 mt-5 text-start ">Global Variables</p>
        <div class="w-full max-h-[30rem] variables-container relative overflow-y-scroll  flex flex-col gap-1 ">
            {#each $activeGlobalVariables as variable}
            <span class="flex flex-row gap-1 relative">
                <textarea rows="1" readonly bind:value={variable} class="w-full h-full leading-6 text-[1.5rem] p-5" ></textarea>
            </span>
            {/each}
        </div>
    </div>
    {/if}

    {#if $execHistory.length > 0}
    <Console showHistory={true} />
    {/if}
    
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

        
    .scrollbar-hide::-webkit-scrollbar {
    display: none;
    }

    
        *::-webkit-scrollbar-thumb {
            background-color: var(--color-tertiary);
            border-radius: 10px;
        }
        textarea{
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


        .lua-history {
    resize: none;
    background-color: var(--color-secondary);
    color: var(--color-tertiary);
    font-family: monospace, monospace;
}

    
    
        .text {
    color: var(--color-tertiary);
    font-weight: bold;
    font-size: 1.5rem;
    letter-spacing: 1px;
}
    </style>