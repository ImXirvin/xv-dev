Config = {
    StrictMode = false, -- If true, only Identifiers below will be allowed to use the menu. If false, all players that have ace permissions will be able to use the menu.

    Identifiers  = { -- Identifiers that will be allowed to use the menu if StrictMode is true.
        {
            licenses = {-- Get using txadmin, can also use any identifier that fivem provides xbl, ip, etc
            "steam:examplehex", 
            "license:exampleLicense", 
            },
            client = true, --Allowed to execute client side code
            server = false, --Allowed to execute server side code
        },
    },
}




function protect(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(t, key, value)
            error("attempting to change constant " ..
                   tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end

Config = protect(Config)
