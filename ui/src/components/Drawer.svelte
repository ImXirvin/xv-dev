<script lang="ts">
      import {tippy} from 'svelte-tippy';
  import 'tippy.js/dist/tippy.css';
  import { tooltip } from "../utils/tooltip";
  const tt = tooltip;
    export let options =  [];
    export let selectedIndex;


</script>

<nav class="navbar">
    <ul class="navbar-nav gap-2">
        <li class=" nav-item">
            <p href="#" class="top-item">
              <i class="fas fa-bars"></i>
              <span class="link-text">Components</span>
            </p>
        </li>
        {#each options as option, i}
            <li use:tippy={{content: `${option.name}`, placement: "right"}} class="nav-item">
                <p class:selected={selectedIndex==i? true : false} class="nav-link" on:click={() =>selectedIndex = i }>
                    <i class="{option.icon}"></i>
                    <!-- <span class="link-text  ">{option.name}</span> -->
                </p>
            </li>
        {/each}
        <li class="w-full h-fit last-item">
          <li use:tippy={{content: `Toggle Output Menu`, placement: "right"}} class="nav-item self-end">
            <p class:selected={false} class="nav-link" on:click={() =>console.log('output')}>
              <i class="fa-solid fa-right-from-bracket"></i>
            </p>
          </li>
          <li use:tippy={{content: `Debug`, placement: "right"}} class="nav-item self-end">
            <p class:selected={false} class="nav-link" on:click={() =>console.log('debug')}>
              <i class="fas fa-bug"></i>
            </p>
          </li>
    </ul>
</nav>

<style>
    .navbar::-webkit-scrollbar {
        display: none;
    }

    .selected,
    .selected  i,
    .selected .link-text {
        background-color: transparent;
        color: var(--color-tertiary);
    }

    .selected:hover,
    .selected:hover  i,
    .selected:hover .link-text {
      color: var(--color-primary);
    }

    .top-item {
        display: flex;
        align-items: center;
        height: 5rem;
        color: var(--color-tertiary);
        text-decoration: none;
        transition: var(--transition-speed);
    }

    .top-item i {
        width: 2rem;
        min-width: 2rem;
        margin: 0 1.5rem;
    }

    :root {
    --transition-speed: 200ms;
    }

    .navbar {
  position: relative;
  background-color: var(--color-primary);
  transition: min-width 0.6s ease, width 0.6s ease, max-width 0.6s ease;
  overflow: scroll;
  min-width: fit-content;
  min-height: fit-content;
}

.navbar-nav {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 100%;
  position: relative;
}

.nav-item {
  width: 100%;
}

.last-item {
  margin-top: auto;
}


.nav-link {
  display: flex;
  align-items: center;
  height: 5rem;
  color: var(--color-tertiary);
  text-decoration: none;
  transition: var(--transition-speed);
}

.nav-link:hover
 {
  background: var(--color-tertiary);
  color: var(--color-primary);
}

.link-text {
  display: none;
  margin-left: 0rem;
  /* make it only 1 line */
    white-space: nowrap;
}

.nav-link i {
  width: 2rem;
  min-width: 2rem;
  margin: 0 1.5rem;
}

.nav-link:active { 
    background: var(--color-secondary);
    color: var(--color-tertiary);
}


.navbar {
    top: 0;
    left:0;
    width: 5rem;
    height: 100%;
    border-radius: 1rem;
  }
/* 
  .navbar:hover .link-text {
    display: inline;
  } */



  .navbar:hover .logo-text
  {
    left: 3rem;
  }


</style>

