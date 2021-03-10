ESX = nil
local copsConnected = 0
local requiredCops = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    ESX.RegisterUsableItem('red_satellite_phone', function(playerId)
        TriggerEvent('ndrp_base:checkCooldown', playerId, 'iq', 'red')
    end)
    
	ESX.RegisterUsableItem('golden_satellite_phone', function(playerId)
        TriggerEvent('ndrp_base:checkCooldown', playerId, 'iq', 'golden')
    end)
    
	ESX.RegisterUsableItem('green_satellite_phone', function(playerId)
        TriggerEvent('ndrp_base:checkCooldown', playerId, 'iq', 'green')
    end)
	
end)

RegisterNetEvent('ndrp_base:cooldownProceedIQ')
AddEventHandler('ndrp_base:cooldownProceedIQ', function(playerId, type)
    if type == 'red' then
        if CountCops() >= requiredCops then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            xPlayer.removeInventoryItem('red_satellite_phone', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'Contacting the Columbian Mafia...', length = 3000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            TriggerClientEvent('ndrp_200iq:drop', playerId, Config.Satellite.red.weapon, 250, 400.0)
            TriggerEvent('ndrp_base:setCoolDown')
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'What\'s the fun without cops?', length = 3000, style = { ['background-color'] = '#fff', ['color'] = '#000' } })
        end
    elseif type == 'golden' then
        if CountCops() >= requiredCops then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            xPlayer.removeInventoryItem('golden_satellite_phone', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'Contacting the Columbian Mafia...', length = 3000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            TriggerClientEvent('ndrp_200iq:drop', playerId, Config.Satellite.golden.weapon, 250, 400.0)
            TriggerEvent('ndrp_base:setCoolDown')
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'What\'s the fun without cops?', length = 3000, style = { ['background-color'] = '#fff', ['color'] = '#000' } })
        end
    elseif type == 'green' then
        if CountCops() >= requiredCops then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            xPlayer.removeInventoryItem('green_satellite_phone', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'Contacting the Columbian Mafia...', length = 3000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            TriggerClientEvent('ndrp_200iq:drop', playerId, Config.Satellite.green.weapon, 250, 400.0)
            TriggerEvent('ndrp_base:setCoolDown')
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'What\'s the fun without cops?', length = 3000, style = { ['background-color'] = '#fff', ['color'] = '#000' } })
        end
    end
end)

function CountCops()
    local xPlayers = ESX.GetPlayers()
    copsConnected = 0
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            copsConnected = copsConnected + 1
        end
    end
    return copsConnected
end

