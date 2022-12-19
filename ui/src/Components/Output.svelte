<script lang="ts">
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../utils/tooltip";
    import { luaOutputStore, debugOutputStore, variablesLogStore } from "../store/stores";
  import { afterUpdate, onMount } from 'svelte';


  const tt = tooltip;

    let selected = "output"

    let currentElement = null;
    const scrollToBottom = async (node) => {
        node.scroll({ top: (node.scrollHeight), behavior: 'auto' });
    }; 


    afterUpdate(() => {
        if (currentElement) {
            scrollToBottom(currentElement);
        }
    });
</script>




<div class="relative flex flex-col gap-5 w-full h-full">
    <span class="top-0  h-[3rem] flex flex-row items-start gap-2">
        <button class="def relative flex-row flex items-center justify-center gap-2"
            on:click={() => selected = "output"}
            class:prio={(selected == "output")}
            use:tippy={{content: tt.outputTab, placement: "top"}}
        >
            <i class="fas fa-bars"></i>
            <p>Output</p>
        </button>
        <button class="def relative flex-row flex items-center justify-center gap-2"
            on:click={() => selected = "history"}
            class:prio={(selected == "history")}
            use:tippy={{content: tt.historyTab, placement: "top"}}
        >
            <i class="fas fa-bars"></i>
            <p>History</p>
        </button>
        <button class="def relative flex-row flex items-center justify-center gap-2"
            on:click={() => selected = "variables"}
            class:prio={(selected == "variables")}
            use:tippy={{content: tt.variablesTab, placement: "top"}}
        >
            <i class="fas fa-bars"></i>
            <p>Variables</p>
        </button>
    </span>
    {#if (selected == 'output')}
    <div bind:this={currentElement} class="text-white relative div-box min-h-[15rem] h-[15rem] w-full p-1 overflow-y-scroll scroll-style scroll-y code-text rounded-md" >
        {#if ($luaOutputStore.length == 0)}
            <p class="text-center">No output logged</p>
        {:else}
            {#each $luaOutputStore as output, i}
                {@html output}
            {/each}
        {/if}
    </div>
    {:else if (selected == 'history')}
    <div bind:this={currentElement} class="text-white relative div-box min-h-[15rem] h-[15rem] w-full p-1 overflow-y-scroll scroll-style scroll-y code-text rounded-md" >
        {#if ($debugOutputStore.length == 0)}
            <p class="text-center">No history logged</p>
        {:else}
            {#each $debugOutputStore as debug, i}
                {@html debug}
            {/each}
        {/if}
    </div>
    {:else if (selected == 'variables')}
    <div bind:this={currentElement} class="text-white relative div-box min-h-[15rem] h-[15rem] w-full p-1 overflow-y-scroll scroll-style scroll-y code-text rounded-md" >
        {#if ($variablesLogStore.length == 0)}
            <p class="text-center">No variables logged</p>
        {:else}
            {#each $variablesLogStore as varLog, i}
                {@html varLog.html}
            {/each}
        {/if}
    </div>
    {/if}

</div>


<style>
    .div-box {
        background-color: var(--color-primary);
        user-select: text;
        word-break: break-all;
    }

</style>