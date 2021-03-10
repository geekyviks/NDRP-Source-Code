ESX = nil
local lastStarted = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_grove', function(account)
		societyAccountGrove = account
	end)

RegisterServerEvent('esx_uberkdshfksksdhfskdjjob:pay')
AddEventHandler('esx_uberkdshfksksdhfskdjjob:pay', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(amount))
	TriggerEvent('InteractSound_CL:PlayOnOne', 'done', 0.4)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
				type = 'inform', 
				text = 'You have received $'.. amount ..' for this delivery', 
				length = 5000, 
				style = { ['background-color'] = '#12B296', ['color'] = '#FFFFFF'}
		})
end)


RegisterServerEvent('esx_uberkdshfksksdhfskdjjob:tip')
AddEventHandler('esx_uberkdshfksksdhfskdjjob:tip', function()
    
	local player = ESX.GetPlayerFromId(source)
    local lucky = math.random(0, 70)

    if lucky >= 0 and lucky <= 29 then
	
		if player.canCarryItem('water', 1) then
			
			player.addInventoryItem("water", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'You got tip: A Water Bottle', 
				length = 2500, 
				style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
			})
		
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You got a tip but your inventory is full', 
				length = 3000, 
			})
		
		end
	
		
	elseif lucky >= 30 and lucky <= 39 then
	
       if player.canCarryItem('bread', 1) then
			
			player.addInventoryItem("bread", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'You got tip: A Burger', 
				length = 2500, 
				style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
			})
		
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You got a tip but your inventory is full', 
				length = 3000, 
			})
		
		end
		
	elseif lucky >= 40 and lucky <= 49 then
	
	    if player.canCarryItem('bandage', 1) then
			
			player.addInventoryItem("bandage", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'You got tip: A Bandage', 
				length = 2500, 
				style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
			})
		
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You got a tip but your inventory is full', 
				length = 3000, 
			})
		
		end
	
	elseif lucky >= 50 and lucky <= 55 then	
	
	
		if player.canCarryItem('medikit', 1) then
			
			player.addInventoryItem("medikit", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'You got tip: A Medikit', 
				length = 2500, 
				style = { ['background-color'] = '#12B296', ['color'] = '#FFFFFF' } 
			})
		
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You got a tip but your inventory is full', 
				length = 3000, 
			})
		
		end
	
		
	elseif lucky >= 56 and lucky <= 59 then	
		
		if player.canCarryItem('adrenaline', 1) then
			
			player.addInventoryItem("adrenaline", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'You got tip: An adrenaline', 
				length = 2500, 
				style = { ['background-color'] = '#12B296', ['color'] = '#FFFFFF' } 
			})
		
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You got a tip but your inventory is full', 
				length = 3000, 
			})
		
		end
	
	elseif lucky == 60 then	
	
		if player.canCarryItem('wire', 1) then
			
			player.addInventoryItem("wire", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'You got tip: A wire', 
				length = 2500, 
				style = { ['background-color'] = '#B29912', ['color'] = '#FFFFFF' }
			})
		
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You got a tip but your inventory is full', 
				length = 3000, 
			})
		
		end
		
		
	elseif lucky >= 61 and lucky <= 65 then	
		
		if player.canCarryItem('repairkit', 1) then
			
			player.addInventoryItem("repairkit", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'You got tip: A Repairkit', 
				length = 2500, 
				style = { ['background-color'] = '#12B296', ['color'] = '#FFFFFF' } 
			})
		
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You got a tip but your inventory is full', 
				length = 3000, 
			})
		
		end
		
	elseif lucky == 66 then
		
		if player.canCarryItem('raspberry', 1) then
			
			player.addInventoryItem("raspberry", 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'inform', 
				text = 'You got tip: A Raspberry Pi', 
				length = 2500, 
				style = { ['background-color'] = '#B29912', ['color'] = '#FFFFFF' }
			})
		
		else
		
			TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'You got a tip but your inventory is full', 
				length = 3000, 
			})
		
		end
		
	else
		
    end
end)


