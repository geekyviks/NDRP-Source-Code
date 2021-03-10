ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ndrp_outlawalert:carJackInProgress')
AddEventHandler('ndrp_outlawalert:carJackInProgress', function(targetCoords, streetName, vehicleLabel, playerGender,steal)
	if playerGender == 0 then
		playerGender = 'man'
	else
		playerGender = 'woman'
	end
	mytype = 'police'
	if steal ~= nil then 
		data = {["type"] = "carjack", ["icon"] = "fas fa-car", ["code"] = '10-60', ["name"] = '   A ' .. playerGender .. ' is stealing a car!', ["veh"] = vehicleLabel, ["loc"] = streetName}
	else
		data = {["type"] = "carjack", ["icon"] = "fas fa-car", ["code"] = '10-60', ["name"] = '   A ' .. playerGender .. ' is hotwiring a car!', ["veh"] = vehicleLabel, ["loc"] = streetName}
	end
	TriggerClientEvent('ndrp_outlawalert:outlawNotify', -1, mytype, data)
	TriggerClientEvent('ndrp_outlawalert:carJackInProgress', -1, targetCoords)
end, false)

RegisterServerEvent('ndrp_outlawalert:gunshotInProgress')
AddEventHandler('ndrp_outlawalert:gunshotInProgress', function(targetCoords, streetName, playerGender)
	if playerGender == 0 then
		playerGender = 'man'
	else
		playerGender = 'woman'
	end
	mytype = 'police'
	data = {["type"] = "red", ["icon"] = "fas fa-crosshairs", ["code"] = '10-71', ["name"] = '   Reports of gunshots!', ["loc"] = streetName}
	TriggerClientEvent('ndrp_outlawalert:outlawNotify', -1, mytype, data)
	TriggerClientEvent('ndrp_outlawalert:gunshotInProgress', -1, targetCoords)
end, false)

RegisterServerEvent('ndrp_outlawalert:custom')
AddEventHandler('ndrp_outlawalert:custom', function(targetCoords, playerGender, type, icon, code, title, streetName, blipx)
	if playerGender == 0 then
		playerGender = 'man'
	elseif playerGender == 1 then
		playerGender = 'woman'
	else
		playerGender = 'someone'
	end
	if (icon == nil) then
		icon = "fas fa-map-marker-alt"
	end
	mytype = 'police'
	data = {["type"] = type, ["icon"] = icon, ["code"] = code, ["name"] = title, ["loc"] = streetName}
	TriggerClientEvent('ndrp_outlawalert:outlawNotify', -1, mytype, data)
	TriggerClientEvent('ndrp_outlawalert:custom', -1, targetCoords, blipx)
end, false)

