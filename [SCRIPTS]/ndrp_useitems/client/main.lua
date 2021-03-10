local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData = {}
--local CurrentActionData = {}
--local lastTime = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer 
end)

local meth = false
local oxy = false
local wine = false
local beer = false
local vodka = false
local whisky = false
local tequila = false
local chocolate = false
local teacup = false
local coffee = false
local icetea = false
local cocacola = false
local salvage = false
local cocaine = false
local weed = false
local marijuana = false
local cannabis = false
local oxyzen = false
local cig = false
local vegburger = false
local chickenburger = false
local mimiburger = false
local maskOn = false
local object
local object2

-- Start of Oxygen Mask

RegisterNetEvent('esx_extraitems:oxygen_mask')
AddEventHandler('esx_extraitems:oxygen_mask', function()
	if not oxyzen then
		oxyzen = true
		local playerPed  = GetPlayerPed(-1)
		local coords     = GetEntityCoords(playerPed)
		local boneIndex  = GetPedBoneIndex(playerPed, 12844)
		local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
		object = CreateObject(136880302, coords.x, coords.y, coords.z - 3,true,true,false)
		object2 = CreateObject(1593773001, coords.x, coords.y, coords.z - 3,true,true,false)
		AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
		AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
		SetEnableScuba(GetPlayerPed(-1),true)
		SetPedMaxTimeUnderwater(GetPlayerPed(-1), 900.00)
		exports['mythic_notify']:SendAlert('inform', 'You Put Oxygen Tank On. Capacity: 15 Minute')
		Citizen.Wait(15*60*1000)
		oxyzen = false
	else
		exports['mythic_notify']:SendAlert('inform', 'You can\'t use multiple oxygen tanks')
	end
end)

RegisterCommand('removeoxy', function(source, args)
	if object ~= nil and object2 ~= nil then
		DeleteObject(object)
		DeleteObject(object2)
		SetPedMaxTimeUnderwater(GetPlayerPed(-1), 25.00)
		exports['mythic_notify']:SendAlert('inform', 'You\'ve Removed Oxygen Tank')
		oxyzen = false
  	end
end, false)

-- End of Oxygen Mask

-- Start of Bullet Proof Vest

RegisterNetEvent('esx_extraitems:bulletproof')
AddEventHandler('esx_extraitems:bulletproof', function()
	local playerPed = GetPlayerPed(-1)
	TriggerEvent('InteractSound_CL:PlayOnOne', 'clothe', 0.4)
	TriggerEvent('ndrp_emotes:playthisemote', 'adjust')
	exports['progressBars']:startUI(5000, "Putting on armour")
	AddArmourToPed(playerPed, 100)
	SetPedArmour(playerPed, 100)

end)

-- End of Bullet Proof Vest

-- Start of Cannabias

RegisterNetEvent('esx_extraitems:useCannabis')
AddEventHandler('esx_extraitems:useCannabis', function()
	local playerPed = GetPlayerPed(-1)
	
	if not cannabis then
		cannabis = true
		TriggerServerEvent('esx_extraitems:removethisitem','cannabis')
		exports['mythic_progbar']:Progress({
			name = "Rolling a Joint",
			duration = 5000,
			label = 'Rolling a Joint',
			useWhileDead = false,
			canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "missheistdockssetup1clipboard@idle_a",
			anim = "idle_b",
			flags = 49,
		}})
		Citizen.Wait(5000)
		exports['mythic_notify']:SendAlert('inform', 'You made a Joint')
		cannabis = false
	end
	
end)

-- End of Cannbias

-- start ciggrate 

