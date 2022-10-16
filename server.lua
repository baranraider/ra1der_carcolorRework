QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback("ra1der_carcolor", function(source, cb, para)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.Functions.GetMoney('cash') >= para then
        xPlayer.Functions.RemoveMoney('cash', para )
        cb(true)
      else
        cb(false)
      end
end)

RegisterServerEvent("ra1der_paraiade")
AddEventHandler("ra1der_paraiade", function(para)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayer.Functions.AddMoney("cash", para)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if GetCurrentResourceName() ~= 'ra1der_carcolor' then
        print('^0[^3ra1der_carcolor^0] ^3- ^1 Script adını değiştirdiniz, scripti kullanabilmek için script adını eski haline çevirin!')
        Citizen.Wait(5000)
            os.exit()
        end
    end
end)
