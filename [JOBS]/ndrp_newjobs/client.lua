local PlayerData              = {}
ESX                           = nil

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- Bean machine

local isMenuOpen = false

Citizen.CreateThread(function()
	
	local x = -631.77
	local y = 228.06
	local z = 80.90
	
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 10 then
			if PlayerData.job ~= nil and PlayerData.job.name == "beanmachine" then
			
				DrawMarker(23, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 31, 22, 100, false, true, 2, false, nil, nil, false)
				if distance < 1 then
					showmenu = true
					DrawText3Ds(x,y,z+1.0, 'Press [~g~E~s~] to buy essentials')
					if IsControlJustReleased(0,  46) then
						shop()
					end
				else
					if isMenuOpen then
						ESX.UI.Menu.CloseAll()
						isMenuOpen = false
					end
				end
				
			end
		end
	end
end)


-- Coffee machine

local gotitems = false
local makingcoffee = false

Citizen.CreateThread(function()
	
	local x = -627.72
	local y = 223.55
	local z = 80.90
	
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 5 then
			if PlayerData.job ~= nil and PlayerData.job.name == "beanmachine" then
				DrawMarker(23, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 31, 22, 100, false, true, 2, false, nil, nil, false)
				if distance < 1 then
					DrawText3Ds(x,y,z+1.0, 'Press [~g~E~s~] to make coffee')
					if not pressed and IsControlJustReleased(0, 46) then
						pressed = true
						SetEntityHeading(playePed, 171.93)
						SetEntityCoords(playerPed, x, y, z)
						makingcoffee = true
						TriggerServerEvent("ndrp_base:checkItems","newjobs",4,{"milk","water","coffeepowder","suger"},{2,1,1,1})
						Wait(1000)
						if gotitems then
							
							exports['mythic_progbar']:Progress({
								name = "Making the coffee",
								duration = 10000,
								label = "Making the Coffee",
								useWhileDead = false,
								canCancel = false,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "mp_prison_break",
									anim = "hack_loop",
									flags = 49,
								}	
							})
							Citizen.Wait(10000)
							pressed = false
							TriggerServerEvent("ndrp_newjobs:makecoffee")	
							exports['mythic_notify']:SendAlert('success', '3 cup of coffee added to your inventory')
						else
							exports['mythic_notify']:SendAlert('error', 'You need 2 Glass Milk, 1 Bottle Water, 50g Suger and Coffeepowder')
							Citizen.Wait(2500)
							pressed = false
						end
					end
				end
			end
		end
	end
end)


RegisterNetEvent('ndrp_newjobs:checkItems')
AddEventHandler('ndrp_newjobs:checkItems', function(itemcheck)
  gotitems = itemcheck
  gotvegitems = itemcheck
  gotcbitems = itemcheck
  gotmbitems = itemcheck
end)


-- Functions

function shop()
	isMenuOpen = true
	
		
		local elements = {
			{label = 'Chocolate ($10)',   value = 'chocolate'},
			{label = 'Coca Cola ($15)',      value = 'cocacola'},
			{label = 'Milk ($5)',       value = 'milk'},
			{label = 'Coffee Powder ($15) ',       value = 'coffeepowder'},
			{label = 'Suger 50G ($5) ',       value = 'suger'},
			{label = 'Water ($5) ',       value = 'water'},
		}

		ESX.UI.Menu.CloseAll()
    
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jeweler_actions', {
			title    = 'Bean Machine Shop',
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'chocolate' then
				menu.close()
				TriggerServerEvent("ndrp_base:buyItem","chocolate",10,1)
			elseif data.current.value == 'cocacola' then
				menu.close()
				TriggerServerEvent("ndrp_base:buyItem","cocacola",15,1)
			elseif data.current.value == 'milk' then
				menu.close()
				TriggerServerEvent("ndrp_base:buyItem","milk",5,1)
			elseif data.current.value == 'coffeepowder' then
				menu.close()
				TriggerServerEvent("ndrp_base:buyItem","coffeepowder",15,1)
			elseif data.current.value == 'suger' then
				menu.close()
				TriggerServerEvent("ndrp_base:buyItem","suger",5,1)	
			elseif data.current.value == 'water' then
				menu.close()
				TriggerServerEvent("ndrp_base:buyItem","water",5,1)	
			end
		end, function(data,menu)
			menu.close()
		end)
