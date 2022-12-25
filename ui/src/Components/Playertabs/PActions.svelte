<script lang="ts">
    import { AceEditor } from "svelte-ace";
import { curPlayerDataStore, themeStore } from "../../store/stores";
    import { SendNUI } from "../../utils/SendNUI";
    import { LuaHandler } from "../../utils/luaHandler";

    const luaHandler = new LuaHandler();

    $: plyID = $curPlayerDataStore.id;

    let plyOptions = [
        {
            "name": "Teleport To",
            "action": () => {
                SendNUI("playerAction", {action: 'tpToPlayer',id: plyID})
            },
        },
        {
            "name": "Teleport To Me",
            "action": () => {
                SendNUI("playerAction", {action: 'tpToMe',id: plyID})
            }
        },
        {
            "name": "Teleport To Coords",
            "action": () => {
                openCoords = true;
            }
        },
        {
            "name": "Spawn Vehicle",
            "action": () => {
                openVehicle = true;
            }
        },
        {
            "name": "Delete Vehicle",
            "action": () => {
                SendNUI("playerAction", {action: 'deleteVehiclePlayer',id: plyID})
            }
        },
        {
            "name": "Freeze",
            "action": () => {
                SendNUI("playerAction", {action: 'freezePlayer',id: plyID})
            }
        },
        {
            "name": "Unfreeze",
            "action": () => {
                SendNUI('playerAction', {action: 'unfreezePlayer',id: plyID})
            }
        },
    ]

    function execLua() {
        luaHandler.ExecuteLua(code, 'source', plyID);
    }

    let openCoords = false;
    let coordsString = '';
    function coordsModal() {
        SendNUI("playerAction", {action: 'tpToCoords',id: plyID, coords: coordsString})
    }

    let openVehicle = false
    let vehicle = '';
    function vehicleModal() {
        SendNUI("playerAction", {action: 'spawnVehicleForPlayer',id: plyID, vehicle: vehicle})
    }

    let openKick = false;
    let kickReason = '';
    function kickModal() {
        SendNUI("kickPlayer", {id: plyID, reason: kickReason})
    }

    let openBan = false;
    let banReason = '';
    function banModal() {
        SendNUI("banPlayer", {id: plyID, reason: banReason})
    }


    let code = '';
</script>


