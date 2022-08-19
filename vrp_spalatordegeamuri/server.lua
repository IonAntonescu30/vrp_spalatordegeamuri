local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","IA_spalatordegeamuri")

Axc = Tunnel.getInterface("IA_spalatordegeamuri","IA_spalatordegeamuri")

Axs = {}
Tunnel.bindInterface("IA_spalatordegeamuri",Axs)
Proxy.addInterface("IA_spalatordegeamuri",Axs)

RegisterServerEvent("IA_spalatordegeamuri")
AddEventHandler("IA_spalatordegeamuri",function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if user_id ~= nil and player then
        vRP.giveMoney({user_id,350})
        vRPclient.notify(player,{"Ai primit 350$ drept salariu!"})
    end
end)
