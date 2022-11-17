<script lang="ts">
  import Drawer from "./components/Drawer.svelte";
  import VisibilityProvider from "./providers/VisibilityProvider.svelte";
  import { visibility } from "./store/stores";
  import { debugData } from "./utils/debugData";
  import { ReceiveNUI } from "./utils/ReceiveNUI";

  ReceiveNUI("DevMenu", (data) => {
    visibility.set(data.show);
  });
</script>

<VisibilityProvider>

<!-- PUT STUFF HERE  -->
  <Drawer />

</VisibilityProvider>
