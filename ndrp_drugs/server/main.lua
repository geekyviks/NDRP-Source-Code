ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(source)
		Wait(100)
	end
	if xPlayer.canCarryItem('cannabis', 1) then
		xPlayer.addInventoryItem('cannabis', 1)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Your Inventory is full', style = {}})
	end
end)

ESX.RegisterServerCallback('esx_drugs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)

RegisterServerEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(source)
		Wait(100)
	end
	local xCannabis = xPlayer.getInventoryItem('cannabis').count
	if xCannabis >= 3 then
		xPlayer.removeInventoryItem('cannabis',3)
		xPlayer.addInventoryItem('marijuana', 1)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You packed 3 cannabis into 3oz Weed Pack', style = {}})
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You need atleast 3 cannabis leaves to process', style = {}})
	end
end)

ESX.RegisterUsableItem('burnerphone', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	xPlayer.removeInventoryItem('burnerphone', 1)
	TriggerClientEvent('esx_drugs:burnerUsed', playerId)
end)

ESX.RegisterUsableItem('aciddrug', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	xPlayer.removeInventoryItem('aciddrug', 1)
	TriggerClientEvent('esx_drugs:acidUsed', playerId)
end)

RegisterServerEvent('esx_drugs:burnerphone')
AddEventHandler('esx_drugs:burnerphone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xSource = source
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(source)
		Wait(10)
	end
	if xPlayer.getInventoryItem('electronics').count >= 25 and xPlayer.getInventoryItem('scrap').count >= 15 then
		xPlayer.removeInventoryItem('electronics', 25)
		xPlayer.removeInventoryItem('scrap', 15)
		Wait(50)
		xPlayer.addInventoryItem('burnerphone', 1)
		TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { type = 'inform', text = 'Leroy gave you a Burnerphone!', length = 3000, style = { ['background-color'] = '#56f7fc', ['color'] = '#000' } })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { type = 'inform', text = 'You need 25 electronics and 15 scrap!', length = 6000, style = { ['background-color'] = '#56f7fc', ['color'] = '#000' } })
	end
end)

RegisterServerEvent('esx_drugs:dealdone')
AddEventHandler('esx_drugs:dealdone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xSource = source
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(source)
		Wait(10)
	end
	local added = 0
	
	for i = 1 , 10, 1 do
		if xPlayer.canCarryItem('meth', 1) then
			xPlayer.addInventoryItem('meth', 1)
			added = added + 1
		else
			i = 11
		end
	end
	
	if added == 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { type = 'error', text = 'You have no space in your inventory ', length = 3000, style = {}})
	elseif added < 10 then
		TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { type = 'inform', text = 'You received '.. added ..' meth out of 10 ', length = 3000, style = {['background-color'] = '#56f7fc', ['color'] = '#000' }})
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { type = 'success', text = 'You received 10 baggies of meth', length = 3000, style = {['background-color'] = '#56f7fc', ['color'] = '#000' }})
	end	
end)

ESX.RegisterServerCallback('ndrp_drugs:hasItem', function(source, cb, item)
    
	local player = ESX.GetPlayerFromId(source)
	local itemcount = player.getInventoryItem(item).count
	
	if itemcount >= 1 then
		hasItem = true
	else
		hasItem = false
	end
	
	cb(hasItem)

end)