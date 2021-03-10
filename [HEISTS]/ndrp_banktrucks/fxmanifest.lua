fx_version 'adamant'
game 'gta5'

description 'ESX Truck Robbery'

client_scripts {
    "config.lua",
    "client.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua"
}