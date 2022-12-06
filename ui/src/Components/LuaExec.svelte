<script lang="ts">
  import { AceEditor } from "svelte-ace";
  import { LuaHandler } from "../utils/luaHandler";
  import { theme } from "../store/stores";

  import "brace/mode/lua";
  import "brace/theme/clouds_midnight";
  import "brace/theme/merbivore_soft";
  import "brace/theme/tomorrow_night";
  import "brace/theme/tomorrow_night_eighties";
  import "brace/theme/twilight";
  import "brace/theme/vibrant_ink";

  const luaHandler = new LuaHandler();

  let initialClearClick = false;
  let hideOnExec = false;

  let luaCode: string = "";
  let eventType: string = "client";
  let source: string;

$: console.log(eventType)
</script>


<div class="w-full h-full flex flex-col gap-5 z-0">
  <div class="w-full relative h-full">
    <AceEditor
    on:selectionChange={(obj) => console.log(obj.detail)}
    on:paste={(obj) => console.log(obj.detail)}
    on:input={(obj) => console.log(obj.detail)}
    on:focus={() => console.log('focus')}
    on:documentChange={(obj) => console.log(`document change : ${obj.detail}`)}
    on:cut={() => console.log('cut')}
    on:cursorChange={() => console.log('cursor change')}
    on:copy={() => console.log('copy')}
    on:init={(editor) => console.log(editor.detail)}
    on:commandKey={(obj) => console.log(obj.detail)}
    on:changeMode={(obj) => console.log(`change mode : ${obj.detail}`)}
    on:blur={() => console.log('blur')}
    width='100%'
    height='100%'
    lang="lua"
    theme="{$theme}"
    value={luaCode} />

  </div>

  <div class="w-full relative flex flex-row gap-5 inline pl-1">
    <button class="prio self-end" on:click={() => luaHandler.ExecuteLua(luaCode, eventType, source)}>
      <i class="fa-solid fa-play"></i>
      Execute
    </button>

    <div class="btn-def min-w-[4rem] grid place-items-center" on:click={() => hideOnExec = !hideOnExec}>
      {#if !hideOnExec}
        <i class="fa-solid fa-eye"></i>
      {:else}
        <i class="fa-solid fa-eye-slash"></i>
      {/if}
    </div>

    <div class="btn-def" on:click={() => initialClearClick = true}>
      {#if !initialClearClick}
      <i class="fa-solid fa-trash"></i>
        Clear
      {:else}
        Are you sure?
      {/if}
    </div>

    {#if initialClearClick}
      <button class="def" on:click={() => {luaCode = "";initialClearClick = false}}>
        Yes
      </button>
      <button class="def" on:click={() => initialClearClick = false}>
        No
      </button>
    {/if}

    <select bind:value={eventType} class="btn-def">
      <option value="client">Client</option>
      <option value="server">Server</option>
      <option value="source">Source</option>
      <option value="both">Both</option>
    </select>

    {#if eventType === 'source'}
      <span contenteditable="true" rows=1 class="btn-def max-w-fit" bind:innerHTML={source} />
    {/if}




  </div>

</div>




  <style>
  </style>