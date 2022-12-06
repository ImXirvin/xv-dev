<script lang="ts">
  import Container from "./components/Container.svelte";
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
</script>

<VisibilityProvider>

<!-- PUT STUFF HERE  -->
<Container />

</VisibilityProvider>
