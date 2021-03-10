ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("esx_miner:givestone")
AddEventHandler("esx_miner:givestone", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.canCarryItem('stones', 5) then
				xPlayer.addInventoryItem('stones', 5)
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
					type = 'inform', 
					text = 'Collected 5 Stones', 
					length = 3000, 
					style = { ['background-color'] = '#FFFFFF', ['color'] = '#000000'}
				})
            else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
					type = 'error', 
					text = 'You don\'t have space for more', 
					length = 3000, 
				})
			end
        end
end)
    
RegisterNetEvent("esx_miner:washing")
AddEventHandler("esx_miner:washing", function(item, count)
    
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        
		if xPlayer ~= nil then
            
			if xPlayer.getInventoryItem('stones').count > 9 then
                
				TriggerClientEvent("esx_miner:washing", source)
                Citizen.Wait(15900)
                xPlayer.addInventoryItem('washedstones', 10)
                xPlayer.removeInventoryItem("stones", 10)
				
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
					type = 'inform', 
					text = 'You washed 10 stones', 
					length = 3000, 
					style = { ['background-color'] = '#FFFFFF', ['color'] = '#000000'}
				})
				
            elseif xPlayer.getInventoryItem('stones').count < 10 then
                
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
					type = 'error', 
					text = 'You washed all the stones', 
					length = 3000, 
				})
				
            end
			
        end
end)

RegisterNetEvent("esx_miner:remelting")
AddEventHandler("esx_miner:remelting", function(item, count)
    
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local randomChance = math.random(1, 100)
        
		if xPlayer ~= nil then
            if xPlayer.getInventoryItem('washedstones').count > 9 then
                TriggerClientEvent("esx_miner:remelting", source)
                Citizen.Wait(15900)
                
				if randomChance < 6 then
                    xPlayer.addInventoryItem("diamond", 1)
                    xPlayer.removeInventoryItem("washedstones", 10)
					
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
					{ 
						type = 'inform', 
						text = 'You got a Diamond', 
						length = 3000, 
						style = { ['background-color'] = '#008000', ['color'] = '#FFFFFF'}
					})
				
                elseif randomChance > 6 and randomChance < 25 then
                    xPlayer.addInventoryItem("gold", 5)
                    xPlayer.removeInventoryItem("washedstones", 10)
					
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
					{ 
						type = 'inform', 
						text = 'You got 5 Gold', 
						length = 3000, 
						style = { ['background-color'] = '#DAA520', ['color'] = '#000000'}
					})
				
				elseif randomChance > 24 and randomChance < 50 then
                    xPlayer.addInventoryItem("iron", 10)
                    xPlayer.removeInventoryItem("washedstones", 10)
					
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
					{ 
						type = 'inform', 
						text = 'You got 10 Iron', 
						length = 3000, 
						style = { ['background-color'] = '#C0C0C0', ['color'] = '#000000'}
					})
					
			   elseif randomChance > 49 then
                    xPlayer.addInventoryItem("copper", 20)
                    xPlayer.removeInventoryItem("washedstones", 10)
					
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
					{ 
						type = 'inform', 
						text = 'You got 20 Copper', 
						length = 3000, 
						style = { ['background-color'] = '#8b490b', ['color'] = '#fffff'}
					})
                    
                end
            
			elseif xPlayer.getInventoryItem('stones').count < 10 then
                
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
					{ 
						type = 'error', 
						text = 'Not enought washed stones to melt!', 
						length = 3000, 
					})
            end
        end
end)

RegisterNetEvent("esx_miner:selldiamond")
AddEventHandler("esx_miner:selldiamond", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('diamond').count > 0 then
                local pieniadze = Config.DiamondPrice
                xPlayer.removeInventoryItem('diamond', 1)
                xPlayer.addMoney(pieniadze)
                
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
						type = 'inform', 
						text = 'You sold a Diamond for $'.. pieniadze .. ' .' ,
						length = 3000, 
						style = { ['background-color'] = '#008000', ['color'] = '#FFFFFF'}
				}) 
				
            elseif xPlayer.getInventoryItem('diamond').count < 1 then
                
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
						type = 'error', 
						text = 'You don\'t have a Diamond', 
						length = 3000, 
						
				})
				
            end
        end
    end)

