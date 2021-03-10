local ESX = nil
local airdroploot = 0

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)

ESX.RegisterServerCallback('ndrp_airdrops:hasMoney', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    local money  = player.getMoney()
	local status = 0
	local canloot = false
	if (os.time() - airdroploot) < Config.Timex and airdroploot ~= 0 then
		cb(status)
	else
		if money >= 1000 then
			status = 1
			cb(status)
		else
			status = 0
			cb(status)
		end
	end
		
end)


RegisterServerEvent("ndrp_airdrop:collected")
AddEventHandler("ndrp_airdrop:collected", function()
    
    airdroploot = os.time()
			
end)

RegisterServerEvent("ndrp_airdrop:timing")
AddEventHandler("ndrp_airdrop:timing", function()
    
	if (os.time() - airdroploot) < Config.Timex and airdroploot ~= 0 then

		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'New plane will be available soon. Come back later', --be available in ' .. (Config.Timex - (os.time() - airdroploot)) .. ' seconds',
				length = 3000, 
			})
	else
		
		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You don\'t have enough money to rent',
				length = 3000, 
			})
	
	end
			
end)


RegisterServerEvent("ndrp_airdrop:airdrop")
AddEventHandler("ndrp_airdrop:airdrop", function()
    
	local player = ESX.GetPlayerFromId(source)

    local brick = math.random(1, 1)

   player.addInventoryItem("cbrick", brick)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, 
	{ 
				type = 'inform', 
				text = 'Reward Received', 
				length = 3500, 
				style = { ['background-color'] = '#B29912', ['color'] = '#FFFFFF' } 
	})
			
end)

RegisterServerEvent("ndrp_airdrop:rent")
AddEventHandler("ndrp_airdrop:rent", function()
    
	local player = ESX.GetPlayerFromId(source)
	local money  = player.getMoney()
	
	
	if money >= 1000 then
				
		
		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'inform', 
			text = 'You rented a plane for $1000', 
			length = 2500, 
			style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
		})
		
		player.removeMoney(1000)
		
	else
			
		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'inform', 
			text = 'You don\'t have enough money to rent', 
			length = 2500, 
			style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
		})
	end
end)

RegisterServerEvent("ndrp_airdrop:paid")
AddEventHandler("ndrp_airdrop:paid", function()
    
	local player = ESX.GetPlayerFromId(source)
	player.addMoney(1000)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, 
	{ 
				type = 'inform', 
				text = 'You got back your $1000', 
				length = 2500, 
				style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
	})
		
	
end)

RegisterServerEvent('ndrp_airdrop:processCocaine')
AddEventHandler('ndrp_airdrop:processCocaine', function()
	

				local xPlayer = ESX.GetPlayerFromId(source)
				local xCbrick = xPlayer.getInventoryItem('cbrick')

				if not xPlayer.canCarryItem('cocaine', 10) then
				
					TriggerClientEvent('mythic_notify:client:SendAlert', source, 
					{ 
						type = 'inform', 
						text = 'You don\'t have space', 
						length = 2500, 
						style = { ['background-color'] = '#ff0000', ['color'] = '#FFFFFF' } 
					})
			
				elseif xCbrick.count < 1 then	
			
					TriggerClientEvent('mythic_notify:client:SendAlert', source, 
					{ 
						type = 'inform', 
						text = 'You don\'t have any brick to process', 
						length = 2500, 
						style = { ['background-color'] = '#ff0000', ['color'] = '#FFFFFF' } 
					})
			
				else
					xPlayer.removeInventoryItem('cbrick', 1)
					xPlayer.addInventoryItem('cocaine', 10)
				
					TriggerClientEvent('mythic_notify:client:SendAlert', source, 
					{ 
						type = 'inform', 
						text = 'Collected 10 Cocaine Bags', 
						length = 4000, 
						style = { ['background-color'] = '#006600', ['color'] = '#FFFFFF' } 
					})
				end
end)