<script lang="ts">

    let varCode: string = ""
    let activeVars: string[] = ['', '', '', '', '', '', '', '', '', '']

    function handleTab(e) {
        if (e.key === "Tab") {
            e.preventDefault();
            const start = e.target.selectionStart;
            const end = e.target.selectionEnd;
            e.target.value = e.target.value.substring(0, start) + "\t" + e.target.value.substring(end);
            e.target.selectionStart = e.target.selectionEnd = start + 1;
        }
    }

    
</script>



<div class="w-[100%] h-full self-end relative text-center gap-0 flex flex-col">
    <div class="w-[95%] h-[fit] rounded-[1rem] mx-5 flex flex-col gap-1">
    {#each activeVars as varCon}
        <textarea on:keydown={handleTab} bind:value={varCon} rows="1" class="w-full h-full leading-6 text-[1.5rem] p-5" placeholder="Create variables (local by default)"></textarea>
    {/each}
    </div>

</div>


<style>

    *::-webkit-scrollbar {
        height: 8px;
        width: 8px;
    }

    *::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0);
    }

    *::-webkit-scrollbar-thumb {
        background-color: var(--color-tertiary);
        border-radius: 10px;
    }

    textarea {
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



</style>