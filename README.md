# XV-DEV
## Development menu for FiveM

Removes the need to make temporary commands to test out some code, or however you test scripts.

[Preview Video](https://streamable.com/fdsqis)

[Resource Manager Preview Video](https://streamable.com/ygan7k)

[Code Editor Themes](https://imgur.com/a/5EBCj8f)

## Note
`StrictResEdit` is `true` by default. This means the player must have atleast 1 valid identifier set. If false, anyone allowed to use the menu will be edit resources.

## Features
- Execute any code using the Lua Executor 
- Execute commonly used natives through the Quick Functions tab.
     - Declare variables to be passed in to the functions
     - Search through a predefined list of functions
     - See all global variables that was declared
     - Configure by adding/removing/editing functions
- Console to show if code was executed or returned an error
- Debug to show code that was executed
- Auto Detection for QBCore/ESX/Ox_lib
- Customisable Editor theme
- Advanced Discord Webhooks
- Advanced Resource Manager
    - Start/Stop/Restart Resources
    - Edit Files on the go with built-in Editor
    - Makes Backups in dedicated backups folder
- Advanced Player Manager
    - Teleport to them
    - Teleport them to you
    - Teleport them to a coordinate
    - Freeze them
    - Unfreeze them
    - Spawn them a vehicle
    - Delete their vehicle
    - Execute code directly to their client


## Future Features
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

