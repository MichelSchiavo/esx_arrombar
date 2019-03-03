local timer = 30000
local time = 30
local roubo = false
local ped = GetPlayerPed(-1)
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
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('esx_comandos:setcopblip')
AddEventHandler('esx_comandos:setcopblip', function(cx,cy,cz)
		RemoveBlip(copblip)
    copblip = AddBlipForCoord(cx,cy,cz)
    SetBlipSprite(copblip , 161)
    SetBlipScale(copblipy , 2.0)
		SetBlipColour(copblip, 8)
    PulseBlip(copblip)
end)

RegisterNetEvent('esx_comandos:removecopblip')
AddEventHandler('esx_comandos:removecopblip', function()
		RemoveBlip(copblip)
end)

RegisterNetEvent('esx_comandos:setcopnotification')
AddEventHandler('esx_comandos:setcopnotification', function()
	ESX.ShowNotification("Roubo de carro em andamento. O pistas serão dadas em seu mapa.")
end)

RegisterNetEvent('esx_comandos:arrombar')
AddEventHandler('esx_comandos:arrombar', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    local vehicle = nil
    local roubo = false
    

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

roubo = true
isTaken = 1
      TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
      Citizen.CreateThread(function()
        while true do
        Citizen.Wait(3000)
        if isTaken == 1 then
        local coords = GetEntityCoords(ped)
      TriggerServerEvent('esx_comandos:alertcops', coords.x, coords.y, coords.z)
    end
  end
end)

      Citizen.CreateThread(function()      
        Citizen.Wait(timer)
        
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
          ESX.ShowNotification('Veiculo arrombado')
          Citizen.Wait(60000) -- tempo que vai matar o blip dos cops
          isTaken = 0
          TriggerServerEvent('esx_comandos:stopalertcops')
				else
					ESX.ShowNotification('Falhou')
          ClearPedTasksImmediately(playerPed)
          Citizen.Wait(60000) -- tempo que vai matar o blip dos cops
          isTaken = 0
          TriggerServerEvent('esx_comandos:stopalertcops')
				end
      end)      
    end
  else
    ESX.ShowNotification('Nenhum veículo próximo para ser arrombado')
  end
end)





RegisterNetEvent('esx_comandos:roubando')
AddEventHandler('esx_comandos:roubando', function()
roubo = true
end)

RegisterNetEvent('esx_comandos:pararRoubo')
AddEventHandler('esx_comandos:pararRoubo', function()
Citizen.Wait(timer)
roubo = false
time = 30
end)

RegisterNetEvent('esx_comandos:startTimer')
AddEventHandler('esx_comandos:startTimer', function()

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
			drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, ('Arrombando em: ' .. time), 255, 0, 0, 255)
		end
	end)
end)