<div class="w-full h-full flex flex-col gap-2">
    <div class="player-data-header flex flex-row gap-2 w-full min-w-[20rem]">
        <button class="def text-white px-2 py-1 rounded-md w-full" 
            on:click={()=>openKick = true}
        >
        Kick
        <i class="fa-solid fa-right-from-bracket"></i>
        </button>
        <button class="def text-white px-2 py-1 rounded-md w-full " 
            on:click={()=>openBan = true}
        >
        Ban
        <i class="fa-solid fa-right-from-bracket"></i>
        </button>
    </div>
    <div class="player-data-body flex flex-col gap-2 h-full w-full">
        <div class="player-actions-list w-full gap-2 flex flex-row h-fit justify-center flex-grow overflow-x-scroll overflow-y-hidden scroll-style">
            {#each plyOptions as option}
                <button class="sec text-white px-2 py-1 rounded-md relative w-full min-w-[1rem] mr-1" 
                    on:click={()=>option.action()}
                >
                {option.name}
                </button>
            {/each}
            <button class="prio text-white px-2 py-1 rounded-md relative w-full mr-1" 
                on:click={() => {
                   execLua()
                }}>
            Execute
            </button>
        </div>
        <div class="player-data-body-item w-full h-full flex flex-row items-center justify-center">
            <AceEditor
                class="w-full h-full"
                lang="lua"
                theme="{$themeStore}"
                bind:value={code}
                />
        </div>
    </div>
</div>

<!-- I GOT LAZY SORRY LOL  -->
{#if openVehicle}
<div class="w-full absolute left-0 top-0 h-full flex flex-col gap-5 z-10 bg-[rgba(0,0,0,0.5)] rounded-xl grid place-items-center ">
    <div class="min-w-[30rem] h-fit p-2 flex flex-col gap-2 px-2 bg-[#1e1e1e] rounded-xl overflow-hidden">
        <span class="relative flex flex-row gap-2 w-full items-center justify-end my-5">
            <p class="text-white absolute text-center w-full text-[2rem] font-bold">Spawn Vehicle</p>
            <button class="sec relative  justify-self-end right-0"
            on:click={()=>openVehicle = false}
            >
                <i class="fa-solid fa-multiply"></i>
            </button>
        </span>
        <div class="player-data-body flex flex-col gap-2 h-full w-full">
            <div class="player-actions-list w-full gap-2 flex flex-row h-fit justify-center flex-grow">
                <input class="sec variable-input px-2 py-1 rounded-md relative w-full" 
                    bind:value={vehicle}
                    placeholder="Model Name"
                >
            </div>
            <div class="player-data-body-item w-full h-full flex flex-row items-center justify-center">
                <button class="prio text-white px-2 py-1 rounded-md relative w-full mr-1" 
                    on:click={() => {
                        vehicleModal()
                        openVehicle = false
                    }}>
                Spawn Vehicle
                </button>
            </div>
        </div>
    </div>
</div>
{/if}

{#if openCoords}
<div class="w-full absolute left-0 top-0 h-full flex flex-col gap-5 z-10 bg-[rgba(0,0,0,0.5)] rounded-xl grid place-items-center ">
    <div class="min-w-[30rem] h-fit p-2 flex flex-col gap-2 px-2 bg-[#1e1e1e] rounded-xl overflow-hidden">
        <span class="relative flex flex-row gap-2 w-full items-center justify-end my-5">
            <p class="text-white absolute text-center w-full text-[2rem] font-bold">Teleport</p>
            <button class="sec relative  justify-self-end right-0"
            on:click={()=>openCoords = false}
            >
                <i class="fa-solid fa-multiply"></i>
            </button>
        </span>
        <div class="player-data-body flex flex-col gap-2 h-full w-full">
            <div class="player-actions-list w-full gap-2 flex flex-row h-fit justify-center flex-grow">
                <input class="sec variable-input px-2 py-1 rounded-md relative w-full" 
                    bind:value={coordsString}
                    placeholder="Coords"
                >
            </div>
            <div class="player-data-body-item w-full h-full flex flex-row items-center justify-center">
                <button class="prio text-white px-2 py-1 rounded-md relative w-full mr-1" 
                    on:click={() => {
                        coordsModal()
                        openCoords = false
                    }}>
                Teleport
                </button>
            </div>
        </div>
    </div>
</div>
{/if}

{#if openKick}
<div class="w-full absolute left-0 top-0 h-full flex flex-col gap-5 z-10 bg-[rgba(0,0,0,0.5)] rounded-xl grid place-items-center ">
    <div class="min-w-[30rem] h-fit p-2 flex flex-col gap-2 px-2 bg-[#1e1e1e] rounded-xl overflow-hidden">
        <span class="relative flex flex-row gap-2 w-full items-center justify-end my-5">
            <p class="text-white absolute text-center w-full text-[2rem] font-bold">Kick</p>
            <button class="sec relative  justify-self-end right-0"
            on:click={()=>openKick = false}
            >
                <i class="fa-solid fa-multiply"></i>
            </button>
        </span>
        <div class="player-data-body flex flex-col gap-2 h-full w-full">
            <div class="player-actions-list w-full gap-2 flex flex-row h-fit justify-center flex-grow">
                <input class="sec variable-input px-2 py-1 rounded-md relative w-full" 
                    bind:value={kickReason}
                    placeholder="Reason"
                >
            </div>
            <div class="player-data-body-item w-full h-full flex flex-row items-center justify-center">
                <button class="prio text-white px-2 py-1 rounded-md relative w-full mr-1" 
                    on:click={() => {
                        kickModal()
                        openKick = false
                    }}>
                Kick
                </button>
            </div>
        </div>
    </div>
</div>
{/if}

{#if openBan}
<div class="w-full absolute left-0 top-0 h-full flex flex-col gap-5 z-10 bg-[rgba(0,0,0,0.5)] rounded-xl grid place-items-center ">
    <div class="min-w-[30rem] h-fit p-2 flex flex-col gap-2 px-2 bg-[#1e1e1e] rounded-xl overflow-hidden">
        <span class="relative flex flex-row gap-2 w-full items-center justify-end my-5">
            <p class="text-white absolute text-center w-full text-[2rem] font-bold">Ban</p>
            <button class="sec relative  justify-self-end right-0"
            on:click={()=>openBan = false}
            >
                <i class="fa-solid fa-multiply"></i>
            </button>
        </span>
        <div class="player-data-body flex flex-col gap-2 h-full w-full">
            <div class="player-actions-list w-full gap-2 flex flex-row h-fit justify-center flex-grow">
                <input class="sec variable-input px-2 py-1 rounded-md relative w-full" 
                    bind:value={banReason}
                    placeholder="Reason"
                >
            </div>
            <div class="player-data-body-item w-full h-full flex flex-row items-center justify-center">
                <button class="prio text-white px-2 py-1 rounded-md relative w-full mr-1" 
                    on:click={() => {
                        banModal()
                        openBan = false
                    }}>
                Ban
                </button>
            </div>
        </div>
    </div>
</div>
{/if}