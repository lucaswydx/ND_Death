author "lucaswydx | TheStoicBear"
description "A Death System/CPR System made for ND Framework"
version "2.0.0"

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