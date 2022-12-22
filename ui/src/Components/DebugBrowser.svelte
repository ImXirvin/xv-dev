<script>
    import { debugData } from '../utils/debugData';

    let DebugResources = [
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "hardcap",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Limits the number of players to the amount set by sv_maxclients in your server.cfg."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "rconlog",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Handles old-style server player management commands."
        },
        {
            "version": "1.0.0",
            "status": "started",
            "name": "sessionmanager",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Handles the \"host lock\" for non-OneSync servers. Do not disable."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "sessionmanager-rdr3",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Handles Social Club conductor session API for RedM. Do not disable."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "example-loadscreen",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Example loading screen."
        },
        {
            "status": "started",
            "name": "prison_canteen"
        },
        {
            "status": "started",
            "name": "prison_meeting"
        },
        {
            "version": "1.0.0",
            "status": "started",
            "name": "fivem-map-hipster",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Example spawn points for FiveM with a \"hipster\" model."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "fivem-map-skater",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Example spawn points for FiveM with a \"skater\" model."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "redm-map-one",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Example spawn points for RedM."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "money",
            "author": "Cfx.re <root@cfx.re>",
            "description": "An example money system using KVS."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "money-fountain",
            "author": "Cfx.re <root@cfx.re>",
            "description": "An example money system client containing a money fountain."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "money-fountain-example-map",
            "author": "Cfx.re <root@cfx.re>",
            "description": "An example money system fountain spawn point."
        },
        {
            "version": "1.0.0",
            "status": "stopped",
            "name": "ped-money-drops",
            "author": "Cfx.re <root@cfx.re>",
            "description": "An example money system client."
        },
        {
            "version": "1.0.0",
            "status": "started",
            "name": "webpack",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Builds resources with webpack. To learn more: https://webpack.js.org"
        },
        {
            "version": "1.0.0",
            "status": "started",
            "name": "yarn",
            "author": "Cfx.re <root@cfx.re>",
            "description": "Builds resources with yarn. To learn more: https://classic.yarnpkg.com"
        }
    ]

    debugData([
        {
        action: 'updateResourceList',
        data: {
            resources: DebugResources,
        },
        },
    ]);

    
    let debugFileList = [
        "sessioasdasdasdsadasdasdsdaadasdnmanager.lua",
        "sessionmanager.meta.lua",
        "hardcap.lua",
        "hardcap.meta.lua",
        "sessionmanager-rdr3.lua",
        "sessionmanager-rdr3.meta.lua"
    ]

    debugData([
        {
            action: 'LoadFiles',
            data: {
                resourceFiles: debugFileList,
            },
        },
    ]);

    debugData([
        {
            action: 'LoadData',
            data: {
                resource: 'sessionmanager',
                route: './client.js',
                data: 'test Data',
            },
        },
    ]);

</script>