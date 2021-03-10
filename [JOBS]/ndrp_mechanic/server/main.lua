ESX                = nil
PlayersHarvesting  = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}
PlayersCrafting    = {}
PlayersCrafting2   = {}
PlayersCrafting3   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'mechanic', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'mechanic', _U('mechanic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'private'})


RegisterServerEvent('esx_mechanicjob:onNPCJobMissionCompleted')
AddEventHandler('esx_mechanicjob:onNPCJobMissionCompleted', function()
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total   = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);

	if xPlayer.job.grade >= 3 then
		total = total * 2
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(total)
	end)
	TriggerClientEvent("esx:showNotification", _source, _U('your_comp_earned').. total)
end)



RegisterServerEvent('esx_mechanicjob:getStockItem')
AddEventHandler('esx_mechanicjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification(_U('have_withdrawn', count, item.label))
			else
				xPlayer.showNotification(_U('player_cannot_hold'))
			end
		else
			xPlayer.showNotification(_U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_mechanicjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_mechanicjob:putStockItems')
AddEventHandler('esx_mechanicjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			xPlayer.showNotification(_U('invalid_quantity'))
		end

		xPlayer.showNotification(_U('have_deposited', count, item.label))
	end)
end)

ESX.RegisterServerCallback('esx_mechanicjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory
	cb({items = items})
end)


RegisterServerEvent('esx_mechanicjob:pickedUpScrap')
AddEventHandler('esx_mechanicjob:pickedUpScrap', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canCarryItem('scrap', 1) then
        xPlayer.addInventoryItem('scrap', 1)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Found Scrap', length = 3500 })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You can\'t carry anymore!', length = 4500 })
	end
end)


RegisterServerEvent('esx_mechanicjob:pickedUpSalvage')
AddEventHandler('esx_mechanicjob:pickedUpSalvage', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canCarryItem('contrat', 1) then
        xPlayer.addInventoryItem('contrat', 1)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Collected Salvage', length = 3500 })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You can\'t carry anymore!', length = 4500 })
	end
end)

RegisterServerEvent('esx_mechanicjob:pickedUpGlass')
AddEventHandler('esx_mechanicjob:pickedUpGlass', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canCarryItem('glass', 1) then
        xPlayer.addInventoryItem('glass', 1)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Found Glass', length = 3500 })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You can\'t carry anymore!', length = 4500 })
	end
end)

-- Items work --

RegisterServerEvent('esx_mechanicjob:windowkit')
AddEventHandler('esx_mechanicjob:windowkit', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Windowkit Crafted!', length = 3500 })
	xPlayer.removeInventoryItem('glass', 5)
	Wait(100)
	xPlayer.addInventoryItem('windowkit', 1)
end)

RegisterServerEvent('esx_mechanicjob:enginekit')
AddEventHandler('esx_mechanicjob:enginekit', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Enginekit Crafted!', length = 3500 })
	xPlayer.removeInventoryItem('scrap', 5)
	xPlayer.removeInventoryItem('steel', 1)
	Wait(100)
	xPlayer.addInventoryItem('enginekit', 1)
end)

RegisterServerEvent('esx_mechanicjob:bodykit')
AddEventHandler('esx_mechanicjob:bodykit', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Bodykit Crafted!', length = 3500 })
	xPlayer.removeInventoryItem('scrap', 2)
	xPlayer.removeInventoryItem('glass', 5)
	Wait(100)
	xPlayer.addInventoryItem('bodykit', 1)
end)

RegisterServerEvent('esx_mechanicjob:repairkit')
AddEventHandler('esx_mechanicjob:repairkit', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Advanced Reparkit Crafted!', length = 3500 })
	xPlayer.removeInventoryItem('scrap', 5)
	xPlayer.removeInventoryItem('steel', 2)
	xPlayer.removeInventoryItem('glass', 5)
	Wait(100)
	xPlayer.addInventoryItem('arepairkit', 1)
end)

-- Register items --

ESX.RegisterUsableItem('windowkit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_mechanicjob:onWindowkit', _source)
end)

ESX.RegisterUsableItem('arepairkit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_mechanicjob:onRepairkit', _source)
end)

ESX.RegisterUsableItem('bodykit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_mechanicjob:onBodykit', _source)
end)

ESX.RegisterUsableItem('enginekit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_mechanicjob:onEnginekit', _source, true)
end)

ESX.RegisterUsableItem('repairkit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_mechanicjob:onEnginekit', _source , false)
end)

-- Remove Items --

RegisterServerEvent('esx_mechanicjob:WindowkitRemove')
AddEventHandler('esx_mechanicjob:WindowkitRemove', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You used a repairkit', length = 3500 })
	xPlayer.removeInventoryItem('windowkit', 1)
end)

RegisterServerEvent('esx_mechanicjob:RepairkitRemove')
AddEventHandler('esx_mechanicjob:RepairkitRemove', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You used an Advanced repairkit', length = 3500 })
	xPlayer.removeInventoryItem('arepairkit', 1)
end)

RegisterServerEvent('esx_mechanicjob:BodykitRemove')
AddEventHandler('esx_mechanicjob:BodykitRemove', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You used a bodykit', length = 3500 })
	xPlayer.removeInventoryItem('bodykit', 1)
end)

RegisterServerEvent('esx_mechanicjob:EnginekitRemove')
AddEventHandler('esx_mechanicjob:EnginekitRemove', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You used an enginekit', length = 3500 })
	xPlayer.removeInventoryItem('enginekit', 1)
end)

RegisterServerEvent('esx_mechanicjob:FixkitRemove')
AddEventHandler('esx_mechanicjob:FixkitRemove', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You used a repairkit', length = 3500 })
	xPlayer.removeInventoryItem('repairkit', 1)
end)

--- ITEM CHECK ---

ESX.RegisterServerCallback('ndrp_mechanic:checkwk', function(source, cb, num)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local glass = xPlayer.getInventoryItem('glass').count
	if glass >= 5 then 
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('ndrp_mechanic:checkbk', function(source, cb, num)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local scrap = xPlayer.getInventoryItem('scrap').count
	local glass = xPlayer.getInventoryItem('glass').count
	if scrap >= 2 and glass >= 5 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('ndrp_mechanic:checkek', function(source, cb, num)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local scrap = xPlayer.getInventoryItem('scrap').count
	local steel = xPlayer.getInventoryItem('steel').count
	if scrap >= 5 and steel >= 1 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('ndrp_mechanic:checkark', function(source, cb, num)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local scrap = xPlayer.getInventoryItem('scrap').count
	local steel = xPlayer.getInventoryItem('steel').count
	local glass = xPlayer.getInventoryItem('glass').count
	if scrap >= 5 and steel >= 2 and glass >= 5 then
		cb(true)
	else
		cb(false)
	end
end)