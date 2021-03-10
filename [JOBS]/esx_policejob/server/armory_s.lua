local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_policeArmory:takeWeapon")
AddEventHandler("esx_policeArmory:takeWeapon", function(weapon,giveAmmo)
    local player = ESX.GetPlayerFromId(source)
    if player then
        player.addWeapon(weapon, Config.AmmoAmmount)
		if giveAmmo then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You took ' .. ESX.GetWeaponLabel(weapon) ..  ' with '.. Config.AmmoAmount .. ' bullet'})
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You took ' ..ESX.GetWeaponLabel(weapon)}) 
        end
    end
end)

RegisterServerEvent("esx_policeArmory:getWeapon")
AddEventHandler("esx_policeArmory:getWeapon", function(weapon,ammo,giveAmmo)
    local player = ESX.GetPlayerFromId(source)
    if player then
		player.removeWeapon(weapon, ammo)
		if giveAmmo then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Stoğa içinde ' .. ammo .. ' adet mermi bulunan ' .. ESX.GetWeaponLabel(weapon) .. ' silahını koydun.'})
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Stoğa ' .. ESX.GetWeaponLabel(weapon) .. ' adlı silahı koydun.'})
        end
    end
end)

RegisterServerEvent("esx_policeArmory:addToDB")
AddEventHandler("esx_policeArmory:addToDB", function(weapon)
    local id = ESX.GetPlayerFromId(source).getIdentifier()
    MySQL.Async.fetchAll('SELECT weapons FROM policearmory WHERE steamID=\"'.. id .. '\"', {}, function(weapRow)
        local newLend
        for k,v in pairs(weapRow) do
            newLend = v.weapons
        end
        newLend = newLend .. weapon .. ", "
        MySQL.Async.execute("UPDATE policearmory SET weapons=\"".. newLend .. "\" WHERE steamID=\"" .. id .. "\"", {}, function ()
        end)
    end)
end)


RegisterServerEvent("esx_policeArmory:remFromDB")
AddEventHandler("esx_policeArmory:remFromDB", function(weapon)
    local id = ESX.GetPlayerFromId(source).getIdentifier()
    MySQL.Async.fetchAll('SELECT weapons FROM policearmory WHERE steamID=\"'.. id .. '\"', {}, function(weapRow)
        for k,v in pairs(weapRow) do
            newLend = string.gsub(v.weapons,weapon .. ", ", "")
        end
        MySQL.Async.execute("UPDATE policearmory SET weapons=\"".. newLend .. "\" WHERE steamID=\"" .. id .. "\"", {}, function ()
        end)
    end)
end)

ESX.RegisterServerCallback("esx_policeArmory:checkStorage", function(source, cb)
    local id = ESX.GetPlayerFromId(source).getIdentifier()
    MySQL.Async.fetchAll('SELECT weapons FROM policearmory WHERE steamID = \"' .. id .. '\"', {}, function(rowsChanged)
        if next(rowsChanged) == nil then
            MySQL.Async.execute("INSERT INTO policearmory (steamID,weapons) VALUES(\"" ..id .. "\",\"\")", {}, function () end)
            cb(nil)
        end
        cb(rowsChanged)
    end)
end)

ESX.RegisterServerCallback("esx_policeArmory:SupervisorCheck", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM policearmory', {}, function(rowsChanged)
        local people = {}
        for k,v in pairs(rowsChanged) do
            local xPlayer = ESX.GetPlayerFromIdentifier(v.steamID)
            if xPlayer ~= nil then
                table.insert(people,{id = v.steamID,name = GetPlayerName(source),job = xPlayer.getJob()})
            end
        end
        cb(people)
    end)
end)

RegisterServerEvent("esx_policeArmory:SupervisorRestock")
AddEventHandler("esx_policeArmory:SupervisorRestock", function(id)
    MySQL.Async.execute("UPDATE policearmory SET weapons= \"\" WHERE steamID=\"" .. id .. "\"", {}, function () end)
	local player = ESX.GetPlayerFromId(source)
	local target = ESX.GetPlayerFromIdentifier(id)
	local dato = os.date("kl. %H:%M (%d.%m.%y)")
	local msg = "**" ..GetPlayerName(source).. "** [" ..player.getIdentifier().. "] **|** has **restocked** weapons for **" ..target.getName().. "** **|** " ..dato
end)