<script lang="ts">
  import MovableWin from "./Components/MovableWin.svelte";
  import VisibilityProvider from "./providers/VisibilityProvider.svelte";
  import { debugData } from './utils/debugData';
  import { ReceiveNUI } from "./utils/ReceiveNUI";
  import { debugMode, visibility } from "./store/stores";
  
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
   } else {
     console.log("browser mode disabled");
   }
  });

  ReceiveNUI('DevMenu', (data) => {
    $visibility = data.show;
  });
</script>

<VisibilityProvider>

<!-- PUT STUFF HERE  -->
<MovableWin />

</VisibilityProvider>
