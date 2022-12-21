fx_version 'cerulean'

game "gta5"

author "Xirvin"
version '0.0.1'
description 'HUD made by Xirvin'

lua54 'yes'


ui_page 'html/index.html'

client_script {
  'client/**',
}
server_script {
  "server/**",
  }
shared_script {
  'shared/**',
}

files {
  'html/**',
}
