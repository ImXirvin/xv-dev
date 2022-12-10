<script>
    import { variablesStore } from "../store/stores";
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../utils/tooltip";

    const tt = tooltip;

    function addVar() {
        let varStore = $variablesStore;
        varStore.push({
            value: "",
            global: false,
        });
        $variablesStore = [...varStore];
    }
</script>




<div class="w-full h-full flex flex-col gap-5 z-0">
    <div class="variables-container relative w-100 max-h-[50%] ">
        <ul class="w-full flex h-fit max-h-[100%] scrollbar-hide overflow-y-scroll  flex-col gap-5 relative"> 
            {#each $variablesStore as variable, i}
                <li class="w-full h-10 flex flex-row relative gap-2 items-center">
                    <button
                        class:selected={variable.global}
                        class="sec"
                        on:click={()=>variable.global=!variable.global}
                        use:tippy={{content: `Current: ${variable.global ? 'Global' : 'Local'}`, placement: "right"}}
                    >
                        <i class="fas fa-globe"></i>
                    </button>
                    <input
                        class="w-full h-[3rem] rounded-md variable-input leading-6"
                        type="text"
                        bind:value={variable.value}
                        placeholder="Declare a variable (Current Scope: {variable.global ? 'Global' : 'Local'})"
                    />
                    <button
                        class="sec"
                        on:click={() => {
                            $variablesStore.splice(i, 1);
                            $variablesStore = [...$variablesStore];
                        }}
                        
                        use:tippy={{content: tt.removeVar, placement: "left"}}
                    >
                        <i class="fas fa-times"></i>
                    </button>
                </li>
            {/each}
            <button
                class="sec"
                on:click={addVar}
                use:tippy={{content: tt.addVar, placement: "bottom"}}
            >
                <i class="fas fa-plus"></i>
            </button>
        </ul>
    </div>

    
</div>


<style>

    input {
        outline: none;
        font-family: 'JetBrains Mono', monospace;
    }

.selected {
    background-color: var(--color-tertiary);
    color: var(--color-primary);
}

.variable-input {
    background-color: var(--color-primary);
    color: var(--color-tertiary);
}

</style>