end

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.80, 0.40)
    SetTextFont(6)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 900
 --   DrawRect(_x,_y+(0.0125*1.7), 0.015+ factor, 0.045, 0, 0, 0, 80)
end


local object_model = "prop_watercooler"
local atm_model = "prop_atm_02"

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	RequestModel(object_model)
	RequestModel(atm_model)
	
	local iter_for_request = 1
	local atm_for_request = 1

	while not HasModelLoaded(object_model) and iter_for_request < 5 do
		Citizen.Wait(500)				
		iter_for_request = iter_for_request + 1
	end

	if not HasModelLoaded(object_model) then
		SetModelAsNoLongerNeeded(object_model)
	else
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local created_object = CreateObjectNoOffset(object_model, -627.6, 228.47, 80.87, 1, 0, 1)
		local created_object2 = CreateObjectNoOffset(object_model, -598.12, -913.47, 22.88, 1, 0, 1)
		PlaceObjectOnGroundProperly(created_object)
		FreezeEntityPosition(created_object,true)
		PlaceObjectOnGroundProperly(created_object2)
		FreezeEntityPosition(created_object2,true)
		SetModelAsNoLongerNeeded(object_model)
	end

	while not HasModelLoaded(atm_model) and atm_for_request < 5 do
		Citizen.Wait(500)				
		atm_for_request = atm_for_request + 1
	end
	
	if not HasModelLoaded(atm_model) then
		SetModelAsNoLongerNeeded(atm_model)
	else
		local created_atm = CreateObjectNoOffset(atm_model, -37.57, -1115.57, 25.80, 1, 0, 1)
		FreezeEntityPosition(created_atm,true)
		SetEntityHeading(created_atm, 247.9)
		SetModelAsNoLongerNeeded(atm_model)
	end
end)

-- Vanilla unicorn

local isMenuOpen = false

Citizen.CreateThread(function()
	
	local x = 128.39
	local y = -1285.43
	local z = 28.29
	
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 10 then
			DrawMarker(23, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 31, 22, 100, false, true, 2, false, nil, nil, false)
			if distance < 1 then
				showmenu = true
				DrawText3Ds(x,y,z+1.5, 'Press [~g~E~s~] to buy')
				if IsControlJustReleased(0,  46) then
					vanilashop()
				end
			else
				if isMenuOpen then
					ESX.UI.Menu.CloseAll()
					isMenuOpen = false
				end
			end
		end
	end
end)

function vanilashop()
	isMenuOpen = true
	local elements = {
		{label = 'Beer ($100)',   value = 'beer'},
		{label = 'Vodka ($150)',      value = 'vodka'},
		{label = 'Tequila ($200)',       value = 'tequila'},
		{label = 'Wine ($250) ',       value = 'wine'},
		{label = 'Whisky ($200) ',       value = 'whisky'},
		{label = 'Water ($15) ',       value = 'water'},
	}

	ESX.UI.Menu.CloseAll()
    
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vanila_actions', {
		title    = 'Cocktails',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'beer' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","beer",100,1)
		elseif data.current.value == 'vodka' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","vodka",150,1)
		elseif data.current.value == 'whisky' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","whisky",200,1)
		elseif data.current.value == 'tequila' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","tequila",250,1)
		elseif data.current.value == 'wine' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","wine",250,1)	
		elseif data.current.value == 'water' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","water",15,1)	
		end
	end, function(data,menu)
		menu.close()
	end)
end

-- TaQI lA LA

local isMenuOpen = false

