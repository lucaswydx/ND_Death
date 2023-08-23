author "lucaswydx"
description "Simple Death System made for ND Framework"
version "1.0.3"

fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts {
    "source/client.lua"
}
server_scripts {
    "source/server.lua"
}

shared_scripts {
    "config.lua"
}

dependency "ND_Core"
