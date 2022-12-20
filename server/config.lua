ConfigForXVDev = {
    StrictMode = false, -- If true, only Identifiers below will be allowed to use the menu. If false, all players that have ace permissions will be able to use the menu.

    Identifiers  = { -- Identifiers that will be allowed to use the menu if StrictMode is true.
        {
            licenses = {-- Get using txadmin, can also use any identifier that fivem provides xbl, ip, etc
            "steam:examplehex", 
            "license:exampleLicense", 
            "xbl:examplexbl",
            "ip:exampleip",
            "discord:examplediscord",
            },
            client = true, --Allowed to execute client side code
            server = true, --Allowed to execute server side code
            remote = true,
        },
    },

    Webhook = "https://discord.com/api/webhooks/1054681685968560148/v-1E5A2-cYKgrH_zPBqiZHsDCA0eWBZL6N9S_EWXKEbhSBcF-PCQTmUWJt-WS1E43ZSe", -- Discord webhook to send logs to

    Colors = {
        ["red"] = 16711680,
        ["yellow"] = 15335168,
        ["black"] = 0,
    },

    HookName = "Dev Menu by Xirvin", -- Name of the webhook
    HookAvatar= "https://cdn.discordapp.com/avatars/321736959515164692/41cd15ca7af8141672d45136d3f51b0d.webp?size=128",
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

ConfigForXVDev = protect(ConfigForXVDev)
