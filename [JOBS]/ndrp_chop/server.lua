ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cooldown = -1;
local inProgress = false
local randomLoc, randomVeh = false , false
local stopCooldown = false
local spawnedChopcars = false
local currentplate = false
local lockedplate = 0

local randomLocations = {
    vector3(-2480.9, -212.0, 17.4),
    vector3(-2723.4, 13.2, 15.1),
    vector3(-3169.6, 976.2, 15.0),
    vector3(-3139.8, 1078.7, 20.2),
    vector3(-1656.9, -246.2, 54.5),
    vector3(-1586.7, -647.6, 29.4),
    vector3(-1036.1, -491.1, 36.2),
    vector3(-1029.2, -475.5, 36.4),
    vector3(75.2, 164.9, 104.7),
    vector3(-534.6, -756.7, 31.6),
    vector3(487.2, -30.8, 88.9),
    vector3(-772.2, -1281.8, 4.6),
    vector3(-663.8, -1207.0, 10.2),
    vector3(719.1, -767.8, 24.9),
    vector3(-971.0, -2410.4, 13.3),
    vector3(-1067.5, -2571.4, 13.2),
    vector3(-619.2, -2207.3, 5.6),
    vector3(1192.1, -1336.9, 35.1),
    vector3(-432.8, -2166.1, 9.9),
    vector3(-451.8, -2269.3, 7.2),
    vector3(939.3, -2197.5, 30.5),
    vector3(-556.1, -1794.7, 22.0),
    vector3(591.7, -2628.2, 5.6),
    vector3(1654.5, -2535.8, 74.5),
    vector3(1642.6, -2413.3, 93.1),
    vector3(1371.3, -2549.5, 47.6),
    vector3(383.8, -1652.9, 37.3),
    vector3(27.2, -1030.9, 29.4),
    vector3(229.3, -365.9, 43.8),
    vector3(-85.8, -51.7, 61.1),
    vector3(-4.6, -670.3, 31.9),
    vector3(-111.9, 92.0, 71.1),
    vector3(-314.3, -698.2, 32.5),
    vector3(-366.9, 115.5, 65.6),
    vector3(-592.1, 138.2, 60.1),
    vector3(-1613.9, 18.8, 61.8),
    vector3(-1709.8, 55.1, 65.7),
    vector3(-521.9, -266.8, 34.9),
    vector3(-451.1, -333.5, 34.0),
    vector3(322.4, -1900.5, 25.8)
}

local randomModels = {"fugitive","surge","sultan","asea","premier"}

