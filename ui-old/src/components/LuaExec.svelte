<script lang="ts">
    import { SendNUI } from "../utils/SendNui";
    import { tooltip } from "../utils/tooltip";
    import Console from "./Console.svelte";
    import { execLuaRaw,  } from "../utils/luaHandler";
    import { luaCode } from "../store/stores";

    //monaco editor
    import type monaco from 'monaco-editor';
    import { onMount } from 'svelte';
    import luaWorker from 'monaco-editor/esm/vs/language/typescript/ts.worker?worker';

    let editor: monaco.editor.IStandaloneCodeEditor;
    let editorContainer: HTMLElement;
    let inEditor:boolean = false;
    let eventType: string;
    let hideOnExec: boolean = false;
    let wordWrap: boolean = true;

    //bind value of editor to luaCode store
    $: if (editor) {
        editor.onDidChangeModelContent((e) => {
            luaCode.set(editor.getValue());
        });
    }

    onMount(async () => {
        inEditor = true;
        self.MonacoEnvironment = {
            getWorker: function (_moduleId: any) {
                return new luaWorker();
            }
        };
        const monaco = await import('monaco-editor');
        editor = monaco.editor.create(editorContainer, {
            value: $luaCode,
            language: 'lua',
            theme: 'vs-dark',
            automaticLayout: true,
            fontSize: 14,
            fontFamily: 'JetBrains Mono',
            // make the font Mono
            fontLigatures: true,
            letterSpacing: 1,
            minimap: {
                enabled: false
            },
            lineNumbers: 'on',
            lineNumbersMinChars: 2,
            scrollBeyondLastLine: false,
            wordWrap: wordWrap,
            wordWrapColumn: 80,
            wordWrapMinified: true,
            wrappingIndent: 'indent',
            wrappingStrategy: 'advanced',
            renderWhitespace: 'none',
            renderControlCharacters: false,
            renderIndentGuides: false,
            renderLineHighlight: 'none',
            renderFinalNewline: true,
            overviewRulerBorder: false,
            overviewRulerLanes: 0,
            cursorBlinking: 'smooth',
            cursorSmoothCaretAnimation: true,
            cursorStyle: 'line',
            cursorWidth: 2,
            hideCursorInOverviewRuler: true,
            mouseWheelZoom: true,
            mouseWheelScrollSensitivity: 1,
            multiCursorModifier: 'ctrlCmd',
            multiCursorMergeOverlapping: true,
            multiCursorPaste: 'spread',
            accessibilitySupport: 'auto',
            quickSuggestions: true,
            quickSuggestionsDelay: 10,
            parameterHints: true,
            suggestOnTriggerCharacters: true,
            colorDecorators: true,
            folding: true,
            acceptSuggestionOnEnter: 'on',
            acceptSuggestionOnCommitCharacter: true,
            snippetSuggestions: 'inline',
            wordBasedSuggestions: true,
            suggestSelection: 'recentlyUsed',
            suggestFontSize: 14,
            suggestLineHeight: 20,
            suggest: {
                localityBonus: true,
                shareSuggestSelections: true,
                showIcons: true,
                showMethods: true,
                showFunctions: true,
                showConstructors: true,
                showFields: true,
                showVariables: true,
                showProperties: true,
                showEvents: true,
                showUnits: true,
                showValues: true,
                showConstants: true,
                showKeywords: true,
                showWords: true,
                showColors: true,
                showReferences: true,
            }
        });

        return () => {
            editor.dispose();
        };
    });

    function execLua() {
        // SendNUI("ExecuteLua", {code: $luaCode, eventType: eventType, });
        execLuaRaw($luaCode, eventType);
        if (hideOnExec) {
            SendNUI("hideUI");
        }
    }

    $: if (editor) {
        editor.updateOptions({ wordWrap: wordWrap ? 'on' : 'off' });
    }


</script>

<div class="w-[100%] h-full self-end relative text-center gap-0 flex flex-col overflow-y-scroll">

    <div class="w-[95%] h-full rounded-[1rem] mx-5">
        <div bind:this={editorContainer}  class="w-full text-start h-full p-1 word-wrap code-editor" class:not-word-wrap={!wordWrap} placeholder="Enter Lua code here">    </div>
    </div>

    <span class="flex flex-row px-5 gap-5 mt-5 ">    
        <button on:click={execLua} class="selection">
            EXECUTE
            <span class="fas fa-play use-selection text-[2rem]" ></span>
        </button>
        <select bind:value={eventType} class="selection">
            <option value="client">Client</option>
            <option value="server">Server</option>
        </select>

        <i on:click={()=>{hideOnExec=!hideOnExec}} class:toggle-on={hideOnExec} use:tooltip title="Toggle Hide On Execute" class="fa-solid fa-eye-slash selection grid place-items-center w-auto h-auto toggle-on"></i>
        <i on:click={()=>{wordWrap=!wordWrap}} class:toggle-on={wordWrap} class="selection grid place-items-center w-auto h-auto toggle-on "><i use:tooltip title="Toggle Word-Wrap" class="bi bi-text-wrap text-[2rem]"></i></i>
    </span>

    <Console/>
</div>

<!-- on:keydown={handleTab} bind:value={$luaCode} -->
<style>

    *::-webkit-scrollbar {
        display: none;
    }


    .code-editor {
        resize: none;
        background-color: var(--color-secondary);
        color: var(--color-tertiary);
        font-family: monospace, monospace;
    }

    .word-wrap {
        white-space: pre-wrap;
    }

    .not-word-wrap {
        white-space: pre;
    }

    textarea:focus {
        outline: none;
    }


    .selection {
        /* background-color: var(--color-secondary); */
        color: var(--color-tertiary);
        font-weight: bold;
        font-size: 1.5rem;
        /* border: 1px solid var(--color-tertiary); */
        border-radius: 0.5rem;
        letter-spacing: 1px;
        background-color: var(--color-secondary);
        padding: 0.5rem;
    }

    .text {
        color: var(--color-tertiary);
        font-weight: bold;
        font-size: 1.5rem;
        letter-spacing: 1px;
    }

    .use-selection {
        color: var(--color-tertiary);
    }

    .selection:hover {
        color: var(--color-tertiary);
        filter: drop-shadow(0 0 0.5rem var(--color-tertiary));
    }

    .toggle-on {
        border: 2px solid var(--color-tertiary);
    }

</style>