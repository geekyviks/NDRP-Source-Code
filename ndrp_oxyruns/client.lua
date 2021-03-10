ESX = nil

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

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local tasking = false
local drugStorePed = 0
local oxyVehicle = 0

local OxyDropOffs = {

    [1] =  { ['x'] = 264.57,['y'] = -2506.28,['z'] = 6.44,['h'] = 294.26, ['info'] = ' 1' },
    [2] =  { ['x'] = -495.41,['y'] = -2911.64,['z'] = 6.0,['h'] = 226.23, ['info'] = ' 2' },
    [3] =  { ['x'] = 1863.62,['y'] = -1103.43,['z'] = 84.05,['h'] = 241.74, ['info'] = ' 3' },
    [4] =  { ['x'] = 983.63,['y'] = -149.13,['z'] = 74.24,['h'] = 55.52, ['info'] = ' 4' },
    [5] =  { ['x'] = -497.81,['y'] = 79.82,['z'] = 55.94,['h'] = 84.83, ['info'] = ' 5' },
    [6] =  { ['x'] = -1412.38,['y'] = -653.19,['z'] = 28.67,['h'] = 39.58, ['info'] = ' 6' },
    [7] =  { ['x'] = -1307.74,['y'] = -1317.45,['z'] = 4.88,['h'] = 21.67, ['info'] = ' chewy1' },
    [8] =  { ['x'] = 389.62, ['y'] = 799.75, ['z'] = 187.67, ['h'] = 269.75, ['info'] = ' biscuts2' },
    [9] =  { ['x'] = -464.77,['y'] = -965.1,['z'] = 23.55,['h'] = 84.79, ['info'] = ' are3' },
    [10] =  { ['x'] = -984.23, ['y'] = -2640.88, ['z'] = 13.97, ['h'] = 149.98, ['info'] = ' only4' },
    [11] =  { ['x'] = 1986.83,['y'] = 3057.87,['z'] = 47.22,['h'] = 323.25, ['info'] = ' nice5' },
    [12] =  { ['x'] = 1218.98,['y'] = 1848.52,['z'] = 78.95,['h'] = 224.7, ['info'] = ' ifthey6' },
    [13] =  { ['x'] = 1530.17,['y'] = -2538.08,['z'] = 57.62,['h'] = 41.96, ['info'] = ' contain7' },
    [14] =  { ['x'] = 86.5,['y'] = -1955.99,['z'] = 20.75,['h'] = 326.3, ['info'] = ' chocolate' },

} 

local carspawns = {
    [1] =  { ['x'] = 67.96,['y'] = -1558.67,['z'] = 29.46,['h'] = 52.34, ['info'] = ' car 8' }
} 

local pillWorker = { ['x'] = 69.01,['y'] = -1570.03,['z'] = 29.6,['h'] = 229.73, ['info'] = 'boop bap' }

local rnd = 0
local blip = 0
local deliveryPed = 0

local oxyPeds = {
	'a_m_y_stwhi_02',
	'a_m_y_stwhi_01'
}

local drugLocs = {
	[1] =  { ['x'] = 131.94,['y'] = -1937.95,['z'] = 20.61,['h'] = 118.59, ['info'] = ' Grove Stash' },
	[2] =  { ['x'] = 1390.84,['y'] = -1507.94,['z'] = 58.44,['h'] = 29.6, ['info'] = ' East Side' },
	[3] =  { ['x'] = -676.81,['y'] = -877.94,['z'] = 24.48,['h'] = 324.9, ['info'] = ' Wei Cheng' },
}

local carpick = {
    [1] = "felon",
    [2] = "kuruma",
    [3] = "sultan",
    [4] = "granger",
    [5] = "tailgater",
}