Citizen.CreateThread(function()
	
	local x = -560.26
	local y = 286.64
	local z = 81.19
	
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 10 then
			DrawMarker(23, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 31, 22, 100, false, true, 2, false, nil, nil, false)
			if distance < 1 then
				showmenu = true
				DrawText3Ds(x,y,z+1.5, 'Press [~g~E~s~] to buy')
				if IsControlJustReleased(0,  46) then
					vanilashop()
				end
			else
				if isMenuOpen then
					ESX.UI.Menu.CloseAll()
					isMenuOpen = false
				end
			end
		end
	end
end)

-- Mimi's Burger

local isMenuOpen = false

Citizen.CreateThread(function()
	
	local x = 89.24
	local y = -233.17
	local z = 53.7
	
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 10 then
			DrawMarker(23, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 31, 22, 100, false, true, 2, false, nil, nil, false)
			if distance < 1.5 then
				showmenu = true
				DrawText3Ds(x,y,z+1.5, 'Press [~g~E~s~] to buy essentials')
				if IsControlJustReleased(0,  46) then
					mimishop()
				end
			else
				if isMenuOpen then
					ESX.UI.Menu.CloseAll()
					isMenuOpen = false
				end
			end
		end
	end
end)


function mimishop()
	isMenuOpen = true
	local elements = {

		{label = 'BUN ($5)',   		value = 'bun'},
		{label = 'Cheese ($5)',     value = 'cheese'},
		{label = 'Veggies ($5)',  value = 'veggies'},
		{label = 'Sauces ($5)',       	value = 'sauce'},
		{label = 'Veg Patty ($10)',   		value = 'vegpatty'},
		{label = 'Chicken Patty ($15)',     value = 'chickenpatty'},
		{label = 'Fish Patty ($15)',  value = 'fishpatty'},
	
	}

	ESX.UI.Menu.CloseAll()
    
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vanila_actions', {
		title    = 'MiMi\'s Burger shop',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'bun' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","bun",5,1)
		elseif data.current.value == 'cheese' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","cheese",5,1)
		elseif data.current.value == 'veggies' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","veggies",5,1)
		elseif data.current.value == 'sauce' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","sauce",5,1)
		elseif data.current.value == 'vegpatty' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","vegpatty",10,1)
		
		elseif data.current.value == 'chickenpatty' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","chickenpatty",15,1)

		elseif data.current.value == 'fishpatty' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","fishpatty",15,1)
		end
	end, function(data,menu)
		menu.close()
	end)
end


-- BRB Mimi's Burger

local gotitems = false
local makingcoffee = false

