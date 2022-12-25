<script lang="ts">
    import { themeStore, quickFunctionsStore } from '../store/stores';
    import { QuickFunctionDefault } from "../utils/Defaults";
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../utils/tooltip";
    const tt = tooltip;
    import { AceEditor } from "svelte-ace";
    import "brace/mode/json";

    let configuringQuickFunctions = false;

    let quickFun = JSON.stringify(JSON.parse(localStorage.getItem('quickFunctions')), null, "\t");;
</script>

<div class="w-full h-full flex flex-col gap-5 z-0 parent-cont flex-grow flex-shrink">
    <div class="child">
        <h1 class="text-start font-bold text-white">Theme</h1>
        <select bind:value={$themeStore} class="btn-def"
        use:tippy={{content: tt.theme, placement: 'top'}}
        >
            <option value="clouds_midnight">clouds_midnight</option>
            <option value="merbivore_soft">merbivore_soft</option>
            <option value="tomorrow_night">tomorrow_night</option>
            <option value="tomorrow_night_eighties">tomorrow_night_eighties</option>
            <option value="twilight">twilight</option>
            <option value="vibrant_ink">vibrant_ink</option>
        </select>
    </div>

    <div class="child relative h-[100%] mb-[5rem]">
        <h1 class="text-start font-bold text-white">Configure Quick Funtions</h1>
        <button class="btn-def  " 
            on:click={() => configuringQuickFunctions = !configuringQuickFunctions}>
            <i class="fa-solid {configuringQuickFunctions ? "fa-caret-up" : "fa-caret-down"}"></i> {configuringQuickFunctions ? "Close" : "Open"}
        </button>
        <button class="btn-def" 
            use:tippy={{content: tt.quickFuncDefault, placement: 'top'}}
            on:click={() => {
                localStorage.setItem('quickFunctions', JSON.stringify(QuickFunctionDefault));
                quickFunctionsStore.set(JSON.parse(localStorage.getItem('quickFunctions')));
                configuringQuickFunctions = false;
            }}>
            Reset
        </button>
        {#if configuringQuickFunctions}
            <button class="btn-def" 
                use:tippy={{content: tt.quickFuncWarning, placement: 'top'}}
                on:click={() => {
                    localStorage.setItem('quickFunctions', quickFun);
                    quickFunctionsStore.set(JSON.parse(quickFun));
                    configuringQuickFunctions = false;
                }}>
                Save
            </button>
        {/if}
        {#if configuringQuickFunctions}
        <div class="w-full absolute h-full"
            use:tippy={{content: tt.quickFuncEditorWarning, placement: 'top'}}
            >
            <AceEditor
              width='100%'
              height='100%'
              lang="json"
              theme="{$themeStore}"
              bind:value={quickFun} 
            />
        </div>
        {/if}
    </div>
</div>


<style>

    
</style>