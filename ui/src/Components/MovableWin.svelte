<script>
  // @ts-ignore
  import Drawer from "../components/Drawer.svelte"
  import LuaExec from "./LuaExec.svelte";
  import Settings from "./Settings.svelte";
  import Resources from "./Resources.svelte";
  import QuickFunc from "../components/QuickFunc.svelte";
  import { outputMode } from "../store/stores";
  import Output from "./Output.svelte";
  import Players from "./Players.svelte";



	let moving = false;
	export let WindowLeft;
	export let WindowTop;
	export let WindowWidth;
	export let WindowHeight;
	let Window;


	let WindowTitle = "XV-DEV";
	

	function move(element) {
		
		return {
			destroy() {
			}
		}
	}
	
	function resize(element) {
		const right = document.createElement('div')
		right.direction = 'east'
		right.classList.add('grabber')
		right.classList.add('right')
		
		const left = document.createElement('div')
		left.direction = 'west'
		left.classList.add('grabber')
		left.classList.add('left')
		
		const top = document.createElement('div')
		top.direction = 'north'
		top.classList.add('grabber')
		top.classList.add('top')
		
		const bottom = document.createElement('div')
		bottom.direction = 'south'
		bottom.classList.add('grabber')
		bottom.classList.add('bottom')
		
		const topLeft = document.createElement('div')
		topLeft.direction = 'northwest'
		topLeft.classList.add('grabber')
		topLeft.classList.add('top-left')
		
		const topRight = document.createElement('div')
		topRight.direction = 'northeast'
		topRight.classList.add('grabber')
		topRight.classList.add('top-right')
		
		const bottomLeft = document.createElement('div')
		bottomLeft.direction = 'southwest'
		bottomLeft.classList.add('grabber')
		bottomLeft.classList.add('bottom-left')
		
		const bottomRight = document.createElement('div')
		bottomRight.direction = 'southeast'
		bottomRight.classList.add('grabber')
		bottomRight.classList.add('bottom-right')
				
		const grabbers = [right, left, top, bottom, topLeft, topRight, bottomLeft, bottomRight]
		
		let active = null, initialRect = null, initialPos = null
		
		grabbers.forEach(grabber => {
			element.appendChild(grabber)
			grabber.addEventListener('mousedown', onMousedown)
		})
		
		function onMousedown(event) {
			active = event.target
			const rect = element.getBoundingClientRect()
			const parent = element.parentElement.getBoundingClientRect()
			
			// console.log({rect, parent})
			
			initialRect = {
				width: rect.width,
				height: rect.height,
				left: rect.left - parent.left,
				right: parent.right - rect.right,
				top: rect.top - parent.top,
				bottom: parent.bottom - rect.bottom
			}
			initialPos = { x: event.pageX, y: event.pageY }
			active.classList.add('selected')
		}
		
		function onMouseup(event) {
			if (!active) return
			
			active.classList.remove('selected')
			active = null
			initialRect = null
			initialPos = null
		}
		
		function onMove(event) {
			if (!active) return
			
			const direction = active.direction
			let delta
			
			if (direction.match('east')) {
				// if (initialRect.width + (event.pageX - initialPos.x) < minWidth == false) {
					delta = event.pageX - initialPos.x
					element.style.width = `${initialRect.width + delta}px`
					WindowWidth = initialRect.width + delta;
				// }
			}
			
			if (direction.match('west')) {
				// if (initialRect.width - (event.pageX - initialPos.x) < minWidth == false) {
					delta = initialPos.x - event.pageX
					element.style.left = `${initialRect.left - delta}px`
					element.style.width = `${initialRect.width + delta}px`
					WindowLeft = initialRect.left - delta
				// }
			}
			
			if (direction.match('north')) {
				// if (initialRect.height - event.pageY + initialPos.y < minHeight == false) {
				delta = initialPos.y - event.pageY
				element.style.top = `${initialRect.top - delta}px`
				element.style.height = `${initialRect.height + delta}px`
				WindowTop = initialRect.top - delta
				// }
			}
			
			if (direction.match('south')) {
				// if (initialRect.height + event.pageY - initialPos.y < minHeight == false) {
				delta = event.pageY - initialPos.y
				element.style.height = `${initialRect.height + delta}px`
				WindowHeight = initialRect.height + delta
				// }
			}
		}
		
		window.addEventListener('mousemove', onMove)	
		window.addEventListener('mouseup', onMouseup)	
		
		return {
			destroy() {
				window.removeEventListener('mousemove', onMove)
				window.removeEventListener('mousemove', onMousedown)
				
				grabbers.forEach(grabber => {
					element.removeChild(grabber)
				})
			}
		}
	}

	let initial = false
	let restored = false
	$: if (Window && initial == false) {
		initial = true
		if (WindowHeight != null) Window.style.height = WindowHeight + 'px'
		if (WindowWidth != null) Window.style.width = WindowWidth + 'px'
		if (WindowLeft != null) Window.style.left = WindowLeft + 'px'
		if (WindowTop != null) Window.style.top = WindowTop + 'px'
		if (WindowHeight != null && WindowWidth != null && WindowLeft != null && WindowTop != null) restored = true

		if (restored == false) {

			Window.getBoundingClientRect()
			WindowHeight = Window.getBoundingClientRect().height
			WindowWidth = Window.getBoundingClientRect().width
			WindowLeft = (window.innerWidth - WindowWidth) / 2;
			WindowTop = (window.innerHeight - WindowHeight) / 2;
		}

	}


	$: if (WindowTop < 0) WindowTop = 0 //prevent window from going off the top of the screen
	$: if (WindowLeft < 0) WindowLeft = 0 //prevent window from going off the left of the screen
	$: if (WindowTop > window.innerHeight - WindowHeight) WindowTop = window.innerHeight - WindowHeight //prevent window from going off the bottom of the screen
	$: if (WindowLeft > window.innerWidth - WindowWidth) WindowLeft = window.innerWidth - WindowWidth  //prevent window from going off the right of the screen
	// $: if (WindowHeight < 100) WindowHeight = 100 //prevent window from getting too small
	// $: if (WindowWidth < 100) WindowWidth = 100 //prevent window from getting too small


	function onMouseDown() {
		moving = true;
	}

	function onMouseUp() {
		moving = false;
	}
	
	function onMouseMove(e) {
		if (moving) {
			Window.getBoundingClientRect()
			WindowHeight = Window.getBoundingClientRect().height
			WindowWidth = Window.getBoundingClientRect().width
			WindowLeft += e.movementX;
			WindowTop += e.movementY;
		}
	}

	let options =  [
        {
            "name": "Lua Executor",
            "icon": "fas fa-terminal",
            "component": LuaExec,
        },
        {
            "name": "Quick Functions",
            "icon": "fas fa-bolt",
          "component": QuickFunc,
        },
		{
			"name": "Resource List",
			"icon": "fas fa-list",
			"component": Resources,
		},
		{
			"name": "Player",
			"icon": "fas fa-user",
			"component": Players,
		},
		{
			"name": "Vehicle",
			"icon": "fas fa-car",
			// "component": Vehicle,
		},
        {
            "name": "Settings",
            "icon": "fas fa-cog",
			"component": Settings,
        },
    ];

	let selectedIndex = 0;
	// $:console.log(selectedIndex)
