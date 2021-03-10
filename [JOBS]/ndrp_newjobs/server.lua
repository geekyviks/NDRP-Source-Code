ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('ndrp_newjobs:makecoffee')
AddEventHandler('ndrp_newjobs:makecoffee', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == nil then
		Wait(100)
		xPlayer = ESX.GetPlayerFromId(source)
	end
	
	xPlayer.removeInventoryItem("milk", 2)
	xPlayer.removeInventoryItem("coffeepowder", 1 )
	xPlayer.removeInventoryItem("suger", 1)
	xPlayer.removeInventoryItem("water", 2)
	xPlayer.addInventoryItem("coffee", 3)
	
end)


RegisterServerEvent('ndrp_newjobs:makeburger')
AddEventHandler('ndrp_newjobs:makeburger', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _type = type
	
	if xPlayer == nil then
		Wait(100)
		xPlayer = ESX.GetPlayerFromId(source)
	end

	xPlayer.removeInventoryItem("bun", 4)
	xPlayer.removeInventoryItem("cheese", 1 )
	xPlayer.removeInventoryItem("sauce", 1)
	xPlayer.removeInventoryItem("veggies", 1)

	if _type == 'veg' then
		xPlayer.removeInventoryItem("vegpatty", 4)
		xPlayer.addInventoryItem("vegburger", 4)
	elseif _type == 'chicken' then 
		xPlayer.removeInventoryItem("chickenpatty", 4)
		xPlayer.addInventoryItem("chickenburger", 4)
	elseif _type == 'mimi' then
		xPlayer.removeInventoryItem("chickenpatty", 4)
		xPlayer.removeInventoryItem("fishpatty", 4)
		xPlayer.addInventoryItem("mimiburger", 4)
	end
	
end)
