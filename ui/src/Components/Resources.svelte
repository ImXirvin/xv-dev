<script lang="ts">
    import { resourceStore, listenEsc } from '../store/stores';
    import {tippy} from 'svelte-tippy';
    import 'tippy.js/dist/tippy.css';
    import { tooltip } from "../utils/tooltip";
    import { SendNUI } from '../utils/SendNUI';
    import { LuaHandler } from "../utils/luaHandler";
    import { ReceiveNUI } from '../utils/ReceiveNUI';
    import { AceEditor } from 'svelte-ace';
    import { themeStore } from "../store/stores";
    import "brace/mode/lua";
    import "brace/mode/text";
    import "brace/mode/json";
    import "brace/mode/javascript";
    import "brace/mode/html";
    import "brace/mode/css";

    import "brace/theme/clouds_midnight";
    import "brace/theme/merbivore_soft";
    import "brace/theme/tomorrow_night";
    import "brace/theme/tomorrow_night_eighties";
    import "brace/theme/twilight";
    import "brace/theme/vibrant_ink";
    
    const luaHandler = new LuaHandler();
    const tt = tooltip;

    let quickSearcTerm = '';
    let quickSearchResults = [];
    let autoRestart = false;
    let openEdit = false;
    let quickSearchFile = '';
    let quickSearchFileResults = [];
    let resourceFiles = [];
    let showEditor = false;
    let resourceEdittingContent = '';
    let resourceEdittingLang = '';
    let resourceEditting = '';
    let resourceEdittingRoute = '';
    let allowedLangs = {
        lua: 'lua',
        js: 'javascript',
        json: 'json',
        html: 'html',
        css: 'css',
        txt: 'text',
    }

    ReceiveNUI('LoadFiles', (data) => {
        // console.log(data)
        resourceFiles = data.resourceFiles;
    })

    ReceiveNUI('LoadData', (data) => {
        // console.log('LoadData')
        // console.log(data)
        resourceEdittingContent = data.data;
        resourceEditting = data.resource
        let route = data.route;
        // console.log(route, 'route')
        let index = route.lastIndexOf('.');
        resourceEdittingLang = route.slice(index + 1);
        if (allowedLangs[resourceEdittingLang]) {
            resourceEdittingLang = allowedLangs[resourceEdittingLang];
        } else {
            resourceEdittingLang = 'text';
        }
        // console.log(resourceEdittingLang)
    })

    $: if (showEditor) {
        $listenEsc = false
        //listen for escape key then close editor
        window.addEventListener('keyup', (e) => {
            if (e.key === 'Escape') {
                showEditor = false;
                $listenEsc = true
            }
        })
    } else {
        $listenEsc = true
        window.removeEventListener('keyup', (e) => {
            if (e.key === 'Escape') {
                showEditor = false;
                $listenEsc = true
            }
        })
    }

    $: if (openEdit) {
        $listenEsc = false
        //listen for escape key then close editor
        window.addEventListener('keyup', (e) => {
            if (e.key === 'Escape') {
                openEdit = false;
                $listenEsc = true
            }
        })
    } else {
        $listenEsc = true
        window.removeEventListener('keyup', (e) => {
            if (e.key === 'Escape') {
                openEdit = false;
                $listenEsc = true
            }
        })
        resourceEditting = '';
        resourceEdittingRoute = '';
        resourceEdittingContent = '';
        resourceEdittingLang = '';
    }

    $: {
        if (quickSearchFile.length > 0) {
            quickSearchFileResults = resourceFiles.filter((file) => {
                if (file) {
                    return file.toLowerCase().includes(quickSearchFile.toLowerCase())
                }
                return file.toLowerCase().includes(quickSearchFile.toLowerCase())
            })
            // console.log(searchResults)
        } else {
            quickSearchFileResults = resourceFiles;
        }
    }

    
    $: {
        if (quickSearcTerm.length > 0) {
            quickSearchResults = $resourceStore.filter((func) => {
                if (func.name) {
                    return func.name.toLowerCase().includes(quickSearcTerm.toLowerCase())
                }
                return func.code.toLowerCase().includes(quickSearcTerm.toLowerCase())
            })
            // console.log(searchResults)
        } else {
            quickSearchResults = $resourceStore;
        }
    }

    function refreshList() {
        SendNUI('UpdateResourceList')
    }

    let colour = {
        "started": 'bg-green-500',
        "stopped": 'bg-red-500',
        "error": 'bg-yellow-500',
    }

    function saveEdit() {
        SendNUI('SaveResource', {
            resource: resourceEditting,
            route: resourceEdittingRoute,
            content: resourceEdittingContent,
            autoRestart: autoRestart,
        })
        showEditor = false;
    }

    //get data for file from server
    function getData() { 
        SendNUI('getFileData', {
            resource: resourceEditting,
            route: resourceEdittingRoute,
        })
    }

    function clickEdit(resource) {
        SendNUI('clickEdit', {
            resource: resource,
        })
    }




</script>

