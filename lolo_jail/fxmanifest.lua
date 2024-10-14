fx_version 'adamant'

game 'gta5'

description 'ESX Jail'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'server/main.lua'
}


client_scripts {
	"src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended'
}
