fx_version 'adamant'

game 'gta5'

description 'NDRP Drugs: Edited by Mozart and Vicky'

version '2.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {

	'config.lua',
	'client/weed.lua',
	'client/meth.lua'
}