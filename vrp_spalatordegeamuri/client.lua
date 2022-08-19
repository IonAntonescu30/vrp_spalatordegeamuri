Tunnel.bindInterface("IA_spalatordegeamuri",IAc)
Proxy.addInterface("IA_spalatordegeamuri",IAc)
IAs = Tunnel.getInterface("IA_spalatordegeamuri","IA_spalatordegeamuri")
vRP = Proxy.getInterface("vRP")
cIA = Tunnel.getInterface("vRP","IA_spalatordegeamuri")

local spatula = nil
local spotstodo = 5
local spots = 0
local started = false
local job = false
local ready = false
local jobMadeBy_IA = true


Citizen.CreateThread(function() 
    local blip = AddBlipForCoord(734.01293945312,-1311.1033935547,26.879508972168)
    SetBlipSprite(blip, 351) 
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 25)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Spalator de Geamuri") 
    EndTextCommandSetBlipName(blip)
end)

function DrawText3D(x,y,z, text, scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then 
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

locations = {
    {-36.672096252441,-1113.2600097656,26.436912536621},
    {-36.686248779297,-1109.4837646484,26.43701171875},
    {-49.66695022583,-1104.8619384766,26.436935424805},
    {-59.480667114258,-1090.0705566406,26.632204055786}, 
    {-32.886051177979,-1103.9487304688,26.422355651855}, 
}


Citizen.CreateThread(function()
sleep = 0 
while true do
    Citizen.Wait(sleep) 
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local dist = math.floor(GetDistanceBetweenCoords(734.01293945312,-1311.1033935547,26.879508972168, GetEntityCoords(GetPlayerPed(-1))))
    if dist < 20 then
        sleep = 0
        DrawMarker(20, 734.01293945312,-1311.1033935547,26.879508972168, 0, 0, 0, 0, 0, 0, 0.6001,0.6001,0.6001, 255, 152, 80, 100, 0, 0, 0, 1, 0, 0, 0)
        DrawText3D(734.01293945312,-1311.1033935547,26.879508972168+1, "JOB: ~b~Spalator de geamuri", 1)
    end
    if job == true then
        for i,v in pairs(locations) do
            local meters = math.floor(GetDistanceBetweenCoords(v[1],v[2],v[3], GetEntityCoords(GetPlayerPed(-1))))
            if spots == 1 or spots == 2 or spots == 3 or spots == 4 then
                DrawText3D(pos.x,pos.y,pos.z, "Geamuri spalate: "..spots.."/5", 1)
            end
            if locations[i] ~= nil then
                if meters <= 5 then
                    DrawMarker(20, v[1],v[2],v[3], 0, 0, 0, 0, 0, 0, 0.6001,0.6001,0.6001, 57, 120, 255, 100, 0, 0, 0, 1, 0, 0, 0) 
                    DrawText3D(v[1],v[2],v[3]+0.7, "Spala Aici", 1) 
                end
            end
            if locations[i] ~= nil then
                if meters <= 0.5 then
                    table.remove(locations,i)
                    if spots <= 2 then 
                        vRP.playAnim({false, {task="WORLD_HUMAN_MAID_CLEAN"}, false})
                        vRP.notify({"~g~Ai inceput sa speli geamul"})
                    end
                    SetTimeout(10000, function()
                    vRP.stopAnim({false})
                    spots = spots + 1
                        if spots == 5 then
                            vRP.notify({"Du-te inapoi la sediu si ia-ti banii."})
                            ready = true
                        end
                    end)
                end
            end
        end
    end
end
end)

Citizen.CreateThread(function()
ticks = 0
    while true do
        Citizen.Wait(ticks)
        local dist1 = math.floor(GetDistanceBetweenCoords(734.01293945312,-1311.1033935547,26.879508972168, GetEntityCoords(GetPlayerPed(-1))))
        if dist1 <= 3 then
            ticks = 0
            DrawText3D(734.01293945312,-1311.1033935547,26.879508972168+0.6, "~w~Apasa ~b~[E] ~w~pentru a te ~b~angaja~w~!\n ~w~Apasa ~b~[Z] ~w~ca sa iti primesti ~b~salariul~w~!",1.2)
            if IsControlJustPressed(1,51) then
                if job == false then
                    vRP.notify({"~o~Du-te la showroom si spala cele 5 geamuri!"})
                    job = true
                elseif job == true then
                    vRP.notify({"~o~Du-te la showroom si spala cele 5 geamuri!"})
                end
            elseif IsControlJustPressed(1,20) then
                if ready == true then
                    if spots == 5 then
                        TriggerServerEvent("IA_spalatordegeamuri")
                        spots = 0
                        job = false
                        ready = false
                        table.insert(locations,{-36.672096252441,-1113.2600097656,26.436912536621})
                        table.insert(locations,{-36.686248779297,-1109.4837646484,26.43701171875})
                        table.insert(locations,{-49.66695022583,-1104.8619384766,26.436935424805})
                        table.insert(locations,{-59.480667114258,-1090.0705566406,26.632204055786})
                        table.insert(locations,{-32.886051177979,-1103.9487304688,26.422355651855})
                    end
                else
                    vRP.notify({"~r~Inca nu ai terminat tura!"})
                end
            end
        else
            ticks = 1000
        end
    end
end)