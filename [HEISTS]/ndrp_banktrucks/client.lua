ESX = nil

local PlayerData = nil
local CurrentEventNum = nil
local timing, isPlayerWhitelisted = math.ceil(2 * 60000), false
local ArmoredTruckVeh
local itemC4prop
local missionInProgress = false
local missionCompleted = false
local TruckIsExploded = false
local TruckIsDemolished = false
local KillGuardsText = false
local streetName
local _
local playerGender
local ArmoredTruckVeh
local missionStartedx = false
local mBlip 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	TriggerEvent('skinchanger:getSkin', function(skin)
		playerGender = skin.sex
	end)
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx_TruckRobbery:outlawNotify')
AddEventHandler('esx_TruckRobbery:outlawNotify', function(alert)
	if isPlayerWhitelisted then
		TriggerEvent('chat:addMessage', { templateId = "outlaw", args = { "Dispatch 10-91: " .. alert }})
	end
end)

function refreshPlayerWhitelisted()	
	if not ESX.PlayerData then
		return false
	end
	if not ESX.PlayerData.job then
		return false
	end
	if Config.PoliceDatabaseName == ESX.PlayerData.job.name or ESX.PlayerData.job.name == 'weazelnews' then
		return true
	end
	return false
end

-- // Function for 3D text // --

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

-- Blip on Map for Mission Location

Citizen.CreateThread(function()
	if Config.EnableMapBlip == true then
	  for k,v in ipairs(Config.MissionSpot)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, Config.BlipSprite)
		SetBlipDisplay(blip, Config.BlipDisplay)
		SetBlipScale  (blip, Config.BlipScale)
		SetBlipColour (blip, Config.BlipColour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.BlipNameOnMap)
		EndTextCommandSetBlipName(blip)
	  end
	end
end)

-- Core Thread Function

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in pairs(Config.MissionSpot) do
			local distance = Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z)
			if distance <= 3.0 then
				DrawMarker(Config.MissionMarker, v.x, v.y, v.z-0.975, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MissionMarkerScale.x, Config.MissionMarkerScale.y, Config.MissionMarkerScale.z, Config.MissionMarkerColor.r,Config.MissionMarkerColor.g,Config.MissionMarkerColor.b,Config.MissionMarkerColor.a, false, true, 2, true, false, false, false)					
			else
				Citizen.Wait(1000)
			end	
			if distance <= 1.0 then
				DrawText3Ds(v.x, v.y, v.z, Config.Draw3DText)
				if IsControlJustPressed(0, Config.KeyToStartMission) then
					ESX.TriggerServerCallback('ndrp_base:isCooldown', function(result)
						if result then
							ESX.TriggerServerCallback('ndrp_drugs:hasItem', function(hasItem)
								if hasItem then
									TriggerServerEvent("esx_TruckRobbery:missionAccepted")
								else
									exports['mythic_notify']:SendAlert('info', 'You don\'t have a device for injecting exploits', 7000, { ['background-color'] = '#000', ['color'] = '#fff' })
								end
							end, 'Red_USB')
						else
							exports['mythic_notify']:SendAlert('error', 'You need to wait for some time!')
						end
					end)
				end
			end
		end		
	end
end)

RegisterNetEvent('esx_TruckRobbery:TruckRobberyInProgress')
AddEventHandler('esx_TruckRobbery:TruckRobberyInProgress', function(targetCoords)
	if isPlayerWhitelisted and Config.PoliceBlipShow then
		local alpha = Config.PoliceBlipAlpha
		local policeNotifyBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.PoliceBlipRadius)
		SetBlipHighDetail(policeNotifyBlip, true)
		SetBlipColour(policeNotifyBlip, Config.PoliceBlipColor)
		SetBlipAlpha(policeNotifyBlip, alpha)
		SetBlipAsShortRange(policeNotifyBlip, true)
		while alpha ~= 0 do
			Citizen.Wait(Config.PoliceBlipTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(policeNotifyBlip, alpha)
			if alpha == 0 then
				RemoveBlip(policeNotifyBlip)
				return
			end
		end
	end
end)

RegisterNetEvent("esx_TruckRobbery:HackingMiniGame")
AddEventHandler("esx_TruckRobbery:HackingMiniGame",function()
	toggleHackGame()
end)

function toggleHackGame()
	local player = PlayerPedId()
	local anim_lib = "anim@heists@ornate_bank@hack"
	RequestAnimDict(anim_lib)
	while not HasAnimDictLoaded(anim_lib) do
		Citizen.Wait(0)
	end
	Citizen.Wait(100)
	if Config.EnableAnimationB4Hacking == true then
		TaskPlayAnim(player,anim_lib,"hack_loop",3.0,1.0,-1,30,1.0,0,0)
		Citizen.Wait(100)
	end
	FreezeEntityPosition(player,true)
	exports['progressBars']:startUI((Config.RetrieveMissionTimer * 1000), Config.Progress1)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",Config.HackingBlocks,Config.HackingSeconds,AtmHackSuccess) 
	FreezeEntityPosition(player,true)
