fx_version "cerulean"
game "gta5"
lua54 "yes"

author "IlMelons"
description "Simple Dispatch made with ox_lib"
version "1.1.1"

ox_lib "locale"

shared_scripts {
    "@ox_lib/init.lua",
}

client_scripts {
    "client/client.lua",
}

server_scripts {
    "config/server.lua",
    "bridge/server/*.lua",
    "server/server.lua",
}

files {
    "locales/*.json",
}
