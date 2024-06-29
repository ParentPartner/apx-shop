fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Apex Shop'
version '1.0.0'

shared_script 'Config/config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@Apex/Server/functions.lua',  -- Ensure Apex functions are available
    'Server/main.lua'
}

client_scripts {
    'Client/main.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/style.css',
    'nui/script.js'
}
