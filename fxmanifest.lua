fx_version 'cerulean'
game 'gta5'

author 'JaredScar & JoeV2'
description 'Badger\'s DiscordTagIDs with A Gangtag Menu & A HUD'
version '1.2.3'
lua54 'yes'

client_scripts {
    '@NativeUI/NativeUI.lua', 
    'config.lua',
    'client.lua',
    'hud.lua'
}
server_scripts {
    "config.lua",
    "server.lua"
}

server_exports {
    "HideUserTag",
    "ShowUserTag"
}