<div class="w-full h-full flex flex-col gap-5 z-0">
    <span class="relative flex flex-row gap-2">
        <input bind:value={quickSearcTerm} class=" relative h-[3rem] rounded-md variable-input leading-6 px-2" placeholder="Search for a resource" />
        <button class="sec"
        use:tippy={{content: tt.refreshList, placement: "right"}}
        on:click={refreshList}
        >
            <i class="fa-solid fa-arrows-rotate"></i>
        </button>
        <span class="absolute right-0 flex flex-row items-center gap-2">
            <p class=" relative h-[3rem] rounded-md variable-input px-2 grif place-items-center">AutoRestart on Edit</p>
            <button class="sec" class:prio={autoRestart}
            use:tippy={{content: tt.toggleAutoRestart , placement: "left"}}
            on:click={() => autoRestart = !autoRestart}
            >
                <i class="fa-solid fa-check"></i>
            </button>
        </span>
    </span>
    <ul
        class="flex flex-col gap-2 overflow-y-auto scroll-style"
        style="height: calc(100% - 3rem);"
    >
        {#each quickSearchResults as res}
            <li class="flex flex-col rounded-md h-fit gap-2 items-center variable-input p-2 item">
                <span class="flex flex-row items-center gap-2 relative">
                    <span class='w-4 h-4 rounded-full {colour[res.status]}'></span>
                    <span>{res.name}</span>
                </span>
                <span class="text-L text-gray-400 relative">
                    {#if res.description}
                        {res.description}
                    {:else}
                        No description
                    {/if}
                </span>
                <span class="flex flex-row gap-2 relative">
                    <span class="text-L text-gray-400 relative">
                        {#if res.author}
                            {res.author}
                        {:else}
                            No author
                        {/if}
                    </span>
                    <span class="text-L text-gray-400 relative">
                        {#if res.version}
                            Version: {res.version}
                        {:else}
                            No version
                        {/if}
                    </span>
                </span>
                <span class="options">
                    {#if res.status == 'stopped'}
                        <button class="def"
                        use:tippy={{content: tt.startResource, placement: "top"}}
                        on:click={()=>luaHandler.ResourceManage(res.name, 'start')}
                        >
                            <i class="fa-solid fa-play"></i>
                        </button>
                    {:else}
                        <button class="def"
                        use:tippy={{content: tt.stopResource, placement: "top"}}
                        on:click={()=>luaHandler.ResourceManage(res.name, 'stop')}
                        >
                            <i class="fa-solid fa-stop"></i>
                        </button>
                    {/if}
                    <button class="def"
                    use:tippy={{content: tt.restartResource, placement: "top"}}
                    on:click={()=>luaHandler.ResourceManage(res.name, 'restart')}
                    >
                        <i class="fa-solid fa-arrows-rotate"></i>
                    </button>

                    <button class="def"
                    use:tippy={{content: tt.editResource, placement: "top"}}
                    on:click={()=>{openEdit = true; resourceEditting = res.name; clickEdit(res.name)}}
                    >
                        <i class="fa-solid fa-pen"></i>
                    </button>
                </span>
            </li>
        {/each}
    </ul>

    {#if openEdit}
        <div class="w-full absolute left-0 top-0 h-full flex flex-col gap-5 z-0 bg-[rgba(0,0,0,0.5)] rounded-xl grid place-items-center ">
            <div class="min-w-[30rem] h-[40rem] rounded-xl bg-[#1e1e1e] overflow-hidden">
                <span class="relative flex flex-row gap-2 w-full items-center justify-center m-5">
                    <input bind:value={quickSearchFile} class=" relative h-[3rem] rounded-md variable-input leading-6 px-2" placeholder="Search for a file" />
                    <button class="sec relative"
                    use:tippy={{content: tt.closeFileList, placement: "top"}}
                    on:click={()=>openEdit = false}
                    >
                        <i class="fa-solid fa-multiply"></i>
                    </button>
                </span>
                <ul class="flex flex-col gap-2 overflow-y-auto scroll-style" style="height: calc(100% - 3rem);">
                    {#each quickSearchFileResults as file}
                        <li class="flex flex-col rounded-md h-fit gap-2 items-center variable-input p-2 item m-1">
                            <span class="flex flex-row items-center gap-2 relative">
                                <span class="text-[2rem] text-gray-400 relative">
                                    {file}
                                </span>
                            </span>
                            <span class="options">
                                <button class="def"
                                use:tippy={{content: tt.editFile, placement: "top"}}
                                on:click={()=>{
                                    showEditor = true; 
                                    resourceEdittingRoute = file; 
                                    getData();}}
                                >
                                    <i class="fa-solid fa-pen"></i>
                                    EDIT
                                </button>
                            </span>
                        </li>
                    {/each}
            </div>
        </div>
    {/if}
</div>

{#if showEditor}
    <div class="w-full absolute left-0 top-0 h-full flex flex-col gap-5 z-0 bg-[rgba(0,0,0,0.5)] rounded-xl grid place-items-center ">
        <AceEditor
        width='90%'
        height='90%'
        lang="{resourceEdittingLang}"
        theme="{$themeStore}"
        bind:value={resourceEdittingContent} 
      />
      <span class="flex flex-row gap-2 w-full items-center justify-center bottom-2 absolute">
        <button class="def relative"
        use:tippy={{content: tt.saveFile, placement: "top"}}
        on:click={()=>{saveEdit(); showEditor = false}}
        >
            <i class="fa-solid fa-save"></i>
            SAVE
        </button>
        <button class="def relative"
        use:tippy={{content: tt.closeEditor, placement: "top"}}
        on:click={()=>showEditor = false}
        >
            <i class="fa-solid fa-multiply"></i>
            CLOSE
        </button>
    </div>
{/if}





<style>


.options {
        opacity: 0;
        height: 0px;
        margin-top: 0;
        transition: all ease-in-out 0.1s;
    }


    .item:hover > .options {
        opacity: 1;
        height: auto;
        margin-top: 1rem;
    }

</style>