ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ndrp_cops:playerData')
AddEventHandler('ndrp_cops:playerData', function()
    Citizen.CreateThread(function()
        local xPlayers = ESX.GetPlayers()
        if xPlayers ~= nil then
            local players = {}
            for i=1, #xPlayers, 1 do
	    	    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	    	    table.insert(players, {
	    		    source = xPlayer.source,
	    		    identifier = xPlayer.identifier,
	    		    name = xPlayer.name,
	    		    job = xPlayer.job
	    	    })
            end
            TriggerClientEvent('ndrp_cops:updateBlips',-1,players)
        end
    end)
end)