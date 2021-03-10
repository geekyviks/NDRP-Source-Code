ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('duty:onoff')
AddEventHandler('duty:onoff', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    if job == 'police' or job == 'ambulance' then
        xPlayer.setJob('off' ..job, grade)
        TriggerEvent('ndrp_timetracker:dutyStop', _source)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You went OFF duty', length = 1500, style = { ['background-color'] = '#B22222', ['color'] = '#ffffff' } })
    elseif job == 'offpolice' then
        xPlayer.setJob('police', grade)
        TriggerClientEvent('ndrp_scripts:isPolice', _source, true)
        TriggerEvent('ndrp_timetracker:dutyStart', _source, false)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You went ON duty', length = 1500, style = { ['background-color'] = '#228B22', ['color'] = '#ffffff' } })
   
    elseif job == 'offambulance' then
        xPlayer.setJob('ambulance', grade)
        TriggerEvent('ndrp_timetracker:dutyStart', _source, false)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You went ON duty', length = 1500, style = { ['background-color'] = '#228B22', ['color'] = '#ffffff' } })
    end

end)

RegisterCommand('emsr', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local patient = tonumber(args[1])
    local message = args[2]
    if job ~= nil and job == "ambulance" then
        if patient ~= nil then 
            if message == "yes" then
                TriggerClientEvent('chat:addMessage', patient, { templateId = 'admindm', args = {'EMS', ' We are on the way. Please wait'}})
            elseif message == "no" then
                TriggerClientEvent('chat:addMessage', patient, { templateId = 'admindm', args = {'EMS', ' We can not come to your position. Pray to god'}})
            end
        end
    end    
end)

RegisterServerEvent('sendChatMessage')
AddEventHandler('sendChatMessage', function(message)
    local _source = source
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job ~= nil and xPlayer.job.name == 'police' then
            TriggerClientEvent('chat:addMessage', xPlayers[i], {templateId = 'outlaw', args = {'^1Dispatch ', message}})
        end
    end
end)

RegisterNetEvent('ndrp_customfine:sendFine')
AddEventHandler('ndrp_customfine:sendFine', function(culprit, amount, message) 
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local name = xPlayer.getName()
    local xTarget = ESX.GetPlayerFromId(culprit)
    local cName = xTarget.getName()
    TriggerClientEvent('ndrp_customfine:receiveFine',culprit, amount, message, name)
    TriggerEvent('police:fine', _source, name, amount, message, cName)
end)

RegisterNetEvent('ndrp_customfine:payFine')
AddEventHandler('ndrp_customfine:payFine', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeAccountMoney('bank', amount)
end)