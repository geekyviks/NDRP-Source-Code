fx_version 'adamant'

game 'gta5'

description 'ESX Police Job'

version '1.3.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
--	'server/armory_s.lua',
	'server/duty_s.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'client/cctv.lua',
--	'client/armory_c.lua',
	'client/duty_c.lua',
}

dependencies {
	'es_extended',
}