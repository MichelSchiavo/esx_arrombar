local timer = 30000
local time = 30
local roubo = false
local copblip
local isTaken = 0
ESX = nil

Citizen.CreateThread(function()
while ESX == nil do
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  Citizen.Wait(0)
end
end)

function drawTxt(x,y, width, height, scale, text, r,g,b,a, outline)
  SetTextFont(0)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  if outline then SetTextOutline() end

  BeginTextCommandDisplayText('STRING')
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandDisplayText(x - width/2, y - height/2 + 0.030)
end

RegisterNetEvent('esx_arrombar:setcopblip')
AddEventHandler('esx_arrombar:setcopblip', function(cx,cy,cz)
RemoveBlip(copblip)
copblip = AddBlipForCoord(cx,cy,cz)
SetBlipSprite(copblip , 161)
SetBlipScale(copblipy , 2.0)
SetBlipColour(copblip, 8)
PulseBlip(copblip)
end)

RegisterNetEvent('esx_arrombar:removecopblip')
AddEventHandler('esx_arrombar:removecopblip', function()
RemoveBlip(copblip)
end)

RegisterNetEvent('esx_arrombar:setcopnotification')
AddEventHandler('esx_arrombar:setcopnotification', function()
ESX.ShowNotification("Um veículo está sendo arrombado.")
end)

RegisterNetEvent('esx_arrombar:roubando')
AddEventHandler('esx_arrombar:roubando', function()
roubo = true
end)

RegisterNetEvent('esx_arrombar:pararRoubo')
AddEventHandler('esx_arrombar:pararRoubo', function()
Citizen.Wait(timer)
roubo = false
time = 30
end)

RegisterNetEvent('esx_arrombar:arrombar')
AddEventHandler('esx_arrombar:arrombar', function()
local playerPed = PlayerPedId()
local coords    = GetEntityCoords(playerPed)

if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
  local vehicle = nil


  if IsPedInAnyVehicle(playerPed, false) then
    vehicle = GetVehiclePedIsIn(playerPed, false)
  else
    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
  end

  local chance = math.random(100)
  local alarm  = math.random(100)

  if DoesEntityExist(vehicle) then
    if alarm <= 75 then
      SetVehicleAlarm(vehicle, true)
      StartVehicleAlarm(vehicle)
    end


    isTaken = 1

    Citizen.CreateThread(function()
    while time > 0 and roubo do
      Citizen.Wait(1000)

      if time > 0 then
        time = time - 1
      end
    end
    end)

    Citizen.CreateThread(function()
    while roubo do
      Citizen.Wait(0)
      drawTxt(0.95, 1.44, 1.0, 1.0, 0.4, ('Arrombando em: ' .. time .. ' segundos!'), 255, 0, 0, 255)
    end
    end)

    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
    ESX.ShowNotification('Arrombamento iniciado')
    roubo = true
    Citizen.CreateThread(function()
    while true do
      Citizen.Wait(3000)
      if isTaken == 1 then
        local coords = GetEntityCoords(GetPlayerPed(-1))
        TriggerServerEvent('esx_arrombar:alertcops', coords.x, coords.y, coords.z)
      end
    end
    end)
    TriggerServerEvent('esx_arrombar:registerActivity', 1)

    Citizen.CreateThread(function()
    Citizen.Wait(timer)

    if chance <= 66 then
      SetVehicleDoorsLocked(vehicle, 1)
      SetVehicleDoorsLockedForAllPlayers(vehicle, false)
      ClearPedTasksImmediately(playerPed)
      ESX.ShowNotification('Veiculo arrombado')
      Citizen.Wait(10000)
      isTaken = 0
      TriggerServerEvent('esx_arrombar:stopalertcops')
    else
      ESX.ShowNotification('Falhou')
      ClearPedTasksImmediately(playerPed)
      Citizen.Wait(10000)
      isTaken = 0
      TriggerServerEvent('esx_arrombar:stopalertcops')
    end
    end)
  end
else
  ESX.ShowNotification('Nenhum veículo próximo para ser arrombado')
end
end)
