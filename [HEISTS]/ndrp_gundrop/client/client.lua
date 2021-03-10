local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["K"] = 311
}

local hasAlreadyEnteredMarkerCode = false
local hasAlreadyEnteredMarkerCraft = false
local isInMarkerCode = false
local isInMarkerCraft = false
local PlayerData
ESX = nil
local canPressCode = true
local canPressCraft = true
local timeremaining = 900000
local codeName
local craftName
local code = nil
local codeMarkerName = nil
local craftMarkerName = nil
local canEnterCode = false
local machinepistol = {}
local heavypistol = {}
local appistol = {}
local pilot, aircraft, crate, pickup
local requiredModels = {"ex_prop_adv_case_sm", "cuban800", "s_m_m_pilot_02", "prop_box_wood02a_pu" }
local sessionTime = 0
local task = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	drawMarkers()
end)


RegisterCommand('darkweb', function(source, args)
	if args[1] == code and canEnterCode then
		if codeMarkerName == craftMarkerName then
			code = nil
			canEnterCode = false
			TriggerServerEvent('ndrp_200iq:inventoryCheck', codeMarkerName, machinepistol, heavypistol, appistol)
		else
			exports['mythic_notify']:SendAlert('info', 'Code not for this weapon!', 3000, { ['background-color'] = '#000', ['color'] = '#fff' })
		end
	elseif args[1] ~= code and canEnterCode then
		exports['mythic_notify']:SendAlert('info', 'Careful. The code you entered is not correct!', 6000, { ['background-color'] = '#000', ['color'] = '#fff' })
	elseif not canEnterCode then
		exports['mythic_notify']:SendAlert('info', 'What are you trying to do?', 3000, { ['background-color'] = '#000', ['color'] = '#fff' })
	end
end, false)

RegisterCommand('enter', function(source, args)
	
	local coords = GetEntityCoords(PlayerPedId())
	local distEnter = GetDistanceBetweenCoords(coords, Config.Satellite.enter, true)
	local distExit = GetDistanceBetweenCoords(coords, Config.Satellite.exit, true)
	
	if distEnter < 0.7 then
		SetEntityCoords(PlayerPedId(), Config.Satellite.exit, false, false, false, false)
	elseif distExit < 0.7 then
		SetEntityCoords(PlayerPedId(), Config.Satellite.enter, false, false, false, false)
	end

	local blackEnter = GetDistanceBetweenCoords(coords, vector3(1407.99,-2221.22,61.81), true)
	local blackExit = GetDistanceBetweenCoords(coords, vector3(179.12, -1000.13, -99.0), true)

	if blackEnter < 0.7 then
		SetEntityCoords(PlayerPedId(), vector3(179.12, -1000.13, -99.0), false, false, false, false)
	elseif blackExit < 0.7 then
		SetEntityCoords(PlayerPedId(), vector3(1407.99,-2221.22,61.81), false, false, false, false)
	end

	local gpEnter = GetDistanceBetweenCoords(coords, vector3(-197.28,-831.27,30.75), true)
	local gpExit = GetDistanceBetweenCoords(coords, vector3(212.17,-999.01,-99.0), true)

	if gpEnter < 0.7 then
		SetEntityCoords(PlayerPedId(), vector3(206.87,-999.07,-99.0), false, false, false, false)
	elseif gpExit < 0.7 then
		SetEntityCoords(PlayerPedId(), vector3(-197.28,-831.27,30.75), false, false, false, false)
	end

	local chopEnter = GetDistanceBetweenCoords(coords, vector3(752.89,-3198.6,6.19), true)
	local chopExit = GetDistanceBetweenCoords(coords, vector3(996.91,-3200.57,-36.39), true)

	if chopEnter < 0.7 then
		SetEntityCoords(PlayerPedId(), vector3(996.91,-3200.57,-37.40), false, false, false, false)
	elseif chopExit < 0.7 then
		SetEntityCoords(PlayerPedId(), vector3(752.89,-3198.6,5.20), false, false, false, false)
	end

end, false)

