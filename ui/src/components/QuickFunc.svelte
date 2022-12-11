<script>
    import { variablesStore, quickFunctionsStore, paramListStore } from "../store/stores";
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../utils/tooltip";
    import { LuaHandler } from "../utils/luaHandler";
    
    const luaHandler = new LuaHandler();

    const tt = tooltip;

    let quickSearcTerm = "";
    let quickSearchResults = [];
    let selectedParam = null;
    let selectedFunc = null;

    function addVar() {
        let varStore = $variablesStore;
        varStore.push({
            value: "",
            global: false,
        });
        $variablesStore = [...varStore];
    }


    $: {
        if (quickSearcTerm.length > 0) {
            quickSearchResults = $quickFunctionsStore.filter((func) => {
                if (func.name) {
                    return func.name.toLowerCase().includes(quickSearcTerm.toLowerCase())
                }
                return func.code.toLowerCase().includes(quickSearcTerm.toLowerCase())
            })
            // console.log(searchResults)
        } else {
            quickSearchResults = $quickFunctionsStore;
        }
    }

    function handleFocus(e) {
        const el = e.target
        const range = document.createRange();
       range.selectNodeContents(el);
        const sel = window.getSelection();
       sel.removeAllRanges();
       sel.addRange(range);
    }

    function handleFocusOut(e) {
        const el = e.target
        const range = document.createRange();
       range.selectNodeContents(el);
        const sel = window.getSelection();
       sel.removeAllRanges();
    //    sel.addRange(range);
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
    <div class="quick-functions-container h-fit relative w-100 max-h-[100%] flex flex-col gap-2">
        <span class=" relative">
            <input bind:value={quickSearcTerm} class=" relative h-[3rem] rounded-md variable-input leading-6" placeholder="Search for a function" />
        </span>
        <ul class="w-full flex h-[100%] scrollbar-hide overflow-y-scroll  flex-col gap-5 relative"> 
            {#each quickSearchResults as qfunc, i}
                <li
                    class="w-full h-10 flex flex-row relative gap-2 items-center"
                >
                    <button 
                        on:click={()=>luaHandler.ExecuteQuickFunction(qfunc, $paramListStore[i]  ,$variablesStore)} 
                        class="sec"
                    >
                            <span class="fas fa-play" ></span>
                    </button>
                    <span 
                        class="w-fit h-[3rem]  rounded-md variable-input  leading-6 p-1 text-center grid place-items-center"
                        use:tippy={{content: `(${qfunc.expectedParams.join(', ')})`, placement: "top"}}
                    >
                        <p class="code-text">{qfunc.name ? qfunc.name : qfunc.code}</p>
                    </span>
                    {#if $paramListStore[i]}
                    {#each $paramListStore[i] as param, j}
                        <span
                            role="textbox" 
                            contenteditable="true"
                            class="min-w-[2rem] h-[3rem] rounded-md variable-input leading-6 grid place-items-center code-text text-center p-3"
                            type="text"
                            bind:innerHTML={param}
                            on:focusin={handleFocus}
                            on:focusout={handleFocusOut}
                            on:dblclick={()=>{
                                console.log('dblclick')
                                if (selectedParam==j && selectedFunc==i){ 
                                    selectedParam=null 
                                    selectedFunc=null;
                                } else { 
                                    console.log(j)
                                    selectedParam=j;
                                    selectedFunc=i;
                                }
                                }}
                            class:selected-param={(selectedParam==j && selectedFunc==i)}
                        />
                    {/each}
                    {/if}
                    <button 
                        on:click={() => {
                            if (!$paramListStore[i]) {
                                $paramListStore[i] = [];
                            }
                            $paramListStore[i].push("");
                            $paramListStore[i] = [...$paramListStore[i]];
                            $paramListStore = [...$paramListStore];
                        }}
                        class="sec aspect-square"
                        use:tippy={{content: tt.addParam, placement: "top"}}
                    >
                        <i class="fas fa-plus"></i>
                    </button>
                    {#if $paramListStore[i] && $paramListStore[i].length > 0}
                    <button 
                        on:click={() => {
                            if ($paramListStore[i] && selectedParam != null) {
                                console.log($paramListStore[i][selectedParam])
                                $paramListStore[i].splice(selectedParam, 1);
                                $paramListStore = [...$paramListStore];
                                selectedParam = null;
                                selectedFunc = null;
                            }
                            else if ($paramListStore[i]) {
                                $paramListStore[i].pop();
                                $paramListStore[i] = [...$paramListStore[i]];
                                $paramListStore = [...$paramListStore];
                            }
                        }}
                        class="sec aspect-square"
                        use:tippy={{content: tt.removeParam, placement: "top"}}
                    >
                        <i class="fas fa-times"></i>
                    </button>
                    {/if}
                </li>
            {/each}
        </ul>
    </div>
    
</div>


<style>

    input, .code-text {
        outline: none;
        font-family: 'JetBrains Mono', monospace;
    }

    .selected {
        background-color: var(--color-tertiary);
        color: var(--color-primary);
    }

    .selected-param {
        /* white inset box shadow */
        box-shadow: 0 0 0 1px var(--color-tertiary) inset;
    }

.variable-input {
    background-color: var(--color-primary);
    color: var(--color-tertiary);
}

.variable-input::selection {
	background-color: var(--color-tertiary);
    color: var(--color-primary);
}

</style>