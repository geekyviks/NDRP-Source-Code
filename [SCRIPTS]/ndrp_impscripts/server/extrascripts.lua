-- ESX Start

local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

-- ESX Marker

ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    if player ~= nil then
        local playerGroup = player.getGroup()
        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

-- AFK Warning

RegisterServerEvent('afkkick:kickplayer')
AddEventHandler('afkkick:kickplayer', function()
	DropPlayer(source,"You have been kicked for being AFK")
end)

-- Me Event

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
	local name = GetPlayerName(source)
	TriggerEvent('me:logging', source, name, text)
end)

-- Tackle Event

RegisterServerEvent('esx_kekke_tackle:tryTackle')
AddEventHandler('esx_kekke_tackle:tryTackle', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)
	TriggerClientEvent('esx_kekke_tackle:getTackled', targetPlayer.source, source)
	TriggerClientEvent('esx_kekke_tackle:playTackle', source)
end)

-- Carwash Events 

RegisterServerEvent('es_carwash:checkmoney')
AddEventHandler('es_carwash:checkmoney', function ()
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	if money >= 20 then
		xPlayer.removeMoney(20)
		TriggerClientEvent('es_carwash:success', source, price)
	else
		local moneyleft = 20 - money
		TriggerClientEvent('es_carwash:notenoughmoney', source, moneyleft)
	end
end)

-- Carry Events

RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
	if targetSrc ~= nil or targetSrc >= nil then
		TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
	end
end)

RegisterServerEvent('cmg2_animations:putVehicle')
AddEventHandler('cmg2_animations:putVehicle', function(target)
	TriggerClientEvent('cmg2_animations:putVehicle', target)
end)

RegisterServerEvent('extramenu:Pay')
AddEventHandler('extramenu:Pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		xPlayer.removeAccountMoney('bank', 1000)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You Paid $1000 from Bank!', 5000 })
	end
end)