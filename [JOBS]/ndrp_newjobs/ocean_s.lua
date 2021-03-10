ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent("ndrp_ocean:collected")
AddEventHandler("ndrp_ocean:collected", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local label = xPlayer.getInventoryItem(item).label 
    if xPlayer ~= nil then
        if xPlayer.canCarryItem(item,1) then
            xPlayer.addInventoryItem(item, 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Found '.. label .." "})
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Not enough space'})
        end
	end
end)