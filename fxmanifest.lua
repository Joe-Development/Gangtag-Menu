fx_version 'cerulean'
game 'gta5'

author 'JaredScar & JoeV2'
description 'Badger\'s DiscordTagIDs with A Headtag Menu'
version '1.2.2'
lua54 'yes'

client_scripts {
    '@NativeUI/NativeUI.lua', 
    'config.lua',
    'client.lua',
}
server_scripts {
    "config.lua",
    "server.lua"
}

server_exports {
    "HideUserTag",
    "ShowUserTag"
}

escrow_ignore {
    'stream/*.ytd',
    'config.lua'
}