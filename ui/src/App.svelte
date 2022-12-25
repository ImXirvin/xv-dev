<script lang="ts">
  import MovableWin from "./Components/MovableWin.svelte";
  import VisibilityProvider from "./providers/VisibilityProvider.svelte";
  import { debugData } from './utils/debugData';
  import { ReceiveNUI } from "./utils/ReceiveNUI";
  import { debugMode, visibility, resourceStore, playerListStore, curPlayerDataStore } from "./store/stores";
  import { onMount } from "svelte";
  import DebugBrowser from "./Components/DebugBrowser.svelte";
  
  debugData([
    {
      action: 'browser',
      data: {
        browser: true,
      },
    },
  ]);

  ReceiveNUI("browser", (data) => {
   $debugMode = data.browser;
   if (data.browser) {
    console.log("browser mode enabled");
    $visibility = true;
    window.addEventListener('keyup', (e) => {
      if (e.key === '=') {
        $visibility = true;
      }
    });
   } else {
     console.log("browser mode disabled");
     window.removeEventListener('keyup', (e) => {
      if (e.key === '=') {
        $visibility = true;
      }
   });
   }
  });

  ReceiveNUI('DevMenu', (data) => {
    $visibility = data.show;
  });

  ReceiveNUI('updateResourceList', (data) => {
    $resourceStore = data.resources;
  });


  let WindowHeight;
  let WindowWidth;
  let WindowLeft;
  let WindowTop;


  ReceiveNUI('updatePlayerList', (data) => {
    $playerListStore = data.players;
  });

  ReceiveNUI('updatePlayerData', (data) => {
        $curPlayerDataStore = data;
    });
</script>

<VisibilityProvider>

<!-- PUT STUFF HERE  -->
<MovableWin 
  bind:WindowHeight={WindowHeight}  
  bind:WindowWidth={WindowWidth}
  bind:WindowLeft={WindowLeft}
  bind:WindowTop={WindowTop}
  />

</VisibilityProvider>

{#if $debugMode}
  <DebugBrowser />
{/if}
