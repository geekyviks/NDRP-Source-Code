fx_version 'adamant'
game 'gta5'

client_script {
	'Config.lua',
	'client/carwash_c.lua',
	'client/cl_carry.lua',
	'client/coordsmain.lua',
	'client/extrascripts.lua',
	'client/golf.lua',
	'client/gym.lua',
	'client/heli_client.lua',
	'client/holster.lua',
	'client/jobblips.lua',
	'client/loadipl.lua',
	'client/marker.lua',
	'client/meclient.lua',
	'client/minigames.lua',
	'client/npcs.lua',
	'client/poldance.lua',
	'client/tackle.lua',
	'client/watertank.lua',
	'client/extramenu.lua'
}

server_script {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'Config.lua',
	'server/license.lua',
	'server/extrascripts.lua',
	'server/heli_server.lua'
}