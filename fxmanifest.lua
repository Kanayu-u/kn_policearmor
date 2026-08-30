fx_version 'cerulean'
lua54 'yes'
game 'gta5'

description 'Police Vehicle Armor Script'
version '1.1.0'
author 'Kanayu_u'


dependency 'ox_lib'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}
