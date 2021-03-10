ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterServerEvent('esx_joblisting:setJob')
AddEventHandler('esx_joblisting:setJob', function(job)
    TriggerClientEvent('ndrp_hack:updateJobBlip', source, job)
end)

RegisterServerEvent("ndrp_hack:setElectronics")
AddEventHandler("ndrp_hack:setElectronics", function()
    local player = ESX.GetPlayerFromId(source)
    local countx = math.random(0, 3)
    player.addMoney(150)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, 
    { 
        type = 'inform', 
        text = 'You have received $150 for this job', 
        length = 2500, 
        style = { ['background-color'] = '#006699', ['color'] = '#FFFFFF' } 
    })
    if player.canCarryItem('electronics', countx) and countx > 0 then
        player.addInventoryItem("electronics", countx)
       
        TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'success', 
				text = 'Success! You received ' .. countx .. ' electronics as a gift', 
				length = 3500, 
			})
    elseif player.canCarryItem('electronics', countx) and countx == 0 then 

		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'success', 
			text = 'You did a good job', 
			length = 2500, 
        })
    
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'success', 
			text = 'You did a good job', 
			length = 2500, 
        })

        TriggerClientEvent('mythic_notify:client:SendAlert', source, 
		{ 
			type = 'error', 
			text = 'Your inventory is full', 
			length = 3500, 
		})
    end
end)
