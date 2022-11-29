# XV-DEV
## Development menu for FiveM

##NOTE: BIG REDO OF UI IS BEING WORKED ON

Removes the need to make temporary commands to test out some code, or however you test scripts.

[Preview Video](https://streamable.com/s3q4xq)

## Features

- Execute any code using the Lua Executor 
- Execute commonly used natives through the Quick Functions tab.
     - Declare variables to be passed in to the functions
     - Search through a predefined list of functions
     - See all global variables that was declared
- Console to show if code was executed or returned an error
- Debug to show code that was executed
- History component that shows last 25 executions
- Auto Detection for QBCore and ESX

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
To check for global variables declared in Quick Functions, check the History tabs to see its past states.


## License

GNU General Public License