ESX.RegisterUsableItem('chopradio', function(source)
    if not inProgress then
        inProgress = true
		randomLoc = randomLocations[math.random(1, #randomLocations)]
        randomVeh = randomModels[math.random(1, #randomModels)]
        local x,y,z = randomLoc.x, randomLoc.y, randomLoc.z
        currentplate =  tostring(math.random(11111111,99999999))
        TriggerClientEvent('ndrp_chop:spawnVehicle', -1, x,y,z, randomVeh,currentplate)
		startCoolDown(15)
	else
		local x,y,z = randomLoc.x, randomLoc.y, randomLoc.z
	    TriggerClientEvent('ndrp_chop:notifyOwner', source, x,y,z, randomVeh)
	end
end)

AddEventHandler('esx:playerLoaded', function (source)
    if inProgress then
        local x,y,z = randomLoc.x, randomLoc.y, randomLoc.z
        TriggerClientEvent('ndrp_chop:spawnVehicle', source, x,y,z, randomVeh,currentplate)
    end
end)

function startCoolDown(minutes)
    cooldown = minutes * 60 * 1000
    while cooldown > 0 do
        if stopCooldown then
            break
        end
        Citizen.Wait(1000)
        cooldown = cooldown - 1000
        if cooldown <= 0 then
            cooldown = -1
            inProgress = false
            TriggerEvent('ndrp_chop:timeOver')
            break
        end
    end
end

RegisterNetEvent('ndrp_chop:vehicleChopped')
AddEventHandler('ndrp_chop:vehicleChopped', function()
	stopCooldown = true
    inProgress = false
	local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getInventoryItem('chopradio').count >= 1 then
            TriggerClientEvent('ndrp_chop:informClientsChopped', xPlayers[i], randomVeh)
        end
    end
end)

RegisterNetEvent('ndrp_chop:timeOver')
AddEventHandler('ndrp_chop:timeOver', function()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getInventoryItem('chopradio').count >= 1 then
            TriggerClientEvent('ndrp_chop:informClientsTimeOver', xPlayers[i])
        end
    end
end)

RegisterNetEvent('ndrp_chop:checkitems')
AddEventHandler('ndrp_chop:checkitems', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	while xPlayer == nil do
        xPlayer = ESX.GetPlayerFromId(source)
        Wait(10)
    end
    if xPlayer ~= nil then
		local radio = xPlayer.getInventoryItem('radio').count
		local wire = xPlayer.getInventoryItem('wire').count
		local raspberry = xPlayer.getInventoryItem('raspberry').count
		if radio >= 1 and wire >=2 and raspberry >= 1 then
			TriggerClientEvent('ndrp_chop:checkitems',source, true)
		else
			TriggerClientEvent('ndrp_chop:checkitems',source, false)
        end
		
    end
end)

RegisterNetEvent('ndrp_chop:getRadio')
AddEventHandler('ndrp_chop:getRadio', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	while xPlayer == nil do
        xPlayer = ESX.GetPlayerFromId(source)
        Wait(10)
    end
    if xPlayer ~= nil then
		xPlayer.removeInventoryItem('wire',2)
		xPlayer.removeInventoryItem('radio',1)
		xPlayer.addInventoryItem('chopradio',1)
    end
end)


RegisterNetEvent('ndrp_chop:gotItem')
AddEventHandler('ndrp_chop:gotItem', function()
	
	local xPlayer = ESX.GetPlayerFromId(source)
	local rand =  math.random(2,5)
	local randamount = math.random(500,1000)
	local added = 0

	while xPlayer == nil do
        xPlayer = ESX.GetPlayerFromId(-1)
        Wait(10)
    end

	xPlayer.addMoney(randamount)
	
	for i=1 , rand , 1 do
		if xPlayer.canCarryItem('choppedcarparts', 1) then
			xPlayer.addInventoryItem("choppedcarparts", 1)
			added = added + 1
		end
	end
	
	TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'success', 
			text = 'You received $' .. randamount .. ' for this hot vehicle', 
			length = 4500,
			style = {}
		})
	
	if added == 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'error', 
			text = 'You don\'t have enough space in your inventory', 
			length = 2500, 
			style = {}
		})
	elseif added ~= rand then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'inform', 
			text = 'You got ' .. rand .. ' chopped car parts but you could only carry '.. added, 
			length = 6500,
			style = {}
		})
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'inform', 
			text = 'You got ' .. rand .. ' chopped car parts', 
			length = 4500,
			style = {}
		})
	end
end)

RegisterNetEvent('ndrp_chop:rareItem')
AddEventHandler('ndrp_chop:rareItem', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
		if xPlayer.canCarryItem('raspberry', 1) then
			xPlayer.addInventoryItem("raspberry", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'Found a Raspberry', 
				length = 4500, 
				style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
			})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You don\'t have enough space in your inventory', 
				length = 4500, 
			})
		end
    end
end)

RegisterNetEvent("ndrp_chop:LocalCars")
AddEventHandler("ndrp_chop:LocalCars", function()
    TriggerClientEvent("ndrp_chop:deleteLocalCars", -1)
end)

RegisterNetEvent("ndrp_chop:newJoined")
AddEventHandler("ndrp_chop:newJoined", function()
    if spawnedChopcars then
        TriggerClientEvent("ndrp_chop:spawnLocalcar", source)
    end
end)


RegisterNetEvent("ndrp_chop:Locked")
AddEventHandler("ndrp_chop:Locked", function(lplate)
    if lplate ~= lockedplate then
        lockedplate = lplate
        TriggerClientEvent("ndrp_chop:verify",source)
    end
end)