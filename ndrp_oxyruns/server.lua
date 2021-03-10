ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Oxy Run

RegisterServerEvent('ndrp_oxy:server')
AddEventHandler('ndrp_oxy:server', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 1500 then
		xPlayer.removeMoney(1500)
		TriggerClientEvent("ndrp_oxy:startDealing", source)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t have money for the delivery' })
	end
end)

RegisterServerEvent('ndrp_oxy:receiveBigRewarditem')
AddEventHandler('ndrp_oxy:receiveBigRewarditem', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('safecracker', 1)
end)

RegisterServerEvent('ndrp_oxy:receiveoxy')
AddEventHandler('ndrp_oxy:receiveoxy', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local payment = math.random(350, 450)
	xPlayer.addMoney(payment / 2)
	xPlayer.addInventoryItem('oxy', 1)
end)

RegisterServerEvent('ndrp_oxy:receivemoneyyy')
AddEventHandler('ndrp_oxy:receivemoneyyy', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local payment = math.random(350, 450)
	xPlayer.addMoney(payment)
end)