function drawMarkers()
	TriggerEvent('chat:addSuggestion', '/darkweb', 'Portal to the Dark Web used to order crafted weapons by entering secret codes!')
	local pcradius = false
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local coords = GetEntityCoords(PlayerPedId())
			isInMarkerCode = false
			isInMarkerCraft = false
			for k,v in ipairs(Config.Marker) do
				if v.name == 'machinepistol' and machinepistol['money'] == nil then
					machinepistol = v.material
				elseif v.name == 'heavypistol' and heavypistol['money'] == nil then
					heavypistol = v.material
				elseif v.name == 'appistol' and appistol['money'] == nil then
					appistol = v.material
				end
				local distance = GetDistanceBetweenCoords(coords, v.puzzle, true)
				local distanceCraft = GetDistanceBetweenCoords(coords, v.craft, true)
				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, v.puzzle, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if distanceCraft < Config.DrawDistance then
					DrawMarker(Config.MarkerType, v.craft, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if distance < (Config.MarkerSize.x * 2) then
					isInMarkerCode = true
					if canPressCode then
						codeName = v.name
						ESX.ShowHelpNotification(_U('code_location_help'), true, true, 2000)
					end
				end
				if distanceCraft < (Config.MarkerSize.x * 2) then
					isInMarkerCraft = true
					if canPressCraft then
						craftName = v.name
						ESX.ShowHelpNotification(_U(v.name), true, true, 2000)
					end
				end
			end

			local distPC = GetDistanceBetweenCoords(coords, Config.Satellite.marker, true)
			if distPC < 1 then
				ESX.ShowHelpNotification(_U('access_pc'), true, true)
				pcradius = true
			else
				pcradius = false
			end

			if isInMarkerCode and not hasAlreadyEnteredMarkerCode then
				hasAlreadyEnteredMarkerCode = true
			end

			if not isInMarkerCode and hasAlreadyEnteredMarkerCode then
				hasAlreadyEnteredMarkerCode = false
			end

			if isInMarkerCraft and not hasAlreadyEnteredMarkerCraft then
				hasAlreadyEnteredMarkerCraft = true
			end

			if not isInMarkerCraft and hasAlreadyEnteredMarkerCraft then
				hasAlreadyEnteredMarkerCraft = false
			end

			if IsControlJustReleased(0, Keys['E']) and isInMarkerCode then
				if canPressCode then
					TriggerServerEvent('ndrp_200iq:cardCheck')
					task = 'pistolCode'
					codeMarkerName = codeName
				else
					local secondTime = math.floor(timeremaining/1000)
					local minuteTime = math.floor(secondTime/60)
					if secondTime <= 60 then
						exports['mythic_notify']:SendAlert('info', 'Your session of Dark Web has expired. You may try again after ' .. string.format("%02d",secondTime) .. ' secs!', 5000, { ['background-color'] = '#000', ['color'] = '#fff' })
					else
						exports['mythic_notify']:SendAlert('info', 'Your session of Dark Web has expired. You may try again after ' .. string.format("%02d",minuteTime) .. ' mins!', 5000, { ['background-color'] = '#000', ['color'] = '#fff' })
					end
				end
			elseif IsControlJustReleased(0, Keys['E']) and isInMarkerCraft then
				if code ~= nil then
					canEnterCode = true
					craftMarkerName = craftName
					exports['mythic_notify']:SendAlert('info', 'Use {/darkweb [code]} to craft weapon!', 15000, { ['background-color'] = '#000', ['color'] = '#fff' })
				else
					exports['mythic_notify']:SendAlert('info', 'You don\'t have the code!', 3000, { ['background-color'] = '#000', ['color'] = '#fff' })
				end
			elseif IsControlJustReleased(0, Keys['E']) and pcradius then
				TriggerServerEvent('ndrp_200iq:cardCheck')
				task = 'pcAccess'
			end
		end
	end)
end