RegisterNetEvent('esx_drugeffects:onCigar')
AddEventHandler('esx_drugeffects:onCigar', function()
	local playerPed = GetPlayerPed(-1)
	if not cig then
		cig = true
		TriggerServerEvent('esx_extraitems:removethisitem','cigarette')
		TriggerEvent('ndrp_emotes:playthisemote','smoke')
		Citizen.Wait(15000)
		TriggerEvent('esx_status:remove', 'stress', 20000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
		TriggerEvent('ndrp_emotes:playthisemote','c')
		cig = false
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_drugeffects:onCopCigar')
AddEventHandler('esx_drugeffects:onCopCigar', function()
	local playerPed = GetPlayerPed(-1)
	if not cig then
		cig = true
		TriggerServerEvent('esx_extraitems:removethisitem','cigarette')
		TriggerEvent('ndrp_emotes:playthisemote','smoke3')
		Citizen.Wait(15000)
		TriggerEvent('esx_status:remove', 'stress', 200000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
		TriggerEvent('ndrp_emotes:playthisemote','c')
		cig = false
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)



-- Start of Marijuana

RegisterNetEvent('esx_extraitems:useMarijuana')
AddEventHandler('esx_extraitems:useMarijuana', function()
	local playerPed = GetPlayerPed(-1)
	if not marijuana then
		marijuana = true
		TriggerServerEvent('esx_extraitems:removethisitem','marijuana')
		exports['mythic_progbar']:Progress({
			name = "Rolling Multiple Joints",
			duration = 10000,
			label = 'Rolling Multiple Joints',
			useWhileDead = false,
			canCancel = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "missheistdockssetup1clipboard@idle_a",
				anim = "idle_b",
				flags = 49,
			}})
		Citizen.Wait(10000)
		exports['mythic_notify']:SendAlert('inform', 'You made 3 Joints')
		marijuana = false
	end
end)

-- Start of Weapon Clip

RegisterNetEvent('esx_extraitems:clipcli')
AddEventHandler('esx_extraitems:clipcli', function()
	ped = GetPlayerPed(-1)
	if IsPedArmed(ped, 4) then
		hash = GetSelectedPedWeapon(ped)
		if hash ~= nil then
			AddAmmoToPed(GetPlayerPed(-1), hash,1000)
			ESX.ShowNotification(_U("clip_use"))
		else
			ESX.ShowNotification(_U("clip_no_weapon"))
		end
	else
		ESX.ShowNotification(_U("clip_not_suitable"))
	end
end)

-- End of Weapon Clip

-- Start of Drill

RegisterNetEvent('esx_extraitems:startDrill')
AddEventHandler('esx_extraitems:startDrill', function(source)
	local playerPed = GetPlayerPed(-1)
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_STAND_IMPATIEN", 0, true)
	Citizen.CreateThread(function()
		Citizen.Wait(10000)
		ClearPedTasksImmediately(playerPed)
	end)
end)

-- End of Drill

-- Start of Parachute 

RegisterNetEvent('esx_extraitems:startParachute')
AddEventHandler('esx_extraitems:startParachute', function(source)
	local playerPed = GetPlayerPed(-1)
	TriggerEvent('InteractSound_CL:PlayOnOne', 'clothe', 0.4)
	TriggerEvent('ndrp_emotes:playthisemote', 'adjust')
	exports['progressBars']:startUI(5000, "Putting on parachute")
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), true)
	exports['mythic_notify']:SendAlert('inform', 'You\'ve used a parachute')
end)

-- End of Parachute

-- Start of Lock Pick

RegisterNetEvent('esx_extraitems:lockpick')
AddEventHandler('esx_extraitems:lockpick', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end
		local chance = math.random(100)
		local alarm  = math.random(100)
		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
	end
end)

-- End of Lock Pick


-- Start of Bolt cutter

RegisterNetEvent("esx_extraitems:boltcutter")
AddEventHandler("esx_extraitems:boltcutter", function()
	local player, distance = ESX.Game.GetClosestPlayer()
	local playerheading = GetEntityHeading(GetPlayerPed(-1))
	local playerlocation = GetEntityForwardVector(PlayerPedId())
	local playerCoords = GetEntityCoords(GetPlayerPed(-1))
	local target_id = GetPlayerServerId(player)
    if distance~=-1 and distance<=3.0 then
        ESX.TriggerServerCallback("esx_policejob:isCuffed",function(cuffed)
			if not cuffed then
				exports['mythic_notify']:SendAlert('error', 'The player is not cuffed')
			else
				TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8, 5000, 0, 0, 0, 0, 0)
				TriggerServerEvent("esx_policejob:handcuff",target_id,false,false,playerheading,playerCoords,playerlocation)
            end
        end,GetPlayerServerId(player))
    else
		exports['mythic_notify']:SendAlert('error', 'No one is nearby')
    end
