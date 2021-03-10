ESX  = nil

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)  

local mineActive = false
local washingActive = false
local remeltingActive = false
local firstspawn = false
local amounts = 0
local impacts = 0
local minepressed = false
local washpressed = false

local locations = {
	{ ['x'] = 3004.3,  ['y'] = 2763.46,  ['z'] = 43.7},
    { ['x'] = 3005.6,  ['y'] = 2770.58,  ['z'] = 42.91},
    { ['x'] = 3001.81,  ['y'] = 2790.85,  ['z'] = 44.76},
    { ['x'] = 2987.66,  ['y'] = 2880.84,  ['z'] = 45.16},
	{ ['x'] = 2997.42,  ['y'] = 2750.77,  ['z'] = 44.32},
    { ['x'] = 2986.03,  ['y'] = 2751.63,  ['z'] = 43.22},
    { ['x'] = 3002.53,  ['y'] = 2759.12,  ['z'] = 43.11},
    { ['x'] = 3005.37,  ['y'] = 2781.34,  ['z'] = 44.06},
}

RegisterNetEvent("esx_miner:washing")
AddEventHandler("esx_miner:washing", function()
    Washing()
end)

RegisterNetEvent("esx_miner:remelting")
AddEventHandler("esx_miner:remelting", function()
    Remelting()
end)


Citizen.CreateThread(function()
	local delay = 100
    while true do
	    local ped = PlayerPedId()
        Citizen.Wait(delay)
        for i=1, #locations, 1 do
            if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 25 and mineActive == false then
				delay = 0
                DrawMarker(20, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 100.0, 0.5, 0.5, 0.5, 255, 255, 105, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 1 then
                    ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to start mining.")
					if IsControlJustReleased(1, 51) and not minepressed then
						minepressed = true
						TriggerServerEvent('ndrp_mining:startmining')
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local delay = 100
	local pressed = false
    while true do
		Citizen.Wait(delay)
		local ped = PlayerPedId()
        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 25 and washingActive == false then
			delay = 0
			if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 5 then
				ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to wash the stones.")
				if IsControlJustReleased(1, 51) and not pressed then
					pressed = true
					TriggerServerEvent("esx_miner:washing")
					Citizen.Wait(2000)
					pressed = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	local delay = 100
    while true do
		local ped = PlayerPedId()
        Citizen.Wait(delay)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 25 and remeltingActive == false then
			delay = 0
            DrawMarker(20, Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 1 then
				ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to remelting stones.")
				if IsControlJustReleased(1, 51) and not washpressed then
					washpressed = true
					TriggerServerEvent("esx_miner:remelting")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		local ped = PlayerPedId()
        Citizen.Wait(0)
		if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.SellX, Config.SellY, Config.SellZ, true) < 2 then
			ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to sell items.")
			if IsControlJustReleased(1, 51) and not pressed then
				pressed = true
				Jeweler()   
				Citizen.Wait(2000)
				pressed = false
            end
        end
    end
 end)

function Jeweler()
    local elements = {
	   {label = 'Diamonds',   value = 'diamonds'},
	   {label = 'Goldbar',       value = 'goldbar'},
        {label = 'Gold',      value = 'gold'},
        {label = 'Iron',       value = 'iron'},
        {label = 'Copper',       value = 'copper'},
    }

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jeweler_actions', {
        title    = 'Sell Items',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'diamonds' then
            menu.close()
			TriggerServerEvent("esx_miner:selldiamond")
		elseif data.current.value == 'goldbar' then
			menu.close()
			TriggerServerEvent("esx_miner:sellgoldbar")
        elseif data.current.value == 'gold' then
            menu.close()
            TriggerServerEvent("esx_miner:sellgold")
        elseif data.current.value == 'iron' then
            menu.close()
            TriggerServerEvent("esx_miner:selliron")
        elseif data.current.value == 'copper' then
            menu.close()
            TriggerServerEvent("esx_miner:sellcopper")
        end
    end)
end

function Animation()
	Citizen.CreateThread(function()
		while impacts < 5 do
			Citizen.Wait(1)
			local ped = PlayerPedId()	
			RequestAnimDict("melee@large_wpn@streamed_core")
			Citizen.Wait(100)
			TaskPlayAnim((ped), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
			SetEntityHeading(ped, 270.0)
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'pickaxe', 0.5)
			if impacts == 0 then
				pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
				AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
			end  
			Citizen.Wait(2500)
			ClearPedTasks(ped)
			impacts = impacts+1
			if impacts == 5 then
				DetachEntity(pickaxe, 1, true)
				DeleteEntity(pickaxe)
				DeleteObject(pickaxe)
				mineActive = false
				impacts = 0
				TriggerServerEvent("esx_miner:givestone")
				break
			end        
        end
    end)
end

function Washing()
    local ped = PlayerPedId()
    washingActive = true
    Citizen.Wait(100)
	exports['mythic_progbar']:Progress({
			name = "Washing",
			duration = 15900,
			label = 'Washing stones',
			useWhileDead = false,
			canCancel = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@prop_human_bum_bin@idle_a",
				anim = "idle_a",
				flags = 49,
			},
			prop = {
				model = "proc_sml_stones02",
				bone = 18905,
				coords = { x = 0.10, y = 0.02, z = 0.08 },
				rotation = { x = -80.0, y = 0.0, z = 0.0 },
			},
			propTwo = {
				model = "proc_sml_stones02",
				bone = 58866,
				coords = { x = 0.12, y = 0.0, z = 0.001 },
				rotation = { x = -150.0, y = 0.0, z = 0.0 },
			},
	})
	Citizen.Wait(15900)
	washingActive = false
end

function Remelting()
    local ped = PlayerPedId()
    remeltingActive = true
    Citizen.Wait(100)
	exports['mythic_progbar']:Progress({	
			name = "Remelting",
			duration = 15900,
			label = 'Remelting stones',
			useWhileDead = false,
			canCancel = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@prop_human_bum_bin@idle_a",
				anim = "idle_a",
				flags = 49,
			},
			prop = {
				model = "proc_sml_stones02",
				bone = 18905,
				coords = { x = 0.10, y = 0.02, z = 0.08 },
				rotation = { x = -80.0, y = 0.0, z = 0.0 },
			},
			propTwo = {
				model = "proc_sml_stones02",
				bone = 58866,
				coords = { x = 0.12, y = 0.0, z = 0.001 },
				rotation = { x = -150.0, y = 0.0, z = 0.0 },
			},
	})
	Citizen.Wait(15900)
    remeltingActive = false
	washpressed = false
end

RegisterNetEvent('ndrp_mining:startmining')
AddEventHandler('ndrp_mining:startmining', function(reason)
	if reason == 1 then
		Animation()
		mineActive = true
		minepressed = false
	elseif reason == 2 then
		exports['mythic_notify']:SendAlert('error', 'You have reached the limit. Come back later!')
		Citizen.Wait(5000)
		minepressed = false
	elseif reason == 3 then
		exports['mythic_notify']:SendAlert('error', 'You need a pickaxe for mining')
		Citizen.Wait(5000)
		minepressed = false
	else
		exports['mythic_notify']:SendAlert('error', 'You don\'t have enough space in your backpack!')
		Citizen.Wait(5000)
		minepressed = false
	end
end)