
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

local kordinat = { -- 3 Farklı kordinatın parasını ayrı olarak ayarlıyabilirsiniz 
    {x = 519.9004, y = 168.6675, z = 99.663, para = 100}, 
    {x = 151.5323, y = -3080.26, z = 6.2840, para = 100}, 
    {x = 146.9751, y = 320.9965, z = 112.33, para = 100}, 
}

local blips = {
    {title="Araç Boyama Garajı", colour=21, id=72, scale=0.5 ,coords = vector3(519.9004, 168.6675, 99.663)},
    {title="Araç Boyama Garajı", colour=21, id=72, scale=0.5 ,coords = vector3(151.5323, -3080.26, 6.2840)},
    {title="Araç Boyama Garajı", colour=21, id=72, scale=0.5 ,coords = vector3(46.9751, 320.9965, 112.33)},
}
    
    Citizen.CreateThread(function()
      for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, info.scale)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
      end
    end)

 local temizlemeucret = math.random(20, 25)
 local vergi = math.random(5,8)
 local toplam = 100+temizlemeucret
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(kordinat) do
            
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
            if IsPedInAnyVehicle(PlayerPedId(), true) then
                if dist <= 2.5 then
                    DrawText3Ds(v.x, v.y, v.z -0.2, "[E] - Aracı Boyat ~g~$"..toplam.. " ~w~ + Vergi ~g~$" ..vergi.. "~w~")
                    if IsControlJustPressed(0, Keys['E']) then
                        QBCore.Functions.TriggerCallback("ra1der_carcolor", function(cb)
                            if cb then 
                                QBCore.Functions.Progressbar("takeover_traphouse", "Araç Boyanıyor", 25000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = 'anim@gangops@facility@servers@',
                                    anim = 'hotwire',
                                    flags = 16,
                                }, {}, {}, function() -- Play When Done
                                    -- local sans = math.random(1,100)
                                    local ped = PlayerPedId()
                                    local vehicle = GetVehiclePedIsIn(ped, false)
                                     SetVehicleColours(vehicle, math.random(1, 150), math.random(1, 150))
                                        SetVehicleDirtLevel(vehicle, 0)
                                        QBCore.Functions.Notify('Araç Boyatıldı ve Temizlendi')
                                    -- end
                                    --Stuff goes here
                                end, function() -- Play When Cancel
                                    QBCore.Functions.Notify("İşlem İptal Edildi, $" ..toplam.. " İade Edildi")
                                    TriggerServerEvent("ra1der_paraiade", toplam)
                                end)
                            elseif not cb then 
                                QBCore.Functions.Notify('Yeterli Paran Yok!')
                            end
                        end, toplam + vergi)
                    end
                end
            end
        end
    end
end)


  

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 300
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 75)
end



