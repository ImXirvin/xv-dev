<script lang="ts">
    import { SendNUI } from "../utils/sendNui";

    let luaCode;

    function executeLua() {
        SendNUI("ExecuteLua", {
            code: luaCode,
        })
        //print the callback for this
        
    }

</script>

<div class="w-[100%] h-full self-end relative text-center gap-5 flex flex-col">
    <div class="w-[95%] h-full bg-white rounded-[1rem] m-5">
        <textarea bind:value={luaCode} class="w-full h-full p-5" placeholder="Enter Lua code here"></textarea>
    </div>

    <div>
        <button class="w-[10rem] h-[3rem] bg-white rounded-[1rem] m-5" on:click={executeLua}>Execute</button>
    </div>
</div>