RegisterNetEvent('ndrp_200iq:cardCheckResult')
AddEventHandler('ndrp_200iq:cardCheckResult', function(hasCard)
	if hasCard then
		if task == 'pistolCode' then
			canPressCode = false
			task = ''
			timeremaining = 900000
			coolDown()
			Citizen.Wait(100)
			exports['mythic_notify']:SendAlert('info', 'Information is a weapon. People sharing it will be dealt with.', 3000, { ['background-color'] = '#000', ['color'] = '#fff' })
			Citizen.SetTimeout(3000, function()
				exports['mythic_notify']:SendAlert('info', 'Accessing Syndicate\'s darkweb... decrypting code...', 4000, { ['background-color'] = '#000', ['color'] = '#fff' })
			end)
			Citizen.SetTimeout(7000, function()
				local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
				local length = 6
				local randomString = ''

				local charTable = {}
				for c in chars:gmatch"." do
					table.insert(charTable, c)
				end

				for i = 1, length do
					randomString = randomString .. charTable[math.random(1, #charTable)]
				end
				code = randomString
				exports['mythic_notify']:SendAlert('info', 'Code retrieved: ' .. randomString .. '   (will expire after 15 mins)', 15000, { ['background-color'] = '#000', ['color'] = '#fff' })
			end)
		elseif task == 'pcAccess' then
			task = ''
			SetEntityCoords(PlayerPedId(), 1162.77, -3196.38, -40.20, false, false, false, false)
			SetEntityHeading(PlayerPedId(), 270.0)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "access_syndicate_web",
				duration = 10000,
				label = "Accessing Syndicate's Dark Web",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "anim@heists@prison_heiststation@cop_reactions",
					anim = "cop_b_idle",
				},
				prop = {

				}
			}, function(status)
				if not status then
					ClearPedTasks(PlayerPedId())
					local menutitle = "access_pc_title"
					local elements = {
						{label = 'Golden Satellite Phone  |   $' .. Config.Satellite.golden.price, value = 'golden'},
						{label = 'Red Satellite Phone     |   $' .. Config.Satellite.red.price,  value = 'red'},
						{label = 'Green Satellite Phone   |   $' .. Config.Satellite.green.price, value = 'green'}
					}
					ESX.UI.Menu.CloseAll()

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'darkweb_actions', {
						title    = _U(menutitle),
						align    = 'top-right',
						elements = elements
					}, function(data, menu)
						if data.current.value == 'red' then
							menu.close()
							TriggerServerEvent('ndrp_200iq:givePhone', 'red', Config.Satellite.red.price, coords)
						elseif data.current.value == 'golden' then
							menu.close()
							TriggerServerEvent('ndrp_200iq:givePhone', 'golden', Config.Satellite.golden.price, coords)
						elseif data.current.value == 'green' then
							menu.close()
							TriggerServerEvent('ndrp_200iq:givePhone', 'green', Config.Satellite.green.price, coords)
						end
					end, function(data, menu)
						menu.close()
					end)
				else
					ClearPedTasks(PlayerPedId())
				end
			end)
		end
	else
		exports['mythic_notify']:SendAlert('info', 'Show us the card and tell us who you belong to!', 7000, { ['background-color'] = '#000', ['color'] = '#fff' })
	end
end)

