<script lang="ts">
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../utils/tooltip";
    import { luaOutputStore, debugOutputStore, variablesLogStore } from "../store/stores";


  const tt = tooltip;

    let selected = "output"

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
    <div class="text-white relative div-box min-h-[15rem] h-[15rem] w-full p-1 overflow-y-scroll scroll-style scroll-y code-text rounded-md" >
        {#each $luaOutputStore as output, i}
            {@html output}
        {/each}
    </div>
    {:else if (selected == 'history')}
    <div class="text-white relative div-box min-h-[15rem] h-[15rem] w-full p-1 overflow-y-scroll scroll-style scroll-y code-text rounded-md" >
        {#each $debugOutputStore as debug, i}
            {@html debug}
        {/each}
    </div>
    {:else if (selected == 'variables')}
    <div class="text-white relative div-box min-h-[15rem] h-[15rem] w-full p-1 overflow-y-scroll scroll-style scroll-y code-text rounded-md" >
        {#each $variablesLogStore as varLog, i}
            {@html varLog}
        {/each}
    </div>
    {/if}

</div>


<style>
    .div-box {
        background-color: var(--color-primary);
        user-select: text;
    }

</style>