ESX = nil
local cachedFishScore = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM fivem_fishing', {}, function(info)
		for k,v in pairs(info) do
			if info[k]['data'] ~= nil then
				cachedFishScore[info[k]['fish']] = json.decode(info[k]['data'])
			end
		end
	end)
end)


RegisterServerEvent('fivem_fishing:reloadFishing')
AddEventHandler('fivem_fishing:reloadFishing', function()
	MySQL.Async.fetchAll('SELECT * FROM fivem_fishing', {}, function(info)
		for k,v in pairs(info) do
			if info[k]['data'] ~= nil then
				cachedFishScore[info[k]['fish']] = json.decode(info[k]['data'])
			end
		end
	end)
end)


RegisterServerEvent('fivem_fishing:caughtFish')
AddEventHandler('fivem_fishing:caughtFish', function(fish, weight)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local item = Player.getInventoryItem(fish['name'])
	local found = false
	for k,v in pairs(cachedFishScore) do
		if k == fish['name'] then
			found = true
			if v['weight'] < weight then
				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @charid', {['@charid'] = Player['identifier']}, function(charinfo)
					cachedFishScore[fish['name']] = {
						['owner'] = charinfo[1]['firstname']..' '..charinfo[1]['lastname'],
						['weight'] = weight,
						['name'] = fish['name']
					}
					MySQL.Async.execute('UPDATE fivem_fishing SET data = @data WHERE fish = @fish',{
						['@fish'] = fish['name'],
						['@data'] = json.encode(cachedFishScore[fish['name']])
					}, function()
						TriggerClientEvent('esx:showNotification', src, 'Your fish '..fish['label']..' took the lead at '..weight..'gram')
					end)
				end)
			end
		end
	end
	if not found then 
		MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @charid', {['@charid'] = Player['identifier']}, function(charinfo)
			cachedFishScore[fish['name']] = {
				['owner'] = charinfo[1]['firstname']..' '..charinfo[1]['lastname'],
				['weight'] = weight,
				['name'] = fish['name']
			}
			MySQL.Async.execute('UPDATE fivem_fishing SET data = @data WHERE fish = @fish',{
				['@fish'] = fish['name'],
				['@data'] = json.encode(cachedFishScore[fish['name']])
			}, function()
				TriggerClientEvent('esx:showNotification', src, 'Your fish '..fish['label']..' took the lead at '..weight..'gram')
			end)
		end)
	end
	if Player.canCarryItem(fish['name'], 1) then
		Player.addInventoryItem(fish['name'], 1)
	else
		TriggerClientEvent('esx:showNotification', src, 'You cannot carry any more fish and throw it back in the water')
	end
end)

RegisterServerEvent('strandatt_fishing:breakFishingRod')
AddEventHandler('strandatt_fishing:breakFishingRod', function()
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	Player.removeInventoryItem('fishingrod', 1)
end)

ESX.RegisterServerCallback('fivem_fishing:checkIfPlayerCanFish', function(source, cb)
    local Player = ESX.GetPlayerFromId(source)
	local fishingrod = Player.getInventoryItem('fishingrod')
	local bait = Player.getInventoryItem('bait')
	if fishingrod.count > 0 and bait.count > 0 then 
		Player.removeInventoryItem('bait', 1)
		cb(true)
	else
		cb(false)
	end
end)


RegisterServerEvent('strandatt_fishing:sellFish')
AddEventHandler('strandatt_fishing:sellFish', function()
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local cash = 0
	local foundFish = false
	for k,v in pairs(Config.Fishes) do
		local item = Player.getInventoryItem(k)
		if item.count > 0 then 
			foundFish = true
			cash = cash + (Config.Fishes[k]['price'] * item.count)
			Player.removeInventoryItem(k, item.count)
		end
	end
	if foundFish then
		Wait(100)
		Player.addMoney(cash)
		TriggerClientEvent('esx:showNotification', src, 'You sold all your fish for '..cash..'$')
	else
		TriggerClientEvent('esx:showNotification', src, 'You have no fish to sell')
	end
end)