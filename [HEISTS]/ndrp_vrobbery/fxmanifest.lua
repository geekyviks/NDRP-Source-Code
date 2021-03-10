fx_version 'adamant'

game 'gta5'

client_scripts {
  'config.lua',
  'utils.lua',
	'client.lua',
}

server_scripts {	
	'config.lua',
  'utils.lua',
	'server.lua',
	'@mysql-async/lib/MySQL.lua',
}
