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


    function handleFocusOut() {
       selectedParam=null 
       selectedFunc=null;
    //    sel.addRange(range);
    }


</script>




<div class="parent-container">
    <div class="variables-container">
        <ul class="w-full  flex max-h-full scrollbar-hide overflow-y-scroll  flex-col gap-5 relative"> 
            {#each $variablesStore as variable, i}
                <li class="w-full h-fit flex flex-row relative gap-2 items-center ">
                    <button
                        class:selected={variable.global}
                        class="sec"
                        on:click={()=>$variablesStore[i].global=!$variablesStore[i].global}
                        use:tippy={{content: `Current: ${$variablesStore[i].global ? 'Global' : 'Local'}`, placement: "right"}}
                    >
                        <i class="fas fa-globe"></i>
                    </button>
                    <textarea
                        class="w-full min-h-[3rem] rounded-md variable-input "
                        type="text"
                        bind:value={$variablesStore[i].value}
                        rows="1"
                        placeholder="Declare a variable (Current Scope: {$variablesStore[i].global ? 'Global' : 'Local'})"
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
    <div class="functions-container scrollbar-hide">
        <span class="relative">
            <input bind:value={quickSearcTerm} class=" relative h-[3rem] rounded-md variable-input leading-6 px-2" placeholder="Search for a function" />
        </span>
        <ul class="search-result-container w-full scrollbar-hide overflow-y-scroll flex flex-col gap-2 relative"> 
            {#each quickSearchResults as qfunc, i}
                <li
                    class="quick-func-item"
                >
                    <button 
                        on:click={()=>luaHandler.ExecuteQuickFunction(qfunc, $paramListStore[i], $variablesStore)} 
                        class="sec"
                        use:tippy={{content: tt.execute, placement: "right"}}
                    >
                            <span class="fas fa-play" ></span>
                    </button>
                    <span 
                        class="w-fit h-[3rem] relative  rounded-md variable-input  leading-6 p-1 text-center grid place-items-center"
                        use:tippy={{content: `(${qfunc.expectedParams.join(', ')})`, placement: "top"}}
                    >
                        <p class="code-text">{qfunc.name ? qfunc.name : qfunc.code}</p>
                    </span>
                    {#if $paramListStore[i]}
                    {#each $paramListStore[i] as param, j}
                        <input
                            role="textbox" 
                            contenteditable="true"
                            class="param-item scrollbar-hide param-{j} h-[3rem] rounded-md variable-input leading-6 grid place-items-center code-text p-3"
                            type="text"
                            bind:value={$paramListStore[i][j]}
                            on:focus={(evt) => evt.target.select()}
                            on:focusout={handleFocusOut}
                            on:dblclick={()=>{
                                if (selectedParam==j && selectedFunc==i){ 
                                    selectedParam=null 
                                    selectedFunc=null;
                                } else { 
                                    selectedParam=j;
                                    selectedFunc=i;
                                }
                            }}
                            on:keypress={(e)=>{
                                if (e.key == "Enter") {
                                    e.preventDefault();
                                    if (!$paramListStore[i]) {
                                        $paramListStore[i] = [];
                                    }
                                    $paramListStore[i].push("");
                                    $paramListStore[i] = [...$paramListStore[i]];
                                    $paramListStore = [...$paramListStore];
                                    setTimeout(()=>{
                                        const nextParam = document.querySelectorAll(`.param-${j+1}`)[i];
                                        //select the text inside the input
                                        // const range = document.createRange();
                                        // const sel = window.getSelection();
                                        // range.setStart(nextParam, 0);
                                        // range.collapse(true);
                                        // sel.removeAllRanges();
                                        // sel.addRange(range);
                                        // nextParam.focus();
                                    }, 0)

                                    //focus on the next param input

                                }
                            }}
                            rows="1"
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

    .param-item {
        position: relative;
        white-space: nowrap;
        overflow: hidden;
        display:inline;
        white-space:nowrap;
    }


    .parent-container {
        position: relative;
        display: flex;
        flex-direction: column;
        height: 100%;
        width: 100%;
        padding-bottom: 0.2rem;
        gap : 0.5rem;
    }

    .quick-func-item {
        position: relative;
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        gap: 0.5rem;
        align-items: center;
    }

    .quick-func-item > .param-item {
        flex: 1 1 10rem;
        overflow-x: scroll;
    }

    .variables-container {
        position: relative;
        width: 100%;
        max-height: 50%;
    }

    .functions-container {
        position: relative;
        display: flex;
        max-width: 100%;
        flex-direction: column;
        gap: 0.5rem;
        flex: 1 1 100%;
        overflow-y: scroll;
    }

    .search-result-container {
        position: relative;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }



    .selected {
        background-color: var(--color-tertiary);
        color: var(--color-primary);
    }

    .selected-param {
        /* white inset box shadow */
        box-shadow: 0 0 0 1px var(--color-tertiary) inset;
    }
</style>