RegisterNetEvent('ndrp_200iq:drop')
AddEventHandler('ndrp_200iq:drop', function(weapon, ammo, planeSpawnDistance)
	Citizen.CreateThread(function()
		local dropCoords = GetEntityCoords(PlayerPedId())
		RequestWeaponAsset(GetHashKey("weapon_flare")) -- flare won't spawn later in the script if we don't request it right now
		while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
			Citizen.Wait(0)
		end
		Citizen.Wait(100)
		ShootSingleBulletBetweenCoords(dropCoords, dropCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0)
		Citizen.SetTimeout(30000, function()
			exports['mythic_notify']:SendAlert('info', 'Preparing crate. Our pilot will contact you.', 4000, { ['background-color'] = '#000', ['color'] = '#fff' })
		end)
		Citizen.SetTimeout(60000, function()
			local streetName,_ = GetStreetNameAtCoord(dropCoords.x, dropCoords.y, dropCoords.z)
			streetName = GetStreetNameFromHashKey(streetName)
			TriggerServerEvent('ndrp_200iq:checkpolice',dropCoords, streetName)
		end)
		Citizen.SetTimeout(300000, function()
			for i = 1, #requiredModels do
				RequestModel(GetHashKey(requiredModels[i]))
				while not HasModelLoaded(GetHashKey(requiredModels[i])) do
					Wait(0)
				end
			end
			exports['mythic_notify']:SendAlert('info', 'PILOT: On my way to the flare signal', 3000, { ['background-color'] = '#000', ['color'] = '#fff' })

			local rHeading = math.random(0, 360) + 0.0
			local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0 -- this defines how far away the plane is spawned
			local theta = (rHeading / 180.0) * 3.14
			local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -500.0) -- the plane is spawned at

			local dx = dropCoords.x - rPlaneSpawn.x
			local dy = dropCoords.y - rPlaneSpawn.y
			local heading = GetHeadingFromVector_2d(dx, dy) -- determine plane heading from coordinates

			aircraft = CreateVehicle(GetHashKey("cuban800"), rPlaneSpawn, heading, true, true)
			SetEntityHeading(aircraft, heading)
			SetVehicleDoorsLocked(aircraft, 2)
			SetEntityDynamic(aircraft, true)
			ActivatePhysics(aircraft)
			SetVehicleForwardSpeed(aircraft, 60.0)
			SetHeliBladesFullSpeed(aircraft)
			SetVehicleEngineOn(aircraft, true, true, false)
			ControlLandingGear(aircraft, 3)
			OpenBombBayDoors(aircraft)
			SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)

			pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
			SetBlockingOfNonTemporaryEvents(pilot, true)
			SetPedRandomComponentVariation(pilot, false)
			SetPedKeepTask(pilot, true)
			SetPlaneMinHeightAboveTerrain(aircraft, 50)

			TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 50.0), 60.0, 0, GetHashKey("cuban800"), 262144, 15.0, -1.0) -- to the dropsite, could be replaced with a task sequence

			local droparea = vector2(dropCoords.x, dropCoords.y)
			local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
			while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do
				Wait(100)
				planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
			end
			exports['mythic_notify']:SendAlert('info', 'PILOT: Keep an eye on the skies. Crate is dropping!', 6000, { ['background-color'] = '#000', ['color'] = '#fff' })
			if IsEntityDead(pilot) then
			--	print("PILOT: dead")
				do return end
			end

			TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey("cuban800"), 262144, -1.0, -1.0)
			SetEntityAsNoLongerNeeded(pilot)
			SetEntityAsNoLongerNeeded(aircraft)

			local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0)

			crate = CreateObject(GetHashKey("prop_box_wood02a_pu"), crateSpawn, true, true, true)
			SetEntityLodDist(crate, 1000)
			ActivatePhysics(crate)
			SetDamping(crate, 2, 0.1)
			SetEntityVelocity(crate, 0.0, 0.0, -0.2)

			local dist = GetEntityHeightAboveGround(crate)
			while dist >= 1 do
			--	print(dist)
				Citizen.Wait(10)
				dist = GetEntityHeightAboveGround(crate)
			end
			local crateCoords = GetEntityCoords(crate)
			exports['mythic_notify']:SendAlert('info', 'CAUTION: Crate will be autodestroyed if someone else tries to pick it!', 15000, { ['background-color'] = '#000', ['color'] = '#fff' })

			pickup = CreateAmbientPickup(GetHashKey('PICKUP_' .. weapon), crateCoords.x, crateCoords.y, crateCoords.z, 2, ammo, GetHashKey("ex_prop_adv_case_sm"), true, true) -- create the pickup itself, location isn't too important as it'll be later attached properly
			ShootSingleBulletBetweenCoords(crateCoords, crateCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0)
			local crateBeacon = StartParticleFxLoopedOnEntity_2("scr_crate_drop_beacon", pickup, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)--1.0, false, false, false)
			SetParticleFxLoopedColour(crateBeacon, 0.8, 0.18, 0.19, false)

			while DoesEntityExist(pickup) do
				Wait(0)
			end

			while DoesObjectOfTypeExistAtCoords(crateCoords, 10.0, GetHashKey("w_am_flare"), true) do
				Wait(0)
				local prop = GetClosestObjectOfType(crateCoords, 10.0, GetHashKey("w_am_flare"), false, false, false)
				RemoveParticleFxFromEntity(prop)
				SetEntityAsMissionEntity(prop, true, true)
				local pickedupx = 0
				if pickedupx == 0 then 
					TriggerServerEvent("ndrp_base:buyItem",weapon,0,1)
					pickup = 1
				end
				DeleteObject(prop)
			end

			if DoesBlipExist(blipx) then -- remove the blip, should get removed when the pickup gets picked up anyway, but isn't a bad idea to make sure of it
				RemoveBlip(blipx)
			end

			for i = 1, #requiredModels do
				Wait(0)
				SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
			end
			pickedupx = 0
			RemoveWeaponAsset(GetHashKey("weapon_flare"))
		end)
	end)
end)

RegisterNetEvent('ndrp_200iq:policeresponce')
AddEventHandler('ndrp_200iq:policeresponce', function(dCoords,sname)
	
	TriggerEvent('chat:addMessage', {
		templateId = 'outlaw',
		args = {"CODE 3 : ", "Suspiscious activity reported at: "..sname}
	})
	
	local dblip = AddBlipForCoord(dCoords)
	
	SetBlipSprite(dblip, 458)
	SetBlipScale(dblip, 3.0)
	SetBlipColour(dBlip, 1)
	SetBlipAsShortRange(dblip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Suspiscious Activity")
	EndTextCommandSetBlipName(dblip)
	
	Citizen.SetTimeout(60000, function()
		RemoveBlip(dblip)
	end)

end)

function coolDown()
	Citizen.CreateThread(function()
		while timeremaining > 0 do
			Citizen.Wait(1000)
			timeremaining = timeremaining - 1000
		end
		canPressCode = true
		code = nil
		canEnterCode = false
	end)
end