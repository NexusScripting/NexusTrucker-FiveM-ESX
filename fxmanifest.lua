fx_version 'cerulean'
game 'gta5'

author 'Nexus Development'
description 'Trucker Job'
version '1.0.0'

shared_scripts { 'config.lua' }
client_scripts { 'client/main.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }

ui_page 'nui/ui.html'
files {
    'nui/ui.html',
    'nui/style.css',
    'nui/script.js'
}

dependencies { 'es_extended', 'oxmysql' }