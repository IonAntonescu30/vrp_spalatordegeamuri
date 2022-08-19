fx_version 'adamant'

game 'gta5'

description "Spalator de geamuri vRP facut de Ion Antonescu"

dependencies {
	"vrp",
}

client_scripts{
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"client.lua"
}

server_scripts{
	"@vrp/lib/utils.lua",
	"server.lua"
}
