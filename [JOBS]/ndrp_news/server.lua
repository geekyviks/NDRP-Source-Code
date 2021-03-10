ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterCommand("cam", function(source, args, raw)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name

    if job == 'weazelnews' then
        local src = source
        TriggerClientEvent("Cam:ToggleCam", src)
    end
end)

RegisterCommand("mic", function(source, args, raw)
    
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name

    if job == 'weazelnews' then
        local src = source
        TriggerClientEvent("Mic:ToggleMic", src)
    end
    
end)