Citizen.CreateThread(function()
	
	local x = 84.28
	local y = -233.15
	local z = 53.7
	
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 5 then
			if PlayerData.job ~= nil and PlayerData.job.name == "burgershot" then
				DrawMarker(23, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 31, 22, 100, false, true, 2, false, nil, nil, false)
				if distance < 1.5 then
					DrawText3Ds(84.0,-233.62,z+1.2, '[~g~E~s~] Veg burger \n [~g~H~s~] Chicken Burger \n [~g~G~s~] MiMi\'s Special Burger')
					
					-- veg BURGER

					if not pressed and IsControlJustReleased(0, 46) then
						pressed = true
						SetEntityHeading(playePed, 171.93)
						SetEntityCoords(playerPed, x, y, z)
						makingcoffee = true
						TriggerServerEvent("ndrp_base:checkItems","newjobs",5,{"bun","veggies","cheese","sauce","vegpatty"},{4,1,1,1,4})
						Wait(1000)
						if gotvegitems then
							TriggerEvent("ndrp_emotes:playthisemote", 'bbq')
							exports['mythic_progbar']:Progress({
								name = "Making Veg Burger",
								duration = 60000,
								label = "Making Veg Burgers",
								useWhileDead = false,
								canCancel = false,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "",
									anim = "",
									flags = 49,
								}	
							})

							Citizen.Wait(60000)
							TriggerEvent("ndrp_emotes:playthisemote", 'c')
							pressed = false
							TriggerServerEvent("ndrp_newjobs:makeburger",'veg')	
							exports['mythic_notify']:SendAlert('success', 'You made 4 Veg Burgers')
						else
							exports['mythic_notify']:SendAlert('error', 'You need 4 Bun, 4 Veg Patties, 1 veggies, Cheese and Sauce')
							Citizen.Wait(2500)
							pressed = false
						end
					end

					-- Chicken BURGER

					if not pressed and IsControlJustReleased(0, 74) then
						pressed = true
						SetEntityHeading(playePed, 171.93)
						SetEntityCoords(playerPed, x, y, z)
						makingcoffee = true
						TriggerServerEvent("ndrp_base:checkItems","newjobs",5,{"bun","veggies","cheese","sauce","chickenpatty"},{4,1,1,1,4})
						Wait(1000)
						if gotcbitems then
							TriggerEvent("ndrp_emotes:playthisemote", 'bbq')
							exports['mythic_progbar']:Progress({
								name = "Making Chicken burgers",
								duration = 60000,
								label = "Making Chicken burgers",
								useWhileDead = false,
								canCancel = false,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "",
									anim = "",
									flags = 49,
								}	
							})

							Citizen.Wait(60000)
							TriggerEvent("ndrp_emotes:playthisemote", 'c')
							pressed = false
							TriggerServerEvent("ndrp_newjobs:makeburger",'chicken')	
							exports['mythic_notify']:SendAlert('success', 'You made 4 Chicken Burgers')
						else
							exports['mythic_notify']:SendAlert('error', 'You need 4 bun, 4 Chicken Patties, 1 Veggies, Cheese and Sauce')
							Citizen.Wait(2500)
							pressed = false
						end
					end

					-- MiMi BURGER

					if not pressed and IsControlJustReleased(0, 58) then
						pressed = true
						SetEntityHeading(playePed, 171.93)
						SetEntityCoords(playerPed, x, y, z)
						makingcoffee = true
						TriggerServerEvent("ndrp_base:checkItems","newjobs",6,{"bun","veggies","cheese","sauce","chickenpatty","fishpatty"},{4,1,1,1,4,4})
						Wait(1000)
						if gotmbitems then
							TriggerEvent("ndrp_emotes:playthisemote", 'bbq')
							exports['mythic_progbar']:Progress({
								name = "Making MiMi\'s Special burgers",
								duration = 60000,
								label = "Making MiMi\'s Special burgers",
								useWhileDead = false,
								canCancel = false,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "",
									anim = "",
									flags = 49,
								}	
							})

							Citizen.Wait(60000)
							TriggerEvent("ndrp_emotes:playthisemote", 'c')
							pressed = false
							TriggerServerEvent("ndrp_newjobs:makeburger",'mimi')	
							exports['mythic_notify']:SendAlert('success', 'You made 4 MiMi\'s Special Burgers')
						else
							exports['mythic_notify']:SendAlert('error', 'You need 4 Fish and Chicken Patties, 4 Bun, 1 Veggies,Sauce and Cheese')
							Citizen.Wait(2500)
							pressed = false
						end
					end
				end
			end
		end
	end
end)


---- C4 Crafting 

local isMenuOpen = false
Citizen.CreateThread(function()
	local x = 531.97
	local y = -3059.42
	local z = 6.07
	while true do
		Citizen.Wait(5)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 10 then
			if distance < 1.5 then
				showmenu = true
				DrawText3Ds(x,y,z+0.50, 'Press [~g~E~s~] to Open Crafting menu')
				if IsControlJustReleased(0,  46) then
					ESX.TriggerServerCallback('ndrp_drugs:hasItem', function(hasItem)
						if hasItem then 
							crafting()
						else
							exports['mythic_notify']:SendAlert('inform', 'Show us the card who you belongs to', 3500, { ['background-color'] = '#000', ['color'] = '#fff' })
						end
					end, 'card_pestilence')
				end
			else
				if isMenuOpen then
					ESX.UI.Menu.CloseAll()
					isMenuOpen = false
				end
			end
		end
	end
end)