end

function AtmHackSuccess(success)
	local player = PlayerPedId()
    FreezeEntityPosition(player,false)
    TriggerEvent('mhacking:hide')
	if success then
		TriggerServerEvent('ndrp_base:setCoolDown')
		ESX.TriggerServerCallback("esx_TruckRobbery:StartMissionNow",function()	end)
    else
		ESX.ShowNotification(Config.HackingFailed)
		ClearPedTasks(player)
		ClearPedSecondaryTask(player)
	end
	ClearPedTasks(player)
	ClearPedSecondaryTask(player)
end

-- Making sure that players don't get the same mission at the same time
local mLoc = nil

RegisterNetEvent("esx_TruckRobbery:startMission")
AddEventHandler("esx_TruckRobbery:startMission",function(spot)
	local num = math.random(1,#Config.ArmoredTruck)
	local numy = 0
	while Config.ArmoredTruck[num].InUse and numy < 100 do
		numy = numy+1
		num = math.random(1,#Config.ArmoredTruck)
	end
	if numy == 100 then
		ESX.ShowNotification(Config.NoMissionsAvailable)
	else
		CurrentEventNum = num
		missionStartedx = true
		mLoc = num
		mBlip = AddBlipForCoord(Config.mLoc[mLoc].Location)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		ESX.ShowNotification("Start mission from given location on map")
	end
end)

-- Core Mission Part

Citizen.CreateThread(function()
	local wait = 1000
	local pressed = false
	while true do
		Citizen.Wait(wait)
		if missionStartedx and mLoc ~= nil then
			wait = 100
			local mLocx = Config.mLoc[mLoc].Location
			local playerPed = GetPlayerPed(-1)
			local playerCoords = GetEntityCoords(playerPed)
			local distance = GetDistanceBetweenCoords(playerCoords,mLocx, true)
			if distance < 20 then
				wait = 5
				DrawMarker(2, mLocx, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.5, 0.5, 0.3, 255,0,0,100, false, true, 2, true, false, false, false)
				if distance < 1.5 then
					DrawText3DZ(mLocx.x,mLocx.y,mLocx.z+0.5, "~g~E~s~ - Find Bank truck")
					if IsControlJustPressed(1,46) and not pressed then
						pressed = true
						PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
						ESX.ShowNotification("Bank Truck location marked on GPS")
						TriggerEvent("esx_TruckRobbery:startTheEvent",mLoc)
						RemoveBlip(mBlip)
						missionStartedx = false
						mLoc = 0
						Citizen.Wait(1000)
						pressed = false
					end
				end
			end
		end
	end
end)


RegisterNetEvent('esx_TruckRobbery:startTheEvent')
AddEventHandler('esx_TruckRobbery:startTheEvent', function(num)
	local loc = Config.ArmoredTruck[num]
	Config.ArmoredTruck[num].InUse = true
	local playerped = GetPlayerPed(-1)
	TriggerServerEvent("esx_TruckRobbery:syncMissionData",Config.ArmoredTruck)
	local model  = GetHashKey('stockade')
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
	local gtype = GetHashKey("s_m_m_highsec_01")
	RequestModel(gtype)
	while not HasModelLoaded(gtype) do
		Wait(10)
	end

	local taken = false

	ESX.Game.SpawnVehicle(model, loc.Location, loc.heading, function(vehicle)
		
		local blip = AddBlipForEntity(vehicle)
		SetBlipSprite(blip, Config.BlipSpriteTruck)
		SetBlipColour(blip, Config.BlipColourTruck)
		AddTextEntry('MYBLIP', Config.BlipNameForTruck)
		BeginTextCommandSetBlipName('MYBLIP')
		AddTextComponentSubstringPlayerName(name)
		EndTextCommandSetBlipName(blip)
		SetBlipScale(blip, Config.BlipScaleTruck) 
		SetBlipAsShortRange(blip, true)

		local TruckDriver = CreatePedInsideVehicle(vehicle, 1, gtype, -1, true, true)
		local TruckPassenger = CreatePedInsideVehicle(vehicle, 1, gtype, 0, true, true)
		local TruckPassenger1 = CreatePedInsideVehicle(vehicle, 1, gtype, 1, true, true)
		local TruckPassenger2 = CreatePedInsideVehicle(vehicle, 1, gtype, 2, true, true)

		TriggerEvent("ndrp_carkeys:carkeys",vehicle)
	
		SetPedFleeAttributes(TruckDriver, 0, 0)
		SetPedFleeAttributes(TruckPassenger, 0, 0)
		SetPedFleeAttributes(TruckPassenger1, 0, 0)
		SetPedFleeAttributes(TruckPassenger2, 0, 0)
		SetPedCombatAttributes(TruckDriver, 46, 1)
		SetPedCombatAttributes(TruckPassenger, 46, 1)
		SetPedCombatAttributes(TruckPassenger1, 46, 1)
		SetPedCombatAttributes(TruckPassenger2, 46, 1)
		SetPedCombatAbility(TruckDriver, 100)
		SetPedCombatAbility(TruckPassenger, 100)
		SetPedCombatAbility(TruckPassenger1, 100)
		SetPedCombatAbility(TruckPassenger2, 100)
		SetPedCombatMovement(TruckDriver, 2)
		SetPedCombatMovement(TruckPassenger, 2)
		SetPedCombatMovement(TruckPassenger1, 2)
		SetPedCombatMovement(TruckPassenger2, 2)
		SetPedCombatRange(TruckDriver, 2)
		SetPedCombatRange(TruckPassenger, 2)
		SetPedCombatRange(TruckPassenger1, 2)
		SetPedCombatRange(TruckPassenger2, 2)
		SetPedKeepTask(TruckDriver, true)
		SetPedKeepTask(TruckPassenger, true)
		SetPedKeepTask(TruckPassenger1, true)
		SetPedKeepTask(TruckPassenger2, true)
		TaskEnterVehicle(TruckPassenger,ArmoredTruckVeh,-1,0,1.0,1)
		GiveWeaponToPed(TruckDriver, GetHashKey(Config.DriverWeapon),250,false,true)
		GiveWeaponToPed(TruckPassenger, GetHashKey(Config.PassengerWeapon),250,false,true)
		GiveWeaponToPed(TruckPassenger1, GetHashKey(Config.PassengerWeapon),250,false,true)
		GiveWeaponToPed(TruckPassenger2, GetHashKey(Config.PassengerWeapon),250,false,true)
		SetPedAsCop(TruckDriver, true)
		SetPedAsCop(TruckPassenger, true)
		SetPedAsCop(TruckPassenger1, true)
		SetPedAsCop(TruckPassenger2, true)
		SetPedDropsWeaponsWhenDead(TruckDriver, false)
		SetPedDropsWeaponsWhenDead(TruckPassenger, false)
		SetPedDropsWeaponsWhenDead(TruckPassenger1, false)
		SetPedDropsWeaponsWhenDead(TruckPassenger2, false)
		SetPedArmour(TruckDriver, 100)
		SetPedArmour(TruckPassenger, 100)
		SetPedArmour(TruckPassenger1, 100)
		SetPedArmour(TruckPassenger2, 100)
		TaskVehicleDriveWander(TruckDriver, vehicle, 80.0, 443)
		
		missionInProgress = true

		while not taken do
			Citizen.Wait(3)
			if missionInProgress == true then
				local pos = GetEntityCoords(GetPlayerPed(-1), false)
				local TruckPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_pside_r"))
				local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, TruckPos.x, TruckPos.y, TruckPos.z, false)
				if distance <= 2.0 and TruckIsDemolished == false then
					ESX.ShowHelpNotification(Config.OpenTruckDoor)
					if IsControlJustPressed(1, Config.KeyToOpenTruckDoor) then 
						ESX.TriggerServerCallback('ndrp_drugs:hasItem', function(hasItem)
							if hasItem then 
								BlowTheTruckDoor(vehicle)
							else 
								exports['mythic_notify']:SendAlert('info', 'You don\'t have Explosive', 7000, { ['background-color'] = '#000', ['color'] = '#fff' })
							end
						end, 'c4_bank')
						Citizen.Wait(500)
					end
				end
			end
			
			if TruckIsExploded == true then
				local pos = GetEntityCoords(GetPlayerPed(-1), false)
				local TruckPos = GetEntityCoords(vehicle) 
				local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, TruckPos.x, TruckPos.y, TruckPos.z, false)
			
				if distance > 45.0 then
				Citizen.Wait(500)
				end
				
				if distance <= 4.5 then
					ESX.ShowHelpNotification(Config.RobFromTruck)
					if IsControlJustPressed(0, Config.KeyToRobFromTruck ) then 
						TruckIsExploded = false
						RobbingTheMoney()
						Citizen.Wait(500)
					end
				end
			end
			
			if missionCompleted == true then
				ESX.ShowNotification(Config.MissionCompleted)
				Config.ArmoredTruck[num].InUse = false
				RemoveBlip(blip)
				TriggerServerEvent("esx_TruckRobbery:syncMissionData",Config.ArmoredTruck)
				taken = true
				missionInProgress = false
				missionCompleted = false
				TruckIsExploded = false
				TruckIsDemolished = false
				KillGuardsText = false
				break
			end
		end
	end)
end)

