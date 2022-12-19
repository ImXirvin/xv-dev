<script lang="ts">
    import { themeStore } from '../store/stores';
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../utils/tooltip";
    const tt = tooltip;
</script>

<div class="w-full h-full flex flex-col gap-5 z-0">
    <div>
        <h1 class="text-start font-bold text-white">Theme</h1>
        <select bind:value={$themeStore} class="btn-def"
        use:tippy={{content: tt.theme, placement: 'top'}}
        >
            <option value="clouds_midnight">clouds_midnight</option>
            <option value="merbivore_soft">merbivore_soft</option>
            <option value="tomorrow_night">tomorrow_night</option>
            <option value="tomorrow_night_eighties">tomorrow_night_eighties</option>
            <option value="twilight">twilight</option>
            <option value="vibrant_ink">vibrant_ink</option>
        </select>
        
    </div>

</div>