function crafting()
	isMenuOpen = true
	local elements = {
		{label = 'C4 Explosive',  value = 'c4_bank'},
	}
	ESX.UI.Menu.CloseAll()
    
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cm_actions', {
		title    = 'Crafting menu',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'c4_bank' then
			menu.close()
			TriggerServerEvent("ndrp_base:craftItem","c4_bank",1)
		end
	end, function(data,menu)
		menu.close()
	end)
end


---- Black market --  

local isMenuOpen = false
Citizen.CreateThread(function()
	local x = 172.9
	local y = -1000.09
	local z = -100.0
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 10 then
			DrawMarker(23, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
			if distance < 1.5 then
				showmenu = true
				DrawText3Ds(x,y,z+1.45, 'Press [~g~E~s~] to access Syndicate\'s Black Market')
				if IsControlJustReleased(0,  46) then
					blackmarket()
				end
			else
				if isMenuOpen then
					ESX.UI.Menu.CloseAll()
					isMenuOpen = false
				end
			end
		end
	end
end)

function blackmarket()
	isMenuOpen = true
	local elements = {
		{label = 'Police Cuffs ($1000)',   		value = 'cuffs'},
	}

	ESX.UI.Menu.CloseAll()
    
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bm_actions', {
		title    = 'Black market',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cuffs' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","cuffs",1000,1)
		end
	end, function(data,menu)
		menu.close()
	end)
end

---- POLICE ARMORY --  

local isMenuOpen = false
Citizen.CreateThread(function()
	local x = 460.17
	local y = -979.39
	local z = -29.70
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
		if distance < 10 then
			if PlayerData.job ~= nil and PlayerData.job.name == "police" then
				DrawMarker(23, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
				if distance < 1.5 then
					showmenu = true
					DrawText3Ds(x,y,z+1.45, 'Press [~g~E~s~] to access Police Armory')
					if IsControlJustReleased(0,  46) then
						policearmory()
					end
				else
					if isMenuOpen then
						ESX.UI.Menu.CloseAll()
						isMenuOpen = false
					end
				end
			end
		end
	end
end)

function policearmory()
	isMenuOpen = true
	local elements = {
		{label = 'Nightstick',   		value = 'WEAPON_NIGHTSTICK'},
		{label = 'Flashlight',   		value = 'WEAPON_FLASHLIGHT'},
		{label = 'Taser',   			value = 'WEAPON_STUNGUN'},
		{label = 'MK2 Pistol',   		value = 'WEAPON_PISTOL_MK2'},
		{label = 'Combat Pistol',   	value = 'WEAPON_COMBATPISTOL'},
		{label = 'SMG',   				value = 'WEAPON_SMG'},
		{label = 'Advanced Rifle',   	value = 'WEAPON_ADVANCEDRIFLE'},
		{label = 'Pump Shotgun',   		value = 'WEAPON_PUMPSHOTGUN'},
		{label = 'Heavy Armour',   		value = 'bulletproof'},
	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pa_actions', {
		title    = 'Police Armory',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'WEAPON_NIGHTSTICK' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","WEAPON_NIGHTSTICK",0,1)
		elseif data.current.value == 'WEAPON_FLASHLIGHT' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","WEAPON_FLASHLIGHT",0,1)
		elseif data.current.value == 'WEAPON_STUNGUN' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","WEAPON_STUNGUN",0,1)
		elseif data.current.value == 'WEAPON_PISTOL_MK2' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","WEAPON_PISTOL_MK2",0,1)
		elseif data.current.value == 'WEAPON_SMG' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","WEAPON_SMG",0,1)
		elseif data.current.value == 'WEAPON_ADVANCEDRIFLE' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","WEAPON_ADVANCEDRIFLE",0,1)
		elseif data.current.value == 'WEAPON_COMBATPISTOL' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","WEAPON_COMBATPISTOL",0,1)
		elseif data.current.value == 'WEAPON_PUMPSHOTGUN' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","WEAPON_PUMPSHOTGUN",0,1)
		elseif data.current.value == 'bulletproof' then
			menu.close()
			TriggerServerEvent("ndrp_base:buyItem","bulletproof",1000,1)
		end
	end, function(data,menu)
		menu.close()
	end)
end