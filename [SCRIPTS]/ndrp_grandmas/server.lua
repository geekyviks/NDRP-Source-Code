ESX             = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ndrp_grandmas:payBill')
AddEventHandler('ndrp_grandmas:payBill', function()
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	--change price here for revive
	xPlayer.removeBank(1000)
    TriggerClientEvent('esx:showNotification', src, 'You Were Billed For $1,000.')
end)