-- Function for blowing the door on the truck

function BlowTheTruckDoor(ArmoredTruckX)
	local ArmoredTruckVeh = ArmoredTruckX
	if IsVehicleStopped(ArmoredTruckVeh) then
		if (IsVehicleSeatFree(ArmoredTruckVeh, -1) and IsVehicleSeatFree(ArmoredTruckVeh, 0) and IsVehicleSeatFree(ArmoredTruckVeh, 1)) then
			TruckIsDemolished = true
			SetVehicleDoorShut( ArmoredTruckVeh, 2, true)
			SetVehicleDoorShut( ArmoredTruckVeh, 3, true)
			RequestAnimDict('anim@heists@ornate_bank@thermal_charge_heels')
			while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge_heels') do
				Citizen.Wait(50)
			end
			
			if Config.PoliceNotfiyEnabled == true then
				TriggerServerEvent('esx_TruckRobbery:TruckRobberyInProgress',GetEntityCoords(PlayerPedId()),streetName)
			end
			
			local playerPed = GetPlayerPed(-1)
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			itemC4prop = CreateObject(GetHashKey('prop_c4_final_green'), x, y, z+0.2,  true,  true, true)
			SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"),true)
			Citizen.Wait(700)
			FreezeEntityPosition(playerPed, true)
			TaskPlayAnim(playerPed, 'anim@heists@ornate_bank@thermal_charge_heels', "thermal_charge", 3.0, -8, -1, 63, 0, 0, 0, 0 )
			TriggerServerEvent('esx_extraitems:removethisitem','c4_bank')
			exports['progressBars']:startUI(5500, Config.Progress2)
			
			ClearPedTasks(playerPed)
			
			AttachEntityToEntity(itemC4prop, ArmoredTruckVeh, GetEntityBoneIndexByName(ArmoredTruckVeh, 'door_pside_r'), -0.7, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
			FreezeEntityPosition(playerPed, false)
			Citizen.Wait(500)
			
			FreezeEntityPosition(ArmoredTruckVeh, true)

			exports['progressBars']:startUI(180000, Config.Progress3)	
			
			local TruckPos = GetEntityCoords(ArmoredTruckVeh)
			SetVehicleDoorBroken(ArmoredTruckVeh, 2, false)
			SetVehicleDoorBroken(ArmoredTruckVeh, 3, false)
			AddExplosion(TruckPos.x,TruckPos.y,TruckPos.z, 'EXPLOSION_TANKER', 2.0, true, false, 2.0)
			ApplyForceToEntity(ArmoredTruckVeh, 0, TruckPos.x,TruckPos.y,TruckPos.z, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
			TruckIsExploded = true
			ESX.ShowNotification(Config.BeginToRobTruck)
			DeleteEntity(itemC4prop)
		else
			SetVehicleDoorShut( ArmoredTruckVeh, 2, true)
			SetVehicleDoorShut( ArmoredTruckVeh, 3, true)
			ESX.ShowNotification(Config.GuardsNotKilledYet)
		end
	else
		ESX.ShowNotification(Config.TruckIsNotStopped)
	end
end

-- Function for robbing the money in the truck

function RobbingTheMoney()	
	RequestAnimDict('anim@heists@ornate_bank@grab_cash_heels')
	while not HasAnimDictLoaded('anim@heists@ornate_bank@grab_cash_heels') do
		Citizen.Wait(50)
	end
	local playerPed = GetPlayerPed(-1)
	local pos = GetEntityCoords(playerPed)
	TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
	FreezeEntityPosition(playerPed, true)
	exports['progressBars']:startUI((Config.RobTruckTimer * 1000), Config.Progress4)
	DeleteEntity(moneyBag)
	ClearPedTasks(playerPed)
	FreezeEntityPosition(playerPed, false)
	if Config.EnablePlayerMoneyBag == true then
		SetPedComponentVariation(playerPed, 5, 41, 0, 2)
	end
	TriggerServerEvent("esx_TruckRobbery:missionComplete")
	TruckIsExploded = false
	TruckIsDemolished = false
	missionInProgress = false
	Citizen.Wait(1000)
	missionCompleted = true
end

-- Thread for Police Notify

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

-- Sync mission data
RegisterNetEvent("esx_TruckRobbery:syncMissionData")
AddEventHandler("esx_TruckRobbery:syncMissionData",function(data)
	Config.ArmoredTruck = data
end)

function DrawText3DZ(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
end