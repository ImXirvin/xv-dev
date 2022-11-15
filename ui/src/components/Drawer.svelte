<script lang="ts">
    import LuaExec from "./LuaExec.svelte";

    let options =  [
        {
            name: "LuaExec",
            component: LuaExec,
        },
    ];
    let selected = options[0]


</script>


<div class="main-container absolute w-[45rem] h-[90%] bottom-0 right-0 bg-black rounded-tl-[3rem] flex flex-col">
    <span class="relative h-[2rem] grid place-items-center p-1 mb-3 align-center">
        <h1 class="text-white text-3xl font-bold relative">Xirvin's VERY USEFUL Dev Menu</h1>
    </span>
    <div class="h-full  relative flex flex-row">
        <!-- LIST  -->

        <ol class="w-[25%] h-full self-end relative text-center gap-5 flex flex-col">
            {#each options as option, i}
            <li class="list-item text-white text-2xl font-bold py-5" on:click={() => selected = options[i]}>{option.name}</li>
            {/each}
        </ol>

        <!-- CONTENT  -->
        <svelte:component this={selected.component}/>

    </div>


</div>


<style>

    :root {
        --color-primary: rgba(0, 0, 0, 0.8);
        --color-secondary: rgba(0, 0, 0, 0.8);
    }

    .main-container {
        box-shadow: 0 0 0.5rem 0.2rem rgba(0, 0, 0, 0.5);
        background-color: var(--color-primary);
    }


    .list-item {
        position: relative;
        cursor: pointer;
        background-color: var(--color-secondary);
        border-top-right-radius: 1rem;
        border-bottom-right-radius: 1rem;
    }
</style>