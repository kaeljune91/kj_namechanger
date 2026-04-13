game "rdr3"
fx_version "cerulean"
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
lua54 "yes"
version "1.0.1"
author "kaeljune#0091"
description "Name changer for RSG Framework"

files {
    'config.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'cl/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv/main.lua'
}