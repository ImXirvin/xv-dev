<script lang="ts">
    import { fly } from "svelte/transition";
    import { debugMode } from "../store/stores";

    let showSide: boolean = false;
    export let selectedComponent;

    let options =  [
        {
            name: "Lua Executor",
            icon: "fas fa-terminal",
        //   component: LuaExec,
        },
        {
            name: "Quick Functions",
            icon: "fas fa-bolt",
        //   component: QuickFunc,
        },
        {
            name: "History",
            icon: "fas fa-history",
        //   component: History,
        },
    ];
    let selected = options[0]

</script>

<div class="h-[calc(100%-30px)] drawer absolute w-[30rem] flex flex-col text-center items-center top-[30px] left-0">
    <h1 class="w-full font-bold text-[2rem]">Components</h1>
    <div class="w-full flex flex-col gap-0">
        {#each options as option}
            <button class=" button bg-gray-700 text-white flex flex-row gap-5 items-center relative min-h-max" on:click={() => selected = option}>
                <i class="{option.icon}"></i>
                <p>{option.name}</p>
            </button>
        {/each}
    </div>

</div>

<style>
    .drawer {
        transition: all 0.5s ease-in-out;
        border-top-right-radius: 10px;
        border-bottom-right-radius: 10px;
        border-bottom-left-radius: 10px;
        color: var(--color-tertiary);
        box-shadow: 0 0 1rem 0 rgba(0, 0, 0, 0.5);
    }


</style>

