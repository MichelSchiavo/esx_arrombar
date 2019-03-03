ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterCommand("arrombar", function(source, args, rawCommand)
	local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)
  
  TriggerClientEvent('esx_comandos:roubando', _source)
  TriggerClientEvent('esx_comandos:arrombar', _source)
  TriggerClientEvent('esx_comandos:startTimer', _source)
  TriggerClientEvent('esx_comandos:pararRoubo', _source)
end)




RegisterServerEvent('esx_comandos:alertcops')
AddEventHandler('esx_comandos:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx_comandos:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)

RegisterServerEvent('esx_comandos:stopalertcops')
AddEventHandler('esx_comandos:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx_comandos:removecopblip', xPlayers[i])
		end
	end
end)