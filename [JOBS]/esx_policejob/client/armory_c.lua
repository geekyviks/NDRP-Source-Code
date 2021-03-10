ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local weaponStorage = {}

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end


Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		if ESX.PlayerData.job and (ESX.PlayerData.job.name == 'police') then
			for k,v in pairs(Config.PoliceArmory) do
				local ped = GetPlayerPed(-1)
				local pos = GetEntityCoords(ped)
				local distance = GetDistanceBetweenCoords(pos.x,pos.y,pos.z,v.x,v.y,v.z,false)
				if distance <= 8.0 then
					DrawMarker(Config.ArmoryMarker, v.x,v.y,v.z+0.90, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.8, 0.8, 0.5, Config.ArmoryMarkerColor.r,Config.ArmoryMarkerColor.g,Config.ArmoryMarkerColor.b,Config.ArmoryMarkerColor.a, false, true, 2, false, false, false, false)						
					if distance <= 0.6 then
						DrawText3Ds(v.x,v.y,pos.z, "~y~Police Armory~s~ Press ~g~[E]~s~ to access")
						if IsControlJustPressed(0, 38) then
							ESX.TriggerServerCallback("esx_policeArmory:checkStorage", function(stock) end)
							PoliceArmory()
						end
					end
				end
			end
		end
		Citizen.Wait(5)
	end
end)

PoliceArmory = function()
	local elements = {
		{ label = "Weapons", action = "weapon_menu" },
		{ label = "Armour", action = "kevlar_menu" },
		{ label = "Attachments", action = "attachments_menu" },
	}
	
	if ESX.PlayerData.job.grade_name == 'chief' or ESX.PlayerData.job.grade_name == 'captain' or ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'sergeant' then
		table.insert(elements, {label = "Restock Menu", action = "restock_menu"})
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_main_menu",
		{
			title    = "Police Armory",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		local action = data.current.action

		if action == "weapon_menu" then
			WeaponMenu()
		elseif action == "restock_menu" then
			RestockMenu()
		elseif action == "kevlar_menu" then
			KevlarMenu()
		elseif action == "attachments_menu" then
			AttachmentMenu()
		end	
	end, function(data, menu)
		menu.close()
	end, function(data, menu)
	end)
end

WeaponMenu = function()
	local storage = nil
	local elements = {}
	local ped = GetPlayerPed(-1)
	ESX.TriggerServerCallback("esx_policeArmory:checkStorage", function(stock)	
	local weapons = WeapSplit(stock[1].weapons, ", ")
	
	for k,v in pairs(Config.WeaponsInArmory) do
		local yes = false
		for z,x in pairs(weapons) do
			if x == v.weaponHash then
				yes = false
				table.insert(elements,{label = v.name .. " | removed ", weaponhash = v.weaponHash, lendable = false})
			end
		end
		if yes == false then
			table.insert(elements,{label = v.name .. " | In stock", weaponhash = v.weaponHash, lendable = true})
		end
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_weapon_storage",
		{
			title    = "Weapon Ammo",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		menu.close()
		
		if data.current.lendable == true then
			print(data.current.weaponhash)
			local giveAmmo = (GetWeaponClipSize(GetHashKey(data.current.weaponhash)) > 0)
			if data.current.weaponhash == "WEAPON_STUNGUN" then
				giveAmmo = false
			end
			TriggerServerEvent("esx_policeArmory:takeWeapon", data.current.weaponhash, giveAmmo)
			TriggerServerEvent("esx_policeArmory:addToDB", data.current.weaponhash)
		elseif PedHasWeapon(data.current.weaponhash) then
			local giveAmmo = (GetWeaponClipSize(GetHashKey(data.current.weaponhash)) > 0)
			if data.current.weaponhash == "WEAPON_STUNGUN" then
				giveAmmo = false
			end
			TriggerServerEvent("esx_policeArmory:getWeapon", data.current.weaponhash,GetAmmoInPedWeapon(ped,GetHashKey(data.current.weaponhash)),giveAmmo)
			TriggerServerEvent("esx_policeArmory:remFromDB", data.current.weaponhash)
		else
			exports['mythic_notify']:SendAlert('inform', 'You\'ve already pulled out this weapon. Ask High commands')
		end
		
	end, function(data, menu)
		menu.close()
	end, function(data, menu)
	end)
	end)
end

