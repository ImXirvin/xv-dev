<script>
    import { variablesStore } from "../store/stores";

    function addVar() {
        // variablesStore.update((vars) => {
        //     vars.push({
        //         value: "",
        //         global: false,
        //     });
        //     return vars;
        // });
        $variablesStore.push({
            value: "",
            global: false,
        });
        $variablesStore = [...$variablesStore];
    }
</script>




<div class="w-full h-full flex flex-col gap-5 z-0">
    <div class="variables-container relative"></div>

    
</div>