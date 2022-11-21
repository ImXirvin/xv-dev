<script lang="ts">
  import { fly } from "svelte/transition";
    import LuaExec from "./LuaExec.svelte";
    import QuickFunc from "./QuickFunc.svelte"
    import History from "./History.svelte";
    import { debug } from "../store/stores";

    let showSide: boolean = false;

    let options =  [
        {
            name: "Lua Executor",
            component: LuaExec,
        },
        {
            name: "Quick Functions",
            component: QuickFunc,
        },
        {
            name: "History",
            component: History,
        },
    ];
    let selected = options[0]


</script>


<div transition:fly="{{x: 800, duration: 500,}}" class="main-container absolute w-[50rem] h-[98vh] my-auto right-0 flex flex-col overflow-x-hidden">
    <span class="relative h-[5rem] flex flex-row p-1 mb-3 items-center top-3">
        <span class="relative text-white  text-[2.5rem] grid place-content-center sidebar-button fas fa-list z-10" on:click={() => showSide = !showSide}></span>
        <h1 class="text-white text-3xl font-bold absolute text-center w-full z-0">{selected.name}</h1>
        <button class="selection grid place-items-center w-auto h-auto absolute mx-5 right-0" class:toggle-on={$debug} on:click={() => $debug = !$debug}><i class="fa-solid fa-bug p-3 w-auto h-auto"></i></button>
    </span>

        <!-- CONTENT  -->
        <svelte:component  this={selected.component}/>
    <ol  class="w-[15rem] sidebar h-full self-end absolute text-center gap-5 flex flex-col p-5 {showSide ? 'show-side' : 'hide-side'} ">
        {#each options as option, i}
        <li class="list-item text-white text-2xl font-bold py-5 top-20" on:click={() => selected = options[i]}>{option.name}</li>
        {/each}
    </ol>


</div>


<style>
    
    :root {
        --color-primary: rgba(0, 0, 0, 0.9);
        --color-secondary: rgb(255, 0, 0, 0.8);
    }

    .show-side {
        left: 0;
    }

    .toggle-on {
        border: 2px solid var(--color-tertiary);
    }

    .hide-side {
        left: -100%;
    }

    .sidebar {
        background-color: var(--color-primary);
        transition: left 0.2s;
    }

    .sidebar-button {
        background-color: none;
        border-radius: 1rem;
        cursor: pointer;
        /* top: 1rem;
        left: 1rem; */
        margin: 1rem;
        padding: 1rem;
    }

    .sidebar-button:hover {
        background-color: var(--color-primary);
        box-shadow: 0 0 0.5rem 0.2rem var(--color-secondary);
    }


    .main-container {
        box-shadow: 0 0 0.5rem 0.2rem rgba(0, 0, 0, 0.5);
        background-color: var(--color-primary);
        border-top-left-radius: 1rem;
        border-bottom-left-radius: 1rem;
        /* center vertically */
        top: 50%;
        transform: translateY(-50%);

    }


    .list-item {
        position: relative;
        cursor: pointer;
        background-color: var(--color-secondary);
        border-radius: 1rem;
    }

    .list-item:hover {
        filter: drop-shadow(0 0 0.5rem var(--color-tertiary));
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
</style>