fx_version 'cerulean'

game "gta5"

description "FiveM Development Menu by Xirvin."
version '1.0.0'

lua54 'yes'


ui_page 'html/index.html'

client_script {
  'client/client.lua',
  'client/lib.lua',
}
server_script {
  "server/server.lua",
  }

files {
  'html/index.html',
  'html/script.js',
  'html/style.css',
}
