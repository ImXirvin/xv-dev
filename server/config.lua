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
            remote = true, --Allowed to execute remote code on Source
            manageRes = true, --Allowed to manage resources
            editRes = true, --Allowed to edit resources
            managePly = true, --Allowed to manage players
        },
    },

    StrictResEdit = true, --If true, player must have atleast 1 valid identifier in Identifiers table to edit resources.

    Webhook = "https://discord.com/api/webhooks/1054681685968560148/v-1E5A2-cYKgrH_zPBqiZHsDCA0eWBZL6N9S_EWXKEbhSBcF-PCQTmUWJt-WS1E43ZSe", -- Discord webhook to send logs to

    Colors = {
        ["red"] = 16711680,
        ["yellow"] = 15335168,
        ["green"] = 65280,
        ["blue"] = 255,
        ["purple"] = 8388736,
        ["orange"] = 16744192,
        ["pink"] = 16711935,
        ["white"] = 16777215,
        ["black"] = 0,
    },

    HookName = "Dev Menu by Xirvin", -- Name of the webhook
    HookAvatar= "https://cdn.discordapp.com/avatars/321736959515164692/41cd15ca7af8141672d45136d3f51b0d.webp?size=128",

    HookOnResourceEvents = false, -- If true, will send a webhook message when a resource is started, stopped or restarted BUT EDITS WILL ALWAYS SEND A WEBHOOK MESSAGE REGARDLESS OF THIS CONFIG
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