function RestockMenu()
	local people = {}
	local elements = {}
	ESX.TriggerServerCallback("esx_policeArmory:SupervisorCheck", function(list) people = list end)
	Citizen.Wait(250)
	for k,v in pairs(people) do
		if v.job.name == "police" then
			table.insert(elements, {label = v.name, id = v.id})
		end
	end
	if next(elements) ~= nil then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_restock_menu",
			{
				title    = "Stock Yenile",
				align    = "center",
				elements = elements
			},
		function(data, menu)
			menu.close()
		TriggerServerEvent("esx_policeArmory:SupervisorRestock",data.current.id)
		end, function(data, menu)
			
			menu.close()
		end, function(data, menu)
		end)
	else
		exports['mythic_notify']:SendAlert('inform', 'There is no online police.')
	end
end

function KevlarMenu()
	local ped = GetPlayerPed(-1)
	local elements = {}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_kevlar_menu",
			{
				title    = "Chest Armour",
				align    = "center",
				elements = {
					{label = "Super low Armour", armor = 25},
					{label = "Low Armour", armor = 50},
					{label = "Normal Armour", armor = 75},
					{label = "Heavy Armour", armor = 100},
					{label = "No Armour", armor = 0},
			}
			},
		function(data, menu)
			SetPedArmour(ped,data.current.armor)
			menu.close()
		end, function(data, menu)
			menu.close()
		end, function(data, menu)
		end)
end

function WeapSplit(inputstr, del)
    if del == nil then
            del = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..del.."]+)") do
            table.insert(t, str)
    end
    return t
end

function PedHasWeapon(hash)
	for k,v in pairs(ESX.GetPlayerData().loadout) do
		if v.name == hash then
			return true
		end
	end
	return false
end

function AttachmentMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_attachment_menu",
		{
			title    = "Attachments",
			align    = "center",
			elements = {
				{label = "Attachments", attachment}
			}
		},
	function(data, menu)
		local ped = GetPlayerPed(-1)
		local WepHash = GetSelectedPedWeapon(ped)
		local attachment = data.current.attachment
		
		if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") then
			GiveWeaponComponentToPed(ped,GetSelectedPedWeapon(ped),0x43FD595B) -- flash light pistol mk2
			exports['mythic_notify']:SendAlert('success', 'Flashlight Attached')
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
			GiveWeaponComponentToPed(ped,GetSelectedPedWeapon(ped),GetHashKey('COMPONENT_AT_AR_FLSH')) -- flash light rifle mk2
			exports['mythic_notify']:SendAlert('success', 'Flashlight Attached to Advanced Rifle')
			
			GiveWeaponComponentToPed(ped,GetSelectedPedWeapon(ped),GetHashKey('COMPONENT_AT_SCOPE_SMALL')) -- scope rifle mk2
			exports['mythic_notify']:SendAlert('success', 'Scope Attached to Advanced Rifle')
			
			GiveWeaponComponentToPed(ped,GetSelectedPedWeapon(ped),GetHashKey('COMPONENT_AT_AR_SUPP')) -- scope rifle mk2
			exports['mythic_notify']:SendAlert('success', 'Suppressor Attached to Advanced Rifle')

			GiveWeaponComponentToPed(ped,GetSelectedPedWeapon(ped),GetHashKey('COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE')) -- scope rifle mk2
			exports['mythic_notify']:SendAlert('success', 'Luxury finish to Advanced Rifle')

		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG") then
			GiveWeaponComponentToPed(ped,GetSelectedPedWeapon(ped),0x7BC4CDDC) -- flashlight SMG
			exports['mythic_notify']:SendAlert('success', 'Flashlight Attached to the SMG')
			GiveWeaponComponentToPed(ped,GetSelectedPedWeapon(ped),0x3CC6BA57) -- scope SMG
			exports['mythic_notify']:SendAlert('success', 'Scope Attached to the SMG')
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PUMPSHOTGUN") then
			GiveWeaponComponentToPed(ped,GetSelectedPedWeapon(ped),0x7BC4CDDC) -- flash light SHOTGUN
			exports['mythic_notify']:SendAlert('success', 'Flashlight Attached to the shotgun')
		else
			exports['mythic_notify']:SendAlert('inform', 'Pull out your weapon to attach extras')
		end
		
	end, function(data, menu)

		menu.close()
	end, function(data, menu)
	end)
end