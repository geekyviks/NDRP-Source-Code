ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Oxygen Mask

ESX.RegisterUsableItem('oxygen_mask', function(source)
	TriggerClientEvent('esx_extraitems:oxygen_mask', source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('oxygen_mask', 1)
end)

-- DRUGS

ESX.RegisterUsableItem('joint', function(source) 
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_drugeffects:onWeed', source)
end)

ESX.RegisterUsableItem('cocaine', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_drugeffects:onCoke', source)
end)

ESX.RegisterUsableItem('oxy', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_drugeffects:onOxy', source)
end)

ESX.RegisterUsableItem('meth', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_drugeffects:onMeth', source)
end)

ESX.RegisterUsableItem('cigarette', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter').count
	if lighter >= 1 then
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx_drugeffects:onCopCigar', source)
		else
			TriggerClientEvent('esx_drugeffects:onCigar', source)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'error', 
			text = 'You don\'t have lighter', 
			length = 2500
		})
	end
end)

-- Handcuffs

ESX.RegisterUsableItem("cuffs", function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_policejob:checkCuff', _source, false, true)
end)

-- Cannabis

ESX.RegisterUsableItem('cannabis', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:useCannabis', source)
	Citizen.Wait(5000)
	xPlayer.addInventoryItem('joint', 1)
end)

-- Marijuana

ESX.RegisterUsableItem('marijuana', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:useMarijuana', source)
	Citizen.Wait(10000)
	xPlayer.addInventoryItem('joint', 3)
end)

ESX.RegisterUsableItem('contrat', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:useSalvage', source)
end)

-- Bullet-Proof Vest
ESX.RegisterUsableItem('bulletproof', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:bulletproof', source)
	xPlayer.removeInventoryItem('bulletproof', 1)
end)

-- Weapon Clip
ESX.RegisterUsableItem('clip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:clipcli', source)
	xPlayer.removeInventoryItem('clip', 1)
end)

-- Drill

ESX.RegisterUsableItem('drill', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_extraitems:startDrill', source)
	xPlayer.removeInventoryItem('drill', 1)
end)

-- Lock Pick
ESX.RegisterUsableItem('lockpick', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:lockpick', _source)
	xPlayer.removeInventoryItem('lockpick', 1)
end)

-- Binoculars
ESX.RegisterUsableItem('binoculars', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:binoculars', source)
end)

ESX.RegisterUsableItem('GADGET_PARACHUTE', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:startParachute', source)
	xPlayer.removeInventoryItem('GADGET_PARACHUTE', 1)
end)

---- DRINKS

ESX.RegisterUsableItem('wine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkWine', source)
end)

ESX.RegisterUsableItem('beer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkBeer', source)
end)

ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkVodka', source)
end)

ESX.RegisterUsableItem('whisky', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkWhisky', source)
end)

ESX.RegisterUsableItem('tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkTequila', source)
end)

ESX.RegisterUsableItem('chocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onEatChocolate', source)
end)

ESX.RegisterUsableItem('teacup', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkTea', source)
end)

ESX.RegisterUsableItem('coffee', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkCoffee', source)
end)

ESX.RegisterUsableItem('icetea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkIcetea', source)
end)

ESX.RegisterUsableItem('cocacola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onDrinkCola', source)
end)

ESX.RegisterUsableItem('vegburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onEatVB', source)
end)

ESX.RegisterUsableItem('chickenburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onEatCB', source)
end)

ESX.RegisterUsableItem('mimiburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:onEatMB', source)
end)

---- end drinks


ESX.RegisterUsableItem('boltcutter', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:boltcutter', source)
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    for k, v in pairs(Config.Ammo) do
        ESX.RegisterUsableItem(v.name, function(source)
            TriggerClientEvent('esx_extraitems:useAmmoItem', source, v)
        end)
    end
end)

RegisterServerEvent('esx_extraitems:removeAmmoItem')
AddEventHandler('esx_extraitems:removeAmmoItem', function(ammo)
    local player = ESX.GetPlayerFromId(source)
    player.removeInventoryItem(ammo.name, 1)
end)

RegisterServerEvent('esx_extraitems:removethisitem')
AddEventHandler('esx_extraitems:removethisitem', function(item)
    local player = ESX.GetPlayerFromId(source)
    player.removeInventoryItem(item, 1)
end)

RegisterServerEvent("esx_extraitems:usesalvage")
AddEventHandler("esx_extraitems:usesalvage", function()
   
	local player = ESX.GetPlayerFromId(source)
    math.randomseed(os.time())
    local lucky = math.random(0, 50)
    local randomBottleX = math.random(1, 1)

    if lucky >= 0 and lucky <= 29 then
		
		if player.canCarryItem('scrap', 1) then
			player.addInventoryItem("scrap", randomBottleX)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'Found Scrap Metal', 
				length = 2500, 
				style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
			})
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You don\'t have enough space in your inventory', 
				length = 2500, 
			})
		end
		
	elseif lucky >= 30 and lucky <= 35 then
		
		if player.canCarryItem('glass', 1) then
			player.addInventoryItem("glass", randomBottleX)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'Found glass', 
				length = 2500, 
				style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
			})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You don\'t have enough space in your inventory', 
				length = 2500, 
			})
		end
		
		
	elseif lucky >= 36 and lucky <= 39 then
		
		if player.canCarryItem('steel', 1) then
			player.addInventoryItem("steel", randomBottleX)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'Found Steel', 
				length = 2500, 
				style = { ['background-color'] = '#D4AF37', ['color'] = '#FFFFFF' } 
			})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You don\'t have enough space in your inventory', 
				length = 2500, 
			})
		end
		
	elseif lucky >= 40 and lucky <= 41 then
		
		if player.canCarryItem('wire', 1) then
			player.addInventoryItem("wire", randomBottleX)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'Found Wire', 
				length = 2500, 
				style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
			})
		
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You don\'t have enough space in your inventory', 
				length = 2500, 
			})
		end
		
	elseif lucky >= 42 and lucky <= 44 then	
		
		if player.canCarryItem('electronics', 1) then
			player.addInventoryItem("electronics", randomBottleX)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'Found Electronics', 
				length = 2500, 
				style = { ['background-color'] = '#12B296', ['color'] = '#FFFFFF' } 
			})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You don\'t have enough space in your inventory', 
				length = 2500, 
			})
		end
		
	elseif lucky >= 45 and lucky <= 50 then	
		
		if player.canCarryItem('glass', 1) then
			player.addInventoryItem("glass", randomBottleX)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'Found Glass', 
				length = 2500, 
				style = { ['background-color'] = '#12B296', ['color'] = '#FFFFFF' } 
			})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You don\'t have enough space in your inventory', 
				length = 2500, 
			})
		end
    end
end)