function CreateOxyVehicle()

	if DoesEntityExist(oxyVehicle) then

	    SetVehicleHasBeenOwnedByPlayer(oxyVehicle,false)
		SetEntityAsNoLongerNeeded(oxyVehicle)
		DeleteEntity(oxyVehicle)
	end

    local car = GetHashKey(carpick[math.random(#carpick)])
    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end

    local spawnpoint = 1
    for i = 1, #carspawns do
	    local caisseo = GetClosestVehicle(carspawns[i]["x"], carspawns[i]["y"], carspawns[i]["z"], 3.500, 0, 70)
		if not DoesEntityExist(caisseo) then
			spawnpoint = i
		end
    end

    oxyVehicle = CreateVehicle(car, carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"], carspawns[spawnpoint]["h"], true, false)
    local plt = GetVehicleNumberPlateText(oxyVehicle)
    SetVehicleHasBeenOwnedByPlayer(oxyVehicle,true)
	TriggerEvent("ndrp_carkeys:forceTurnOver", oxyVehicle)

    while true do
    	Citizen.Wait(1)
    	 DrawText3Ds(carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"], "Your Delivery Car (Stolen).")
    	 if #(GetEntityCoords(PlayerPedId()) - vector3(carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"])) < 8.0 then
    	 	return
    	 end
    end

end

function CreateOxyPed()

    local hashKey = `a_m_y_stwhi_01`
    local pedType = 5
    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end

	deliveryPed = CreatePed(pedType, hashKey, OxyDropOffs[rnd]["x"],OxyDropOffs[rnd]["y"],OxyDropOffs[rnd]["z"], OxyDropOffs[rnd]["h"], 0, 0)
	
    ClearPedTasks(deliveryPed)
    ClearPedSecondaryTask(deliveryPed)
    TaskSetBlockingOfNonTemporaryEvents(deliveryPed, true)
    SetPedFleeAttributes(deliveryPed, 0, 0)
    SetPedCombatAttributes(deliveryPed, 17, 1)
    SetPedSeeingRange(deliveryPed, 0.0)
    SetPedHearingRange(deliveryPed, 0.0)
    SetPedAlertness(deliveryPed, 0)
    SetPedKeepTask(deliveryPed, true)
	
end

function DeleteCreatedPed()
	if DoesEntityExist(deliveryPed) then 
		SetPedKeepTask(deliveryPed, false)
		TaskSetBlockingOfNonTemporaryEvents(deliveryPed, false)
		ClearPedTasks(deliveryPed)
		TaskWanderStandard(deliveryPed, 10.0, 10)
		SetPedAsNoLongerNeeded(deliveryPed)
		Citizen.Wait(20000)
		DeletePed(deliveryPed)
	end
end

function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
		SetBlipRoute (blip,false)
	end
end

function CreateBlip()
	DeleteBlip()
	if OxyRun then
		blip = AddBlipForCoord(OxyDropOffs[rnd]["x"],OxyDropOffs[rnd]["y"],OxyDropOffs[rnd]["z"])
	end
    SetBlipRoute (blip,true)
    SetBlipSprite(blip, 51)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Oxy Drop Off")
    EndTextCommandSetBlipName(blip)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function playerAnim()
	loadAnimDict( "mp_safehouselost@" )
    TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

function giveAnim()
    if ( DoesEntityExist( deliveryPed ) and not IsEntityDead( deliveryPed ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end

function DoDropOff()
	local success = true
	local OxyChance = math.random(1,1000)

	Citizen.Wait(1000)
	playerAnim()
	Citizen.Wait(800)

	PlayAmbientSpeech1(deliveryPed, "Chat_State", "Speech_Params_Force")

	if DoesEntityExist(deliveryPed) and not IsEntityDead(deliveryPed) then

		local counter = math.random(50,200)
		while counter > 0 do
			local crds = GetEntityCoords(deliveryPed)
			counter = counter - 1
			Citizen.Wait(1)
		end
	
		if success then
			local counter = math.random(100,300)
			while counter > 0 do
				local crds = GetEntityCoords(deliveryPed)
				counter = counter - 1
				Citizen.Wait(1)
			end
			giveAnim()
		end
	
		local crds = GetEntityCoords(deliveryPed)
		local crds2 = GetEntityCoords(PlayerPedId())
	
		if #(crds - crds2) > 3.0 or not DoesEntityExist(deliveryPed) or IsEntityDead(deliveryPed) then
			success = false
		end
		
		DeleteBlip()
		if success then

			if OxyChance <= Config.OxyChance then
				TriggerServerEvent("ndrp_oxy:receiveoxy")
			elseif OxyChance <= Config.BigRewarditemChance then
				TriggerServerEvent("ndrp_oxy:receiveBigRewarditem")
			else
				TriggerServerEvent("ndrp_oxy:receivemoneyyy")
			end

			Citizen.Wait(2000)
			exports['mythic_notify']:SendAlert('inform', 'The delivery was on point, Next location will be updated soon')
		else
			exports['mythic_notify']:SendAlert('inform', 'The drop off failed')
		end
	
		DeleteCreatedPed()
	end
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent("ndrp_oxy:client")
AddEventHandler("ndrp_oxy:client", function()
	print("triggered")
	if tasking then
		return
	end
	
	rnd = math.random(1,#OxyDropOffs)

	CreateBlip()

	
	local pedCreated = false

	tasking = true
	local toolong = 600000
	while tasking do

		Citizen.Wait(1)
		local plycoords = GetEntityCoords(PlayerPedId())
		local dstcheck = #(plycoords - vector3(OxyDropOffs[rnd]["x"],OxyDropOffs[rnd]["y"],OxyDropOffs[rnd]["z"])) 
		local oxyVehCoords = GetEntityCoords(oxyVehicle)
		local dstcheck2 = #(plycoords - oxyVehCoords) 

		local veh = GetVehiclePedIsIn(PlayerPedId(),false)
		if dstcheck < 40.0 and not pedCreated and (oxyVehicle == veh or dstcheck2 < 15.0) then
			pedCreated = true
			DeleteCreatedPed()
			CreateOxyPed()
			exports['mythic_notify']:SendAlert('inform', 'You are close to the drop off')
		end
		toolong = toolong - 1
		if toolong < 0 then

		    SetVehicleHasBeenOwnedByPlayer(oxyVehicle,false)
			SetEntityAsNoLongerNeeded(oxyVehicle)
			tasking = false
			OxyRun = false
			exports['mythic_notify']:SendAlert('inform', 'You are no longer selling Oxy due to taking too long to drop off')
		end
		if dstcheck < 2.0 and pedCreated then

			local crds = GetEntityCoords(deliveryPed)
			DrawText3Ds(crds["x"],crds["y"],crds["z"], "[E]")  

			if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0,38) then
				TaskTurnPedToFaceEntity(deliveryPed, PlayerPedId(), 1.0)
				Citizen.Wait(1500)
				PlayAmbientSpeech1(deliveryPed, "Generic_Hi", "Speech_Params_Force")
				DoDropOff()
				tasking = false
			end

		end

	end
	

	DeleteCreatedPed()
	DeleteBlip()

end)

Citizen.CreateThread(function()
    while true do
	    Citizen.Wait(1)
	    local dropOff6 = #(GetEntityCoords(PlayerPedId()) - vector3(pillWorker["x"],pillWorker["y"],pillWorker["z"]))
		if dropOff6 < 1.6 and not OxyRun then
			DrawText3Ds(pillWorker["x"],pillWorker["y"],pillWorker["z"], "[E] $1500 - Delivery Job (Payment Cash + Oxy)") 
			if IsControlJustReleased(0,38) then
				print("pressed")
				TriggerServerEvent("ndrp_oxy:server")
				Citizen.Wait(1000)
			end
		end
    end
end)

local firstdeal = false
Citizen.CreateThread(function()
	while true do
		if drugdealer then
			Citizen.Wait(1000)
			if firstdeal then
	        	Citizen.Wait(10000)
	        end

	        TriggerEvent("drugdelivery:client")  

		    salecount = salecount + 1
		    if salecount == 12 then
		    	Citizen.Wait(600000)
		    	drugdealer = false
		    end

		    Citizen.Wait(150000)
		    firstdeal = false

		elseif OxyRun then
			if not DoesEntityExist(oxyVehicle) or GetVehicleEngineHealth(oxyVehicle) < 200.0 or GetVehicleBodyHealth(oxyVehicle) < 200.0 then
				OxyRun = false
				tasking = false
				exports['mythic_notify']:SendAlert('inform', 'The dealer isn\'t giving you anymore locations due to the state of his car')
			else
				if tasking then
			        Citizen.Wait(30000)
			    else
			        TriggerEvent("ndrp_oxy:client")  
				    salecount = salecount + 1
				    if salecount == Config.RunAmount then
				    	Citizen.Wait(300000)
				    	OxyRun = false
				    end
				end
			end
	    else
	    	local close = false
	    	for i = 1, #drugLocs do
				local plycoords = GetEntityCoords(PlayerPedId())
				local dstcheck = #(plycoords - vector3(drugLocs[i]["x"],drugLocs[i]["y"],drugLocs[i]["z"])) 

				if dstcheck < 5.0 then
					close = true
					local job = exports["isPed"]:isPed("job")
					if job ~= "police" then
						local price = 100
			    		DrawText3Ds(drugLocs[i]["x"],drugLocs[i]["y"],drugLocs[i]["z"], "[E] $" .. price .. " offer to sell stolen goods (12).") 
				    	if IsControlJustReleased(0,38) then
				    		local countpolice = exports["isPed"]:isPed("countpolice")
				    		local daytime = exports["isPed"]:isPed("daytime")
							if not daytime then
								exports['mythic_notify']:SendAlert('inform', 'Its too late - noones buying shit!')
		            		else
		            			mygang = drugLocs[i]["gang"]
					    		TriggerServerEvent("drugdelivery:server",price,"robbery",50)
					    		Citizen.Wait(1500)
					    	end
				    	end
			    	else
			    		Citizen.Wait(60000)
			    	end
			    	Citizen.Wait(1)
			    end
			end
			if not close then
				Citizen.Wait(2000)
			end
	    end
    end
end)

RegisterNetEvent("ndrp_oxy:startDealing")
AddEventHandler("ndrp_oxy:startDealing", function()
    local NearNPC = GetClosestPed()
	PlayAmbientSpeech1(NearNPC, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
	salecount = 0
	OxyRun = true
	firstdeal = true
	exports['mythic_notify']:SendAlert('inform', 'Sit in the car and wait for delivery location')
	CreateOxyVehicle()
end)