</script>

<svelte:window on:mouseup={onMouseUp} on:mousemove={onMouseMove} />

	<div bind:this={Window} class="Window flex flex-col" style="left: {WindowLeft}px; top: {WindowTop}px; min-height: {$outputMode ? '50' : '30'}rem" use:move use:resize>
        <div on:mousedown={onMouseDown}  class="Window-Titlebar flex items-center"><p class="text-center font-bold">{WindowTitle}</p></div>
		<div class="Window-Content flex flex-row gap-1">
			<Drawer {options} bind:selectedIndex />
			<!-- <LuaExec /> -->
				<svelte:component this={options[selectedIndex].component} />
		</div>
		{#if $outputMode}
		<div class="Window-Output flex items-center relative">
			<Output />
		</div>
		{/if}

	</div>







<style>

	.Window {
		height: 80%;
		width: 80%;
		background: var(--color-secondary);
		position: absolute;
		border-radius: 10px;
		box-shadow: 0 0 1rem 0 rgba(0, 0, 0, 0.5);
		min-width: 50rem;

	}

    .Window-Titlebar {
        display:block; position:relative;
        left:0px; 
		top:0px; 
		width:100%; 
		height:30px; 
		background-color:var(--color-primary);
        cursor:grab;
        cursor: move;
		border-top-right-radius: 10px;
		border-top-left-radius: 10px;
		color: white
    }

	.Window-Content {
		height: 100%;
		width: 100%;
		padding: 1rem;
		min-height: 25rem;
		/* overflow: hidden; */
	}

	.Window-Output {
		width: 100%;
		min-height: 20rem;
		padding: 1rem;
		padding-top: 0;
	}
	
	
	 :global(.grabber) {
		position: absolute;
		box-sizing: border-box; 
	}
	
	:global(.grabber.right) {
		width: 10px;
		height: 100%;
		/* background: red; */
		right: -5px;
		cursor: col-resize;
	}
	
	:global(.grabber.left) {
		width: 10px;
		height: 100%;
		/* background: blue; */
		left: -5px;
		cursor: col-resize;
	}
	
	:global(.grabber.top) {
		height: 10px;
		width: 100%;
		/* background: green; */
		top: -5px;
		cursor: row-resize;
	}
	
	:global(.grabber.bottom) {
		height: 10px;
		width: 100%;
		/* background: orange; */
		bottom: -5px;
		cursor: row-resize;
	}
	
	:global(.grabber.top-left) {
		height: 20px;
		width: 20px;
		/* background: orange; */
		top: -10px;
		left: -10px;
		cursor: nw-resize;
		border-radius: 100%;
	}
	
	:global(.grabber.top-right) {
		height: 20px;
		width: 20px;
		/* background: orange; */
		top: -10px;
		right: -10px;
		cursor: ne-resize;
		border-radius: 100%;
	}
	
	:global(.grabber.bottom-left) {
		height: 20px;
		width: 20px;
		/* background: green; */
		bottom: -10px;
		left: -10px;
		cursor: sw-resize;
		border-radius: 100%;
	}
	
	:global(.grabber.bottom-right) {
		height: 20px;
		width: 20px;
		/* background: green; */
		bottom: -10px;
		right: -10px;
		cursor: se-resize;
		border-radius: 100%;
	}
	
	
	:global(body) {
		display: flex;
		flex-direction: column;
		justify-content: center;
	}
</style>