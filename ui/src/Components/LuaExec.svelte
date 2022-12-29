<script lang="ts">
  import { AceEditor } from "svelte-ace";
  import { LuaHandler } from "../utils/luaHandler";
  import { SendNUI } from "../utils/SendNUI";
  import { themeStore, codeStore, fontSizeStore } from "../store/stores";
  import {tippy} from 'svelte-tippy';
  import 'tippy.js/dist/tippy.css';
  import { tooltip } from "../utils/tooltip";
  const tt = tooltip;

  //for ace editor
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

  let eventType: string = "client";
  let source: string;

  function execLua() {
    luaHandler.ExecuteLua($codeStore, eventType, source);
    if (hideOnExec) {
      SendNUI("hideUI")
    }
  }

  function clearLua() {
    $codeStore = "";
    initialClearClick = false;
  }

  $: if (eventType !== "source") {
    source = undefined;
  }
</script>

<div class="w-full h-full flex flex-col gap-5 z-0">
  <div class="w-full relative h-full">
    <AceEditor
      width='100%'
      height='100%'
      lang="lua"
      theme="{$themeStore}"
      options={{fontSize: `${$fontSizeStore}rem`}}
      bind:value={$codeStore}
    />
  </div>

  <div class="w-full relative flex flex-row gap-5 pl-1">
    <button class="prio self-end" on:click={execLua}>
      <i class="fa-solid fa-play"></i>
      Execute
    </button>

    <div class="btn-def min-w-[4rem] grid place-items-center" on:click={() => hideOnExec = !hideOnExec}
    use:tippy={{content: `${hideOnExec ? tt.hideOnExec : tt.showOnExec}`, placement: 'top'}}
    >
      {#if !hideOnExec}
        <i class="fa-solid fa-eye"></i>
      {:else}
        <i class="fa-solid fa-eye-slash"></i>
      {/if}
    </div>

    <div class="btn-def" on:click={() => initialClearClick = true} use:tippy={{content: `${initialClearClick ? tt.clearNoUndo : tt.clearEditor}`,  placement: 'top'}}>
      {#if !initialClearClick}
      <i class="fa-solid fa-trash"></i>
        Clear
      {:else}
        Are you sure?
      {/if}
    </div>

    {#if initialClearClick}
      <button class="def" on:click={clearLua}>
        Yes
      </button>
      <button class="def" on:click={() => initialClearClick = false}>
        No
      </button>
    {/if}

    <select bind:value={eventType} class="btn-def"
    use:tippy={{content: `${eventType == "source"? tt.execOnSource : `Execute on: ${eventType}`}`, placement: 'top'}}
    >
      <option value="client">Client</option>
      <option value="server">Server</option>
      <option value="source">Source</option>
      <option value="both">Both</option>
    </select>

    {#if eventType === 'source'}
      <span contenteditable="true" rows=1 class="btn-def max-w-fit" bind:innerHTML={source} />
    {/if}

    <div class="flex flex-row gap-2 items-center">
      <p class="text-3xl font-bold text-white">
        Font Size:
      </p>
      <input class="font-size-input text-3xl font-bold rounded-lg block w-24 text-center py-1.5 px-2.5" type="text" maxlength="4" bind:value={$fontSizeStore}/>
    </div>
  </div>

</div>

<style>
  .font-size-input {
    background-color: var(--color-tertiary);
    color: var(--color-secondary);
  }
</style>