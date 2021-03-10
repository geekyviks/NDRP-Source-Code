ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local recordedTime = 0
local cooldowntime = 10*60

RegisterServerEvent('ndrp_hsbolo:startMissionServer')
AddEventHandler('ndrp_hsbolo:startMissionServer', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local cops = 0

	for i=1, #xPlayers, 1 do
		local xPlayerZ = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayerZ.job.name == 'police' then
			cops = cops + 1
		end
	end

    if xPlayer ~= nil then
        local xname = xPlayer.getName()
        local time = os.time()
        local timeGap = time - recordedTime
        if cops > 2 then 
            if timeGap > cooldowntime then
                local count = xPlayer.getInventoryItem('red_bills').count
                if count ~= nil and count < 1 then
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You don\'t have a red bill', length = 2500 })
                else
                    xPlayer.removeInventoryItem('red_bills',1)
                    recordedTime = time
                    TriggerClientEvent('ndrp_hsbolo:startMission', _source)
                    TriggerEvent('hsboloMission:logs',_source,xname)
                end
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'No vehicle is available at the moment', length = 2500 })
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'What\'s the fun without cops?', length = 2500 })
        end
    end
end)

RegisterServerEvent('ndrp_hsbolo:alertcops')
AddEventHandler('ndrp_hsbolo:alertcops', function(type)
    if type == 'done' then
        TriggerClientEvent('ndrp_hsbolo:alertcopsC',-1,'done')
    else
        TriggerClientEvent('ndrp_hsbolo:alertcopsC',-1,'start')
    end
end)

RegisterServerEvent('ndrp_hsbolo:reward')
AddEventHandler('ndrp_hsbolo:reward', function(type)
    if type == 'done' then 
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            local xname = xPlayer.getName()
            xPlayer.addInventoryItem('red_bills',1)
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You got 2 Red bills', length = 2500 })
            TriggerEvent('hsboloReward:logs',_source,xname,'red_bills')
        end
    end
end)