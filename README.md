# XV-DEV
## Development menu for FiveM

## NOTE: BIG REDO OF UI IS BEING WORKED ON

Removes the need to make temporary commands to test out some code, or however you test scripts.

[Preview Video](https://streamable.com/fdsqis)

## Features

- Execute any code using the Lua Executor 
- Execute commonly used natives through the Quick Functions tab.
     - Declare variables to be passed in to the functions
     - Search through a predefined list of functions
     - See all global variables that was declared
     - Configure by adding/removing/editing functions
- Console to show if code was executed or returned an error
- Debug to show code that was executed
- Auto Detection for QBCore and ESX
- Customisable Editor theme

## Future Features
- Section for Resource List to allow starting/restarting/stopping resources (like txAdmin)
- Section for Player for quick Player Options
- Section for Vehicle for quick Vehicle Options
- Vehicle section is also planned to have a Vehicle Meta changer built in

## Installation
Drag'N'Drop

## DO NOT

Do not do `while true do`
Instead declare a global variable to true and use that.
Example:
```lua
runWhile = true

while runWhile do
    --run something
end
```
To turn it off
```lua
runWhile = false
```

## DO

To return a value to the Output tab, you must return outside a function. This is because of a hacky solution to be able to execute the lua code.

```lua
return "This would be returned to the Output Tab"
```

## License

GNU General Public License

