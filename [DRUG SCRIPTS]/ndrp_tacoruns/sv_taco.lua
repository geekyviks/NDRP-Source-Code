ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sh1no-serveretkontrol')
AddEventHandler('sh1no-serveretkontrol', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem("syosun").count >= 10 then
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You cannot carry any more bacon!', length = 5000 })
    else
        if xPlayer.getInventoryItem('sstone').count > 0 then
            TriggerClientEvent("sh1no-tacoetkontrol", _source)
            xPlayer.removeInventoryItem("sstone", 1)
            xPlayer.addInventoryItem("syosun", 1)
            Citizen.Wait(10500)
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'You cooked bacon for taco', length = 3000 })
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You have no meat to cook', length = 5000 })
        end
    end
end)

RegisterServerEvent('sh1no-etlitaco')
AddEventHandler('sh1no-etlitaco', function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil then
        if xPlayer.getInventoryItem("staco").count >= 10 then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You can\'t carry any more tacos!', length = 5000 })
        else    
            if xPlayer.getInventoryItem('mackerel').count > 0 and xPlayer.getInventoryItem('salmon').count > 0 and xPlayer.getInventoryItem('crawfish').count > 0 and xPlayer.getInventoryItem('syosun').count > 0 then
                xPlayer.removeInventoryItem("mackerel", 1)
                xPlayer.removeInventoryItem("salmon", 1)
                xPlayer.removeInventoryItem("syosun", 1)
                xPlayer.addInventoryItem("staco", 1)
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You prepared a taco', length = 3000 })
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You need a cooked bacon, mackerel and salmon!', length = 5000 })
            end
        end
    end
end)

RegisterServerEvent('sh1no-fishtacoyaptim')
AddEventHandler('sh1no-fishtacoyaptim', function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil then
        if xPlayer.getInventoryItem("sfishtaco").count >= 10 then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You can\'t carry more fish tacos!', length = 5000 })
        else   
            if xPlayer.getInventoryItem('mackerel').count > 0 and xPlayer.getInventoryItem('salmon').count > 0 and xPlayer.getInventoryItem('crawfish').count > 0 then
                xPlayer.removeInventoryItem("mackerel", 1)
                xPlayer.removeInventoryItem("salmon", 1)
                xPlayer.removeInventoryItem("crawfish", 1)
                xPlayer.addInventoryItem("sfishtaco", 1)
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You prepared a fish taco', length = 3000 })
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You need a crawfish, mackerel and salmon!', length = 5000 })
            end
        end
    end
end)

RegisterServerEvent('sh1no-tacopaketledim')
AddEventHandler('sh1no-tacopaketledim', function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil then
        if xPlayer.getInventoryItem("spaketlenmistaco").count >= 10 then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You can\'t carry any more packaged tacos!', length = 5000 })
        else     
            if xPlayer.getInventoryItem('sfishtaco').count > 0 then
                xPlayer.removeInventoryItem("sfishtaco", 1)
                xPlayer.addInventoryItem("spaketlenmistaco", 1)
                Citizen.Wait(10500)
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'You packed fish taco for delivery', length = 3000 })
            else
                if xPlayer.getInventoryItem('staco').count > 0 then
                    xPlayer.removeInventoryItem("staco", 1)
                    xPlayer.addInventoryItem("spaketlenmistaco", 1)
                    Citizen.Wait(10500)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'You packed a taco for delivery', length = 3000 })
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'No tacos to pack!', length = 5000 })
                end
            end
        end
    end
end)

RegisterNetEvent('sh1no-parakontrol')
AddEventHandler('sh1no-parakontrol', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if(xPlayer.getMoney() >= 50) then
        xPlayer.removeMoney(50)
        TriggerClientEvent("banking:removeCash", _source, 50)
        TriggerClientEvent('banking:updateCash', _source, xPlayer.getMoney())
        TriggerClientEvent('sh1no-kontrolgecti', source) -- true
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You paid $50', length = 5000 })
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You don\'t have enough money!', length = 5000 })
	end
end)

RegisterServerEvent('sh1no-tacouyusturucukontrol')
AddEventHandler('sh1no-tacouyusturucukontrol', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('spaketlenmistaco').count > 0 and xPlayer.getInventoryItem('marijuana').count > 0 then
        xPlayer.removeInventoryItem("marijuana", 1)
        xPlayer.removeInventoryItem("spaketlenmistaco", 1)
        xPlayer.addMoney(1200)
        TriggerClientEvent("banking:addCash", _source, 1200)
        TriggerClientEvent('banking:updateCash', _source, xPlayer.getMoney())
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Well Done! Delivery succesful', length = 3000 })
    else
        if xPlayer.getInventoryItem('spaketlenmistaco').count > 0 then
            xPlayer.removeInventoryItem("spaketlenmistaco", 1)
            xPlayer.addMoney(800)
            TriggerClientEvent("banking:addCash", _source, 800)
            TriggerClientEvent('banking:updateCash', _source, xPlayer.getMoney())
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Delivery succesful!', length = 2500 })
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You don\'t have packed tacos ', length = 2500 })
        end
    end
end)