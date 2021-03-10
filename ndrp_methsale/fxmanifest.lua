fx_version 'adamant'

game 'gta5'

description 'NDRP DrugSales'

version '1.5.0'

client_scripts {
    "config.lua",
    "client.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua"
}