end)


-- Bar drinks
RegisterNetEvent('esx_extraitems:onDrinkBeer')
AddEventHandler('esx_extraitems:onDrinkBeer', function(prop_name)
	if not beer then
		beer = true
		TriggerEvent('ndrp_emotes:playthisemote', 'beer')
		TriggerServerEvent('esx_extraitems:removethisitem','beer')
		Citizen.Wait(20000)
		beer = false
		TriggerEvent('esx_status:add', 'thirst', 100000)
		TriggerEvent('esx_status:remove', 'stress', 50000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_extraitems:onDrinkWine')
AddEventHandler('esx_extraitems:onDrinkWine', function(prop_name)
	if not wine then
		if not IsAnimated then
			prop_name = prop_name or 'prop_wine_bot_01'
			IsAnimated = true
			Citizen.CreateThread(function()
				local playerPed = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(playerPed))
				local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
				local boneIndex = GetPedBoneIndex(playerPed, 28422)
				AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)
				ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
					TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)
					Citizen.Wait(3000)
					IsAnimated = false
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
				end)
			end)
		end
		TriggerServerEvent('esx_extraitems:removethisitem','wine')
		Citizen.Wait(20000)
		TriggerEvent('esx_status:add', 'thirst', 150000)
		TriggerEvent('esx_status:remove', 'stress', 50000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
		wine = false
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end

end)

