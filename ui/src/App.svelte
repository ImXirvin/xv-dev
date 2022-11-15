<script lang="ts">
  import VisibilityProvider from "./providers/VisibilityProvider.svelte";
  import { debugData } from './utils/debugData';
  
  debugData([
    {
      action: 'setVisible',
      data: true,
    },
  ]);

</script>

<VisibilityProvider>

<!-- PUT STUFF HERE  -->

</VisibilityProvider>
