<script lang="ts">
    import { AceEditor } from "svelte-ace";
    import "brace/mode/lua";
  //import all brace dark themes

  //clouds_midnight
  //merbivore_soft
  //tomoorrow_night
  //tomorrow_night_eighties
  //twilight
  //vibrant_ink

  import "brace/theme/clouds_midnight";
  import "brace/theme/merbivore_soft";
  import "brace/theme/tomorrow_night";
  import "brace/theme/tomorrow_night_eighties";
  import "brace/theme/twilight";
  import "brace/theme/vibrant_ink";
    let text = "local if = 1 'aiujsbdnjiuas'";
  </script>
   
  <AceEditor
    on:selectionChange={(obj) => console.log(obj.detail)}
    on:paste={(obj) => console.log(obj.detail)}
    on:input={(obj) => console.log(obj.detail)}
    on:focus={() => console.log('focus')}
    on:documentChange={(obj) => console.log(`document change : ${obj.detail}`)}
    on:cut={() => console.log('cut')}
    on:cursorChange={() => console.log('cursor change')}
    on:copy={() => console.log('copy')}
    on:init={(editor) => console.log(editor.detail)}
    on:commandKey={(obj) => console.log(obj.detail)}
    on:changeMode={(obj) => console.log(`change mode : ${obj.detail}`)}
    on:blur={() => console.log('blur')}
    width='100%'
    height='100%'
    lang="lua"
    theme="xcode"
    value={text} 
    isDark={true}/>

  <style>
  
  </style>