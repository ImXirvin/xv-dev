<script lang="ts">

    let isOpen = true;
    export let selectedComponent;

    let options =  [
        {
            name: "Lua Executor",
            icon: "fas fa-terminal",
        //   component: LuaExec,
        },
        {
            name: "Quick Functions",
            icon: "fas fa-bolt",
        //   component: QuickFunc,
        },
        {
            name: "History",
            icon: "fas fa-history",
        //   component: History,
        },
    ];
    let selected = options[0]

</script>

<nav class="navbar">
    <ul class="navbar-nav gap-2">
        <li class=" nav-item">
            <p href="#" class="top-item">
              <span class="link-text logo-text">Components</span>
              <i class="fas fa-bars"></i>
            </p>
        </li>
        {#each options as option}
            <li class="nav-item">
                <p class="nav-link" on:click={() => selected = option}>
                    <i class="{option.icon}"></i>
                    <span class="link-text  ">{option.name}</span>
                </p>
            </li>
        {/each}
    </ul>
</nav>

<style>
    .navbar::-webkit-scrollbar {
        display: none;
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
  transition: width 600ms ease;
  overflow: scroll;
}

.navbar-nav {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  /* height: 100%; */
  position: relative;
}

.nav-item {
  width: 100%;
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
  margin-left: 1rem;
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


.logo-text
{
  display: inline;
  position: absolute;
  left: -999px;
  transition: var(--transition-speed);
}



.navbar {
    top: 0;
    left:0;
    width: 5rem;
    height: 100%;
    border-radius: 1rem;
  }

  .navbar:hover {
    width: 20rem;
  }

  .navbar:hover .link-text {
    display: inline;
  }



  .navbar:hover .logo-text
  {
    left: 3rem;
  }


</style>