RegisterNetEvent("esx_miner:sellgoldbar")
AddEventHandler("esx_miner:sellgoldbar", function(item, count)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		local goldbarc = xPlayer.getInventoryItem('goldbar').count
		if goldbarc > 0 then
			local pieniadze = 500 * goldbarc
			xPlayer.removeInventoryItem('goldbar', goldbarc)
			xPlayer.addMoney(pieniadze)
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
			{ 
				type = 'inform', 
				text = 'You sold ' .. goldbarc .. 'x goldbar for $'.. pieniadze .. ' .' ,
				length = 3000, 
				style = { ['background-color'] = '#008000', ['color'] = '#FFFFFF'}
			}) 
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
			{ 
				type = 'error', 
				text = 'You don\'t have a Goldbar', 
				length = 3000, 
			})
		end
	end
end)


RegisterNetEvent("esx_miner:sellgold")
AddEventHandler("esx_miner:sellgold", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('gold').count > 4 then
                
				local pieniadze = Config.GoldPrice
                xPlayer.removeInventoryItem('gold', 5)
                xPlayer.addMoney(pieniadze)
				
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
					type = 'inform', 
					text = 'You sold 5 Gold for $'.. pieniadze .. ' .' ,
					length = 3000, 
					style = { ['background-color'] = '#DAA520', ['color'] = '#000000'}
				}) 
            
			elseif xPlayer.getInventoryItem('gold').count < 5 then
                
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
						type = 'error', 
						text = 'You don\'t have enough gold to sell', 
						length = 3000, 
						
				})
				
            end
        end
end)

RegisterNetEvent("esx_miner:selliron")
AddEventHandler("esx_miner:selliron", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('iron').count > 9 then
                local pieniadze = Config.IronPrice
                xPlayer.removeInventoryItem('iron', 10)
                xPlayer.addMoney(pieniadze)
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
					{ 
						type = 'inform', 
						text = 'You sold 10 Iron for $'.. pieniadze ..'.' ,
						length = 3000, 
						style = { ['background-color'] = '#C0C0C0', ['color'] = '#000000'}
					}) 
                
            elseif xPlayer.getInventoryItem('iron').count < 10 then
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
				{ 
						type = 'error', 
						text = 'You don\'t have enough Iron to sell', 
						length = 3000, 
						
				})
            end
        end
    end)

RegisterNetEvent("esx_miner:sellcopper")
AddEventHandler("esx_miner:sellcopper", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('copper').count > 19 then
                local pieniadze = Config.CopperPrice
                xPlayer.removeInventoryItem('copper', 20)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, 
					{ 
						type = 'inform', 
						text = 'You sold 20 Copper for $'.. pieniadze ..'.' ,
						length = 3000, 
						style = { ['background-color'] = '#8b490b', ['color'] = '#fffff'}
					}) 
            elseif xPlayer.getInventoryItem('copper').count < 20 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, 
				{ 
						type = 'error', 
						text = 'You don\'t have enough Iron to sell', 
						length = 3000, 
				})
            end
        end
end)

local miners = {}

RegisterNetEvent("ndrp_mining:startmining")
AddEventHandler("ndrp_mining:startmining", function(stone)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    
	if miners[xPlayer.identifier] == nil then
        miners[xPlayer.identifier] = {}
    end
    
	local stones = miners[xPlayer.identifier].stones
    
	if stones == nil then
        stones = 0
	end

	local time, cooldown = miners[xPlayer.identifier].time, miners[xPlayer.identifier].cooldown

	if time == nil then
		time = 0
	end
	if cooldown == nil then
		cooldown = false
	end

	local timeNow = os.time()
	if cooldown and timeNow - time < 60 then
		TriggerClientEvent('ndrp_mining:startmining',_source,2)
		return
	else
		miners[xPlayer.identifier].cooldown = false
		miners[xPlayer.identifier].time = 0
	end
	local pickaxe = xPlayer.getInventoryItem('pickaxe').count
	
	if xPlayer.canCarryItem('stones', 5) then
        if pickaxe >= 1 then
            if stones + 5 < 100 then
                miners[xPlayer.identifier] = {stones = stones + 5, time = 0, cooldown = false}
                TriggerClientEvent('ndrp_mining:startmining',_source,1)
            else
                miners[xPlayer.identifier].time = {stones = stones + 5, time = timeNow, cooldown = true}
                TriggerClientEvent('ndrp_mining:startmining',_source,2)
            end
        else
            TriggerClientEvent('ndrp_mining:startmining',_source,3)
        end
    else
        TriggerClientEvent('ndrp_mining:startmining',_source,4)
    end
end)