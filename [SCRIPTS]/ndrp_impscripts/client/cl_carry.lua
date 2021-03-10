local carryingBackInProgress = false
local carryHostage = false
local beingCarried = false
local carryAnimNamePlaying = ""
local carryAnimDictPlaying = ""
local carryControlFlagPlaying = 0
local intrunk = false
local att
local checkin = false

RegisterCommand("carry",function(source, args)
	
	if not beingCarried then 
		if not carryingBackInProgress then
			carryingBackInProgress = true
			local player = PlayerPedId()	
			lib = 'missfinale_c2mcs_1'
			anim1 = 'fin_c2_mcs_1_camman'
			lib2 = 'nm'
			anim2 = 'firemans_carry'
			distans = 0.15
			distans2 = 0.27
			height = 0.63
			spin = 0.0
			length = 100000
			controlFlagMe = 49
			controlFlagTarget = 33
			animFlagTarget = 1
		
			local closestPlayer = GetClosestPlayer(2)
			target = GetPlayerServerId(closestPlayer)
		
			if closestPlayer ~= nil then 
				local invehicle = GetVehiclePedIsIn(player)
				if invehicle == 0 then
					carryHostage = true
					TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)	
				end
			end
		else
			carryAnimNamePlaying = ""
			carryAnimDictPlaying = ""
			carryControlFlagPlaying = 0
			carryHostage = false
			carryingBackInProgress = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local closestPlayer = GetClosestPlayer(2)
			target = GetPlayerServerId(closestPlayer)
			TriggerServerEvent("cmg2_animations:stop", target)
		end
	end
end,false)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	local playerPos = GetEntityCoords(playerPed, true)
	TriggerEvent('esx_ambulancejob:carrycheck',true)
	
	att = true
	beingCarried = true	
	intrunk = false
	carryingBackInProgress = true
	
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)	
	end

	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation2
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag

end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)
	
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	
	Wait(500)
	
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
	Citizen.Wait(length)
	
end)


Citizen.CreateThread(function()
	while true do
		if carryHostage or beingCarried then 
			while not IsEntityPlayingAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
				TaskPlayAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
		end
		Wait(0)
	end
end)


RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	TriggerEvent('esx_ambulancejob:carrycheck', false)
	SetEntityVisible(GetPlayerPed(-1),true)
	carryingBackInProgress = false
	carryHostage = false
	beingCarried = false
	intrunk =  false
	carryAnimNamePlaying = ""
	carryAnimDictPlaying = ""
	carryControlFlagPlaying = 0
	ClearPedSecondaryTask(GetPlayerPed(-1))
	ClearPedTasksImmediately(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end


RegisterNetEvent('cmg2_animations:putVehicle')
AddEventHandler('cmg2_animations:putVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	ClearPedTasksImmediately(playerPed)
	
	carryingBackInProgress = false
	carryHostage = false
	beingCarried = false
	carryAnimNamePlaying = ""
	carryAnimDictPlaying = ""
	carryControlFlagPlaying = 0

	if IsAnyVehicleNearPoint(coords, 5.0) then
		
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
		local vehClass = GetVehicleClass(vehicle)
		
		if vehClass ~= 8 and vehClass ~= 13 and vehClass ~= 14 then
			
			SetVehicleDoorOpen(vehicle, 5, false, false)
			local trunk = GetEntityBoneIndexByName(vehicle, 'boot')
			AttachEntityToEntity(playerPed, vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			RequestAnimDict('timetable@floyd@cryingonbed@base')
			
			while not HasAnimDictLoaded('timetable@floyd@cryingonbed@base') do
				Citizen.Wait(10)
			end
			TaskPlayAnim(playerPed, 'timetable@floyd@cryingonbed@base', 'base', 1.0, -1, -1, 1, 0, 0, 0, 0)
			Citizen.Wait(1000)
			SetVehicleDoorShut(vehicle, 5, false, false)
			att = false
			while true do
				Wait(300)
				if not att then
					AttachEntityToEntity(playerPed, vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					TaskPlayAnim(playerPed, 'timetable@floyd@cryingonbed@base', 'base', 1.0, -1, -1, 1, 0, 0, 0, 0)
				else
					break
				end
			end
		end	
	end
end)

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if carryHostage then
			if IsControlJustReleased(1,  46) then
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				if IsAnyVehicleNearPoint(coords, 5.0) then
					local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
					local vehClass = GetVehicleClass(vehicle)
					if DoesEntityExist(vehicle) then
						if vehClass ~= 8 and vehClass ~= 13 and vehClass ~= 14 then
							actionMsg = false
							TriggerServerEvent('cmg2_animations:putVehicle', GetPlayerServerId(GetClosestPlayer(1)))
							carryHostage = false
							carryingBackInProgress = false
							ClearPedTasksImmediately(GetPlayerPed(-1))
						end
					end
				end
			end
			
			DisablePlayerFiring(PlayerPedId(), true)
	--		DisableControlAction(0,23)
	--		DisableControlAction(0,49)
	--		DisableControlAction(0,75)
	--		DisableControlAction(0,145)
			DisableControlAction(0,21)
		
		elseif beingCarried or intrunk then
			if checkin then

				beingCarried = false
				intrunk =false
				TriggerEvent('cmg2_animations:cl_stop')
				checkin = false
			end
				
			DisableAllControlActions(0)
			EnableControlAction(0,177)
			EnableControlAction(0,200)
			EnableControlAction(0,202)
			EnableControlAction(0,245)
			EnableControlAction(0,322)
			EnableControlAction(0,303)
			EnableControlAction(0,1)
			EnableControlAction(0,2)
			EnableControlAction(0,3)
			EnableControlAction(0,4)
			EnableControlAction(0,5)
			EnableControlAction(0,6)
			EnableControlAction(0,57)
			DisablePlayerFiring(PlayerPedId(), true) 
		else
			Citizen.Wait(250)
		end
    end
end)

RegisterNetEvent("ndrp_carry:checking")
AddEventHandler("ndrp_carry:checking", function(checkcheck)
	if checkcheck then 
		checkin = true
	end
end)