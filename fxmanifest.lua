fx_version "cerulean"
game "gta5"
lua54 "yes"

name "melons_dispatch"
author "IlMelons"
description "Simple Dispatch made with ox_lib"
version "1.1.2"
repository "https://github.com/IlMelons/melons_dispatch"

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
    "checker.lua",
}

files {
    "locales/*.json",
}
