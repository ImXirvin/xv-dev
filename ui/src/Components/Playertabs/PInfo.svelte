<script lang="ts">
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../../utils/tooltip";
    import { curPlayerDataStore } from '../../store/stores';
    const tt = tooltip;

    let PlayerCoords = "";
    function handleCoords() {
        let coords = $curPlayerDataStore.coords
        let coordsString = `${coords.x}, ${coords.y}, ${coords.z}`
        PlayerCoords = coordsString;
    }
    $: if ($curPlayerDataStore.coords) {
        handleCoords();
    }

    const copyToClipboard = str => {
    const el = document.createElement('textarea');
    el.value = str;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
};

</script>


<div class="player-data-body flex flex-row gap-2 w-full h-full flex-wrap flex-shrink flex-grow items-start">
    <div class="player-data-body-item w-fit sec h-fit my-0 flex flex-col items-center justify-center">
        <div class="text-md def w-full text-center">Identifiers</div>
        {#if ($curPlayerDataStore.identifiers)}
            {#each $curPlayerDataStore.identifiers as identifier}
                <span class="text-md btn-sec w-full text-center cursor-pointer"
                    on:click={()=>{
                        copyToClipboard(identifier);
                    }}
                    use:tippy={{content: tt.copyIdentifier, placement: "right"}}
                >{identifier}</span>
            {/each}
        {/if}
    </div>
    <div class="player-data-body-item w-fit sec h-fit flex flex-col items-center justify-center">
        <div class="text-md def w-full text-center">General Information</div>
        <!-- SHow progressbar for health -->
        <div class="text-md btn-sec w-full text-center cursor-pointer">Health: {$curPlayerDataStore.health}</div>
        <div class="text-md btn-sec w-full text-center cursor-pointer" >Armour: {$curPlayerDataStore.armour}</div>
        <div class="text-md btn-sec w-full text-center cursor-pointer break-words"
            on:click={()=>{
                copyToClipboard(PlayerCoords)
            }}
            use:tippy={{content: tt.copyCoords, placement: "right"}}
            >
                Coords: {PlayerCoords}
            </div>
        <div class="text-md btn-sec w-full text-center cursor-pointer"
            on:click={()=>{
                copyToClipboard($curPlayerDataStore.heading);
            }}
            use:tippy={{content: tt.copyHeading, placement: "right"}}
        >Heading: {$curPlayerDataStore.heading}</div>
        <div class="text-md btn-sec w-full text-center cursor-pointer ">In Vehicle: {$curPlayerDataStore.inVehicle}</div>
        {#if $curPlayerDataStore.inVehicle}
            <div class="text-md btn-sec w-full text-center cursor-pointer"
                on:click={()=>{
                    copyToClipboard($curPlayerDataStore.vehicleName);
                }}
                use:tippy={{content: tt.copyVehicleName, placement: "right"}}
            
            >Vehicle: {$curPlayerDataStore.vehicleName}</div>
        {/if}
        <div class="text-md btn-sec w-full text-center cursor-pointer "
            on:click={()=>{
                copyToClipboard($curPlayerDataStore.model);
            }}
            use:tippy={{content: tt.copyModel, placement: "right"}}
        >Model: {$curPlayerDataStore.model}</div>
    </div>
</div>



<style>
    .player-data-body-item {
        position: relative;
        margin: 0;
        padding: 0;
    }
</style>