RegisterServerEvent('ndrp_200iq:inventoryCheck')
AddEventHandler('ndrp_200iq:inventoryCheck', function(codeMarkerName, machinepistol, heavypistol, appistol)
    local sourcePlayer = source
    local xPlayer
    while xPlayer == nil do
        xPlayer = ESX.GetPlayerFromId(source)
        Wait(10)
    end
    if codeMarkerName == 'machinepistol' then
        if xPlayer.getInventoryItem('electronics').count >= machinepistol['electronics'] and xPlayer.getInventoryItem('wire').count >= machinepistol['wire'] and xPlayer.getInventoryItem('scrap').count >= machinepistol['scrap'] and xPlayer.getMoney() >= machinepistol['money'] then
            xPlayer.removeInventoryItem('electronics', machinepistol['electronics'])
            xPlayer.removeInventoryItem('wire', machinepistol['wire'])
            xPlayer.removeInventoryItem('scrap', machinepistol['scrap'])
            xPlayer.removeMoney(machinepistol['money'])
            xPlayer.addInventoryItem('WEAPON_MACHINEPISTOL', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You received a Machine Pistol!', length = 4000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You need: ' .. tostring(machinepistol['electronics']) .. ' electronics, ' .. tostring(machinepistol['wire']) .. ' wires, ' .. tostring(machinepistol['scrap']) .. ' scraps, ' .. tostring(machinepistol['money']) .. ' dollars!', length = 10000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        end
    elseif codeMarkerName == 'heavypistol' then
        if xPlayer.getInventoryItem('electronics').count >= heavypistol['electronics'] and xPlayer.getInventoryItem('wire').count >= heavypistol['wire'] and xPlayer.getInventoryItem('scrap').count >= heavypistol['scrap'] and xPlayer.getMoney() >= heavypistol['money'] then
            xPlayer.removeInventoryItem('electronics', heavypistol['electronics'])
            xPlayer.removeInventoryItem('wire', heavypistol['wire'])
            xPlayer.removeInventoryItem('scrap', heavypistol['scrap'])
            xPlayer.removeMoney(heavypistol['money'])
            xPlayer.addInventoryItem('WEAPON_HEAVYPISTOL', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You received a Heavy Pistol!', length = 4000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You need: ' .. tostring(heavypistol['electronics']) .. ' electronics, ' .. tostring(heavypistol['wire']) .. ' wires, ' .. tostring(heavypistol['scrap']) .. ' scraps, ' .. tostring(heavypistol['money']) .. ' dollars!', length = 10000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        end
    elseif codeMarkerName == 'appistol' then
        if xPlayer.getInventoryItem('electronics').count >= appistol['electronics'] and xPlayer.getInventoryItem('wire').count >= appistol['wire'] and xPlayer.getInventoryItem('scrap').count >= appistol['scrap'] and xPlayer.getMoney() >= appistol['money'] then
            xPlayer.removeInventoryItem('electronics', appistol['electronics'])
            xPlayer.removeInventoryItem('wire', appistol['wire'])
            xPlayer.removeInventoryItem('scrap', appistol['scrap'])
            xPlayer.removeMoney(appistol['money'])
            xPlayer.addInventoryItem('WEAPON_APPISTOL', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You received an AP Pistol!', length = 4000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You need: ' .. tostring(appistol['electronics']) .. ' electronics, ' .. tostring(appistol['wire']) .. ' wires, ' .. tostring(appistol['scrap']) .. ' scraps, ' .. tostring(appistol['money']) .. ' dollars!', length = 10000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        end
    end
end)

RegisterServerEvent('ndrp_200iq:cardCheck')
AddEventHandler('ndrp_200iq:cardCheck', function()
    local sourcePlayer = source
    local xPlayer
    while xPlayer == nil do
        xPlayer = ESX.GetPlayerFromId(source)
        Wait(10)
    end
    if xPlayer.getInventoryItem('card_death').count >= 1 or xPlayer.getInventoryItem('card_famine').count >= 1 or xPlayer.getInventoryItem('card_pestilence').count >= 1 or xPlayer.getInventoryItem('card_war').count >= 1 then
        TriggerClientEvent('ndrp_200iq:cardCheckResult', sourcePlayer, true)
    else
        TriggerClientEvent('ndrp_200iq:cardCheckResult', sourcePlayer, false)
    end
end)

RegisterServerEvent('ndrp_200iq:checkpolice')
AddEventHandler('ndrp_200iq:checkpolice', function(dropCoords, street)
   local xPlayers, xPlayer = ESX.GetPlayers(), nil
	for i=1, #xPlayers, 1 do
		xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'weazelnews' then
			TriggerClientEvent('ndrp_200iq:policeresponce', xPlayers[i], dropCoords, street)
		end
	end
end)

RegisterServerEvent('ndrp_200iq:givePhone')
AddEventHandler('ndrp_200iq:givePhone', function(type, price, coords)
    lcoords = coords
    local sourcePlayer = source
    local xPlayer
    while xPlayer == nil do
        xPlayer = ESX.GetPlayerFromId(source)
        Wait(10)
    end
    if type == 'red' then
        if xPlayer.getMoney() >= price then
            if xPlayer.canCarryItem('red_satellite_phone', 1) then
                xPlayer.removeMoney(price)
                xPlayer.addInventoryItem('red_satellite_phone', 1)
                TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You received a Red Satellite Phone', length = 5000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'Not enough space in your inventory!', length = 5000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You need $' .. price .. ' for this phone!', length = 7000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        end
    elseif type == 'golden' then
        if xPlayer.getMoney() >= price then
            if xPlayer.canCarryItem('golden_satellite_phone', 1) then
                xPlayer.removeMoney(price)
                xPlayer.addInventoryItem('golden_satellite_phone', 1)
                TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You received a Golden Satellite Phone', length = 5000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'Not enough space in your inventory!', length = 5000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You need $' .. price .. ' for this phone!', length = 7000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        end
    elseif type == 'green' then
        if xPlayer.getMoney() >= price then
            if xPlayer.canCarryItem('green_satellite_phone', 1) then
                xPlayer.removeMoney(price)
                xPlayer.addInventoryItem('green_satellite_phone', 1)
                TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You received a Green Satellite Phone', length = 5000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'Not enough space in your inventory!', length = 5000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You need $' .. price .. ' for this phone!', length = 7000, style = { ['background-color'] = '#000', ['color'] = '#fff' } })
        end
    end
end)