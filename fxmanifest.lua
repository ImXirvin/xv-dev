fx_version "cerulean"

game "gta5"

name "xv-dev"
author "Xirvin#0985"
description "FiveM Development Menu."
version "2.2.6"
repository "https://github.com/ImXirvin/xv-dev"

ui_page "html/index.html"

shared_scripts {
	"@ox_lib/init.lua",
	"shared/lib.lua",
}

client_script {
	"client/client.lua",
	"client/resources.lua",
	"client/players.lua",
}
server_script {
	"server/config.lua",
	"server/server.lua",
	"server/resources.lua",
	"server/players.lua",
}
files {
	"html/index.html",
	"html/index.js",
	"html/index.css",
}

lua54 "yes"