RegisterNetEvent('esx_extraitems:onDrinkVodka')
AddEventHandler('esx_extraitems:onDrinkVodka', function(prop_name)
	if not vodka then
		if not IsAnimated then
			prop_name = prop_name or 'prop_vodka_bottle'
			IsAnimated = true
			Citizen.CreateThread(function()
				local playerPed = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(playerPed))
				local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
				local boneIndex = GetPedBoneIndex(playerPed, 28422)
				AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)
				ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
					TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)
					Citizen.Wait(3000)
					IsAnimated = false
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
				end)
			end)
		end
		
		TriggerServerEvent('esx_extraitems:removethisitem','vodka')
		Citizen.Wait(20000)
		TriggerEvent('esx_status:add', 'thirst', 150000)
		TriggerEvent('esx_status:remove', 'stress', 50000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
		vodka = false
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

---- START -----

RegisterNetEvent('esx_extraitems:useSalvage')
AddEventHandler('esx_extraitems:useSalvage', function()
	if not salvage then
		salvage = true
		TriggerServerEvent('esx_extraitems:usesalvage')
		TriggerServerEvent('esx_extraitems:removethisitem','contrat')
		Citizen.Wait(3000)
		salvage = false
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_extraitems:onDrinkTea')
AddEventHandler('esx_extraitems:onDrinkTea', function(prop_name)
	if not teacup then
		teacup = true
		TriggerEvent('ndrp_emotes:playthisemote', 'cup')
		TriggerServerEvent('esx_extraitems:removethisitem','teacup')
		Citizen.Wait(20000)
		teacup = false
		TriggerEvent('esx_status:add', 'thirst', 50000)
		TriggerEvent('esx_status:remove', 'stress', 30000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_extraitems:onDrinkCoffee')
AddEventHandler('esx_extraitems:onDrinkCoffee', function(prop_name)

	if not coffee then
		coffee = true
		TriggerEvent('ndrp_emotes:playthisemote', 'coffee')
		TriggerServerEvent('esx_extraitems:removethisitem','coffee')
		Citizen.Wait(20000)
		coffee = false
		TriggerEvent('esx_status:remove', 'thirst', 50000)
		TriggerEvent('esx_status:remove', 'stress', 120000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end

end)

RegisterNetEvent('esx_extraitems:onEatChocolate')
AddEventHandler('esx_extraitems:onEatChocolate', function(prop_name)
	if not chocolate then
		chocolate = true
		TriggerEvent('ndrp_emotes:playthisemote', 'egobar')
		TriggerServerEvent('esx_extraitems:removethisitem','chocolate')
		Citizen.Wait(20000)
		TriggerEvent('esx_status:add', 'hunger', 50000)
		TriggerEvent('ndrp_emotes:playthisemote', 'c')
		chocolate = false
		exports['mythic_notify']:SendAlert('inform', 'You fnished eating a chocolate')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_extraitems:onDrinkCola')
AddEventHandler('esx_extraitems:onDrinkCola', function(prop_name)
	if not cocacola then
		cocacola = true
		TriggerEvent('ndrp_emotes:playthisemote', 'soda')
		TriggerServerEvent('esx_extraitems:removethisitem','cocacola')
		Citizen.Wait(20000)
		cocacola = false
		TriggerEvent('esx_status:remove', 'thirst', 40000)
		TriggerEvent('esx_status:remove', 'stress', 50000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_extraitems:onDrinkIcetea')
AddEventHandler('esx_extraitems:onDrinkIcetea', function(prop_name)
	if not icetea then
		icetea = true
		TriggerEvent('ndrp_emotes:playthisemote', 'cup')
		TriggerServerEvent('esx_extraitems:removethisitem','icetea')
		Citizen.Wait(20000)
		icetea = false
		TriggerEvent('esx_status:add', 'thirst', 40000)
		TriggerEvent('esx_status:remove', 'hunger', 1000000)
		TriggerEvent('esx_status:remove', 'stress', 40000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_extraitems:onDrinkWhisky')
AddEventHandler('esx_extraitems:onDrinkWhisky', function(prop_name)
	if not whisky then
		whisky = true
		TriggerEvent('ndrp_emotes:playthisemote', 'c')
		TriggerEvent('ndrp_emotes:playthisemote', 'whiskey')
		TriggerServerEvent('esx_extraitems:removethisitem','whisky')
		Citizen.Wait(20000)
		whisky = false
		TriggerEvent('esx_status:add', 'thirst', 40000)
		TriggerEvent('esx_status:remove', 'stress', 50000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_extraitems:onDrinkTequila')
AddEventHandler('esx_extraitems:onDrinkTequila', function(prop_name)
	if not tequila then
		tequila = true
		TriggerServerEvent('esx_extraitems:removethisitem','tequila')
		if not IsAnimated then
			prop_name = prop_name or 'prop_tequila_bottle'
			IsAnimated = true

			Citizen.CreateThread(function()
				local playerPed = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(playerPed))
				local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
				local boneIndex = GetPedBoneIndex(playerPed, 28422)
				AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

				ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
					TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)
					Citizen.Wait(3000)
					IsAnimated = false
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
				end)
			end)
		end
		Citizen.Wait(20000)
		TriggerEvent('esx_status:add', 'thirst', 40000)
		TriggerEvent('esx_status:remove', 'stress', 50000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
		tequila = false
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)



--- START Burger Stuff

RegisterNetEvent('esx_extraitems:onEatVB')
AddEventHandler('esx_extraitems:onEatVB', function(prop_name)
	if not vegburger then
		vegburger = true
		TriggerEvent('ndrp_emotes:playthisemote', 'c')
		TriggerEvent('ndrp_emotes:playthisemote', 'burger')
		TriggerServerEvent('esx_extraitems:removethisitem','vegburger')
		Citizen.Wait(5000)
		vegburger = false
		TriggerEvent('esx_status:add', 'hunger', 400000)
		TriggerEvent('esx_status:remove', 'thirst', 50000)
		exports['mythic_notify']:SendAlert('inform', 'You ate a veg burger')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_extraitems:onEatCB')
AddEventHandler('esx_extraitems:onEatCB', function(prop_name)
	if not chickenburger then
		chickenburger = true
		TriggerEvent('ndrp_emotes:playthisemote', 'c')
		TriggerEvent('ndrp_emotes:playthisemote', 'burger')
		TriggerServerEvent('esx_extraitems:removethisitem','chickenburger')
		Citizen.Wait(7000)
		chickenburger = false
		TriggerEvent('esx_status:add', 'hunger', 600000)
		TriggerEvent('esx_status:remove', 'thirst', 50000)
		exports['mythic_notify']:SendAlert('inform', 'You ate a chicken burger')
		TriggerEvent('ndrp_emotes:playthisemote', 'c')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)


RegisterNetEvent('esx_extraitems:onEatMB')
AddEventHandler('esx_extraitems:onEatMB', function(prop_name)
	if not mimiburger then
		mimiburger = true
		TriggerEvent('ndrp_emotes:playthisemote', 'c')
		TriggerEvent('ndrp_emotes:playthisemote', 'burger')
		TriggerServerEvent('esx_extraitems:removethisitem','mimiburger')
		Citizen.Wait(10000)
		mimiburger = false
		TriggerEvent('esx_status:add', 'hunger', 1000000)
		TriggerEvent('esx_status:remove', 'thirst', 100000)
		exports['mythic_notify']:SendAlert('inform', 'You aren\'t hungry anymore')
		TriggerEvent('ndrp_emotes:playthisemote', 'c')
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)



-- END Burger Stuff



-- Start of Binoculars

local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0
local binoculars = false
local fov = (fov_max+fov_min)*0.5
local storeBinoclarKey = Keys["BACKSPACE"]

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		local playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerPed)

		if binoculars then
			binoculars = true
			if not (IsPedSittingInAnyVehicle(playerPed)) then
				Citizen.CreateThread(function()
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
					PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
				end)
			end
			
			Wait(2000)
			
			SetTimecycleModifier("default")
			SetTimecycleModifierStrength(0.3)
			
			local scaleform = RequestScaleformMovie("BINOCULARS")
			
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(10)
			end
			
			local playerPed = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(playerPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			
			AttachCamToEntity(cam, playerPed, 0.0,0.0,1.0, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(playerPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()
			
			while binoculars and not IsEntityDead(playerPed) and (GetVehiclePedIsIn(playerPed) == vehicle) and true do
				if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ClearPedTasks(GetPlayerPed(-1))
					binoculars = false
				end

				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
				CheckInputRotation(cam, zoomvalue)

				HandleZoom(cam)
				HideHUDThisFrame()

				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(10)
			end

			binoculars = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		end
	end
end)

RegisterNetEvent('esx_extraitems:binoculars')
AddEventHandler('esx_extraitems:binoculars', function()
	binoculars = not binoculars
end)

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
	HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local playerPed = GetPlayerPed(-1)
	if not (IsPedSittingInAnyVehicle(playerPed)) then
		if IsControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	end
end

-- End of Binoculars

RegisterNetEvent('esx_extraitems:useAmmoItem')
AddEventHandler('esx_extraitems:useAmmoItem', function(ammo)
    local playerPed = GetPlayerPed(-1)
    local weapon

    local found, currentWeapon = GetCurrentPedWeapon(playerPed, true)
    if found then
        
		for _, v in pairs(ammo.weapons) do
            if currentWeapon == v then
                weapon = v
                break
            end
        end
		
        if weapon ~= nil then
            local pedAmmo = GetAmmoInPedWeapon(playerPed, weapon)
            local newAmmo = pedAmmo + ammo.count
            ClearPedTasks(playerPed)
            local found, maxAmmo = GetMaxAmmo(playerPed, weapon)
            if newAmmo < maxAmmo then
                TaskReloadWeapon(playerPed)
                if Config.EnableInventoryHUD then
                    TriggerServerEvent('esx_inventoryhud:updateAmmoCount', weapon, newAmmo)
                end
                SetPedAmmo(playerPed, weapon, newAmmo)
                TriggerServerEvent('esx_extraitems:removeAmmoItem', ammo)
                exports['mythic_notify']:SendAlert('success', 'Reloaded')
            else
                exports['mythic_notify']:SendAlert('error', 'Max Ammo')
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local currentWeapon = GetSelectedPedWeapon(GetPlayerPed(-1)) --morpheause show ammo fix
        DisplayAmmoThisFrame(currentWeapon)
    end
end)

-- DRUGS

RegisterNetEvent('esx_drugeffects:onWeed')
AddEventHandler('esx_drugeffects:onWeed', function()
	local playerPed = GetPlayerPed(-1)
	if not weed then
		weed = true
		TriggerServerEvent('esx_extraitems:removethisitem','joint')
		TriggerEvent('ndrp_emotes:playthisemote','smokeweed')
		Citizen.Wait(15000)
		TriggerEvent('esx_status:remove', 'stress', 100000)
		exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
		TriggerEvent('ndrp_emotes:playthisemote','c')
		AddArmourToPed(playerPed, 10)
		SetPedMotionBlur(playerPed, true)
		weed = false
		Citizen.Wait(28000)
		ClearTimecycleModifier()
		SetPedMotionBlur(playerPed, false)
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_drugeffects:onCoke')
AddEventHandler('esx_drugeffects:onCoke', function()
	local playerPed = GetPlayerPed(-1)
	if not cocaine then
		cocaine = true
		exports['mythic_progbar']:Progress({
			name = "Taking cocaine",
			duration = 2000,
			label = "Taking cocaine",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "mp_suicide",
				anim = "pill",
				flags = 49,
			},
			prop = {
				model = "prop_cs_pills",
				bone = 58866,
				coords = { x = 0.1, y = 0.0, z = 0.001 },
				rotation = { x = -60.0, y = 0.0, z = 0.0 },
			},
		}, function(cancelled)
        if not cancelled then
            TriggerServerEvent('esx_extraitems:removethisitem','cocaine')
			Citizen.SetTimeout(2000, function()
				SetTimecycleModifier("spectator5")
				exports['mythic_notify']:SendAlert('inform', 'Increased Stamina')
				TriggerEvent('esx_status:remove', 'stress', 100000)
				exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
				Citizen.SetTimeout(28000, function()
					cocaine = false
					ClearTimecycleModifier()
				end)
			end)
        end
    end)
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)


RegisterNetEvent('esx_drugeffects:onMeth')
AddEventHandler('esx_drugeffects:onMeth', function()
	local playerPed = GetPlayerPed(-1)
	if not meth then
		meth = true
		exports['mythic_progbar']:Progress({
			name = "Taking Meth",
			duration = 2000,
			label = "Taking Meth",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "mp_suicide",
				anim = "pill",
				flags = 49,
			},
			prop = {
				model = "prop_cs_pills",
				bone = 58866,
				coords = { x = 0.1, y = 0.0, z = 0.001 },
				rotation = { x = -60.0, y = 0.0, z = 0.0 },
			},
		}, function(cancelled)
        if not cancelled then
            TriggerServerEvent('esx_extraitems:removethisitem','meth')
			Citizen.SetTimeout(2000, function()
				SetTimecycleModifier("spectator5")
				SetPedMotionBlur(playerPed, true)
				AddArmourToPed(playerPed, 20)
				TriggerEvent('esx_status:remove', 'stress', 200000)
				exports['mythic_notify']:SendAlert('inform', 'Stressed Relieved')
				exports['mythic_notify']:SendAlert('inform', 'Stamina Increased')
				Citizen.SetTimeout(28000, function()
					meth = false
					ClearTimecycleModifier()
					SetPedMotionBlur(playerPed, false)
				end)
			end)
        end
    end)
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

RegisterNetEvent('esx_drugeffects:onOxy')
AddEventHandler('esx_drugeffects:onOxy', function()
	local playerPed = GetPlayerPed(-1)
	if not oxy then
		oxy = true
		exports['mythic_progbar']:Progress({
			name = "Taking Oxy",
			duration = 2000,
			label = "Taking Oxy",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "mp_suicide",
				anim = "pill",
				flags = 49,
			},
			prop = {
				model = "prop_cs_pills",
				bone = 58866,
				coords = { x = 0.1, y = 0.0, z = 0.001 },
				rotation = { x = -60.0, y = 0.0, z = 0.0 },
			},
		}, function(cancelled)
        if not cancelled then
            TriggerServerEvent('esx_extraitems:removethisitem','oxy')
			Citizen.SetTimeout(2000, function()
				TriggerEvent('mythic_hospital:client:RemoveBleed')
				TriggerEvent('mythic_hospital:client:FieldTreatLimbs')
				exports['mythic_notify']:SendAlert('inform', 'Relieved Pain from Injuries')
				SetPlayerSprint(PlayerId(), true)
				oxy = false
			end)
        end
    end)
	else
		exports['mythic_notify']:SendAlert('error', 'You are already doing this action!')
	end
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(10)
		if cocaine or meth then
			RestorePlayerStamina(PlayerId(), 1.0)
		end
	end
end)