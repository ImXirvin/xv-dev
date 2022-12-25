<script lang="ts">
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../utils/tooltip";
    import { SendNUI } from '../utils/SendNUI';
    import { ReceiveNUI } from '../utils/ReceiveNUI';
    import { playerListStore, curPlayerDataStore } from '../store/stores';
  import PInfo from './Playertabs/PInfo.svelte';
  import PActions from './Playertabs/PActions.svelte';
  import { onMount } from 'svelte';

    const tt = tooltip;

    let quickSearcTerm = "";
    let quickSearchResults = [];
    $: {
        if (quickSearcTerm.length > 0) {
            quickSearchResults = $playerListStore.filter((player) => {
                return player.name.toLowerCase().includes(quickSearcTerm.toLowerCase()) || player.id.toString().toLowerCase().includes(quickSearcTerm.toLowerCase());
            });
        } else {
            quickSearchResults = $playerListStore;
        }
    }

    function refreshPlayerList() {
        SendNUI("GetPlayers");
    }

    ReceiveNUI("UpdatePlayerList", (data) => {
        $playerListStore = data.players;
        // console.log("player list updated", $playerListStore)
        if (!initialLoad) {
            initialLoad = true;
            let initialPlayerID = $playerListStore[0].id;
            // console.log('initialPlayerID', initialPlayerID)
            getPlayerData(initialPlayerID);
        }
    });
    let initialLoad = false;
    onMount(() => {
        refreshPlayerList();
    });

    function getPlayerData(id) {
        stopPlayerData()
        SendNUI("startGetPlayerData", {id: id})
    }

    function stopPlayerData() {
        SendNUI("stopGetPlayerData");
    }

    let tabs = [
        {
            "name": "Info",
            "component": PInfo,
        },
        {
            "name": "Actions",
            "component": PActions,
        }
    ]
    let activeTab = tabs[0].component;


</script>


<div class="w-full h-full flex flex-col gap-5 z-0 min-w-[30rem]">
    <span class="relative flex flex-row gap-2">
        <input bind:value={quickSearcTerm} class=" relative h-[3rem] rounded-md variable-input leading-6 px-2" placeholder="Search Name or ID" />
        <button class="sec"
        use:tippy={{content: tt.refreshPlayers, placement: "right"}}
        on:click={refreshPlayerList}
        >
            <i class="fa-solid fa-arrows-rotate"></i>
        </button>
    </span>
    <div class="h-full flex flex-row gap-2 overflow-scroll scroll-style scroll-y">
        <ul class="player-list h-full flex flex-col gap-2 overflow-scroll scroll-style scroll-y">
            {#each quickSearchResults as player}
                <li class="player-item btn-sec max-w-[20rem] h-[3rem] flex flex-row gap-2 items-center"
                    on:click={()=>getPlayerData(player.id)}
                    use:tippy={{content: tt.managePlayer, placement: "right"}}
                    >
                    <div class="sec w-[4rem] h-full flex flex-row items-center justify-center">
                        <span class="text-md">{player.id}</span>
                    </div>
                    <div class="player-name sec w-full text-start px-8 h-full flex flex-row items-center justify-start relative overflow-hidden">
                        <span class="text-md text-start">{player.name}</span>
                    </div>
                </li>
            {/each}
        </ul>
        <div class="player-data flex flex-col gap-2 w-full h-full">
            {#if $curPlayerDataStore}
            <div class="player-data-header flex flex-row gap-2">
                <div class="player-data-header-item sec w-[4rem] h-[3rem] flex flex-row items-center justify-center">
                    <span class="text-md">{$curPlayerDataStore.id}</span>
                </div>
                {#each tabs as tab}
                    <button class:def={activeTab == tab.component ? true : false}
                        class:sec={activeTab == tab.component ? false : true}
                        on:click={()=>{activeTab = tab.component}}
                        class="player-data-header-item min-w-fit px-2 h-[3rem] flex flex-row items-center justify-center">
                        <span class="text-md">{tab.name}</span>
                    </button>
                {/each}
                <div class="player-data-header-item sec w-full h-[3rem] flex flex-row items-center justify-center">
                    <span class="text-md">{$curPlayerDataStore.name}</span>
                </div>
                <button class="sec player-data-header-item btn-sec w-[4rem] h-[3rem] flex flex-row items-center justify-center" on:click={stopPlayerData}>
                    <i class="fa-solid fa-x"></i>
                </button>
            </div>
                <svelte:component this={activeTab} />
            {:else}
                <div class="w-full h-full grid place-items-center">
                    <i class="fa-solid fa-gear fa-spin text-white fa-2x"></i>
                </div>
            {/if}
        </div>
    </div>

</div>


<style>
    .player-list {
        width: 6rem;
        transition: width 0.2s ease-in-out;
    }
    .player-list > .player-item > .player-name {
        display: none;
    }
    .player-list:hover {
        width: 20rem;
    }
    .player-list:hover > .player-item > .player-name {
        display: flex;
    }

    .player-data-body-item {
        position: relative;
        margin: 0;
        padding: 0;
    }
</style>