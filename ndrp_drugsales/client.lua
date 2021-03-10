ESX = nil

local hasDrugs = false
local pressed = false
local selling = false
local notification = true

cachedPeds = {}

--Clean ped cache to avoid memory leaks

Citizen.CreateThread(function()
    while true do
        cachedPeds = {}
        Citizen.Wait(300000)
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

function canSell(pedId)
    return not IsPedSittingInAnyVehicle(pedId)
end

function CanSellTo(pedId)
    return DoesEntityExist(pedId) and IsPedHuman(pedId) and not IsPedDeadOrDying(pedId) and not IsPedAPlayer(pedId) and not IsPedFalling(pedId) and not cachedPeds[pedId] and not IsEntityAMissionEntity(ped)
end

function GetPedInFront()
    local player = PlayerId()
    local plyPed = GetPlayerPed(player)
    local plyPos = GetEntityCoords(plyPed, false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
    local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
    return ped
end

Citizen.CreateThread(function()
    local delay = 100
	while true do
		Citizen.Wait(delay)
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local dc = GetDistanceBetweenCoords(pedCoords, 71.76, -1702.77 ,29.03, true)

		if dc <= 600 then
			delay = 100
			local closestPed = GetPedInFront()
			if closestPed ~= 0 then
				local closestpedCoords = GetEntityCoords(closestPed)
				local dist = GetDistanceBetweenCoords(pedCoords,  closestpedCoords.x, closestpedCoords.y, closestpedCoords.z, true)
				if dist <= 3 and not selling then
				
					local cs = canSell(PlayerPedId())
					local cst = CanSellTo(closestPed)
					
					if cs and cst then
						delay = 0
						if notification then
							ESX.ShowHelpNotification("~INPUT_CONTEXT~ to Sell Drugs", true, true, 2000)
							notification = false
						end
						if IsControlJustReleased(0, 38) and not pressed then
							if not cachedPeds[closestPed] then
								notification = true
								pressed = true
								cachedPeds[closestPed] = true
								Citizen.Wait(10)
								ESX.TriggerServerCallback('ndrp_drugsales:hasDrugs', function(hD)
									if hD then hasDrugs = true else hasDrugs = false end
								end)			
								Citizen.Wait(20)
								if hasDrugs then TryToSell(closestPed, pedCoords) else
									exports['mythic_notify']:SendAlert('error', "Do you really have anything to sell?")
									Citizen.Wait(3000)
									pressed = false
								end 
							else
								exports['mythic_notify']:SendAlert('error', "Stop bothering me you moron!")
							end
						end
					end
				end
			end
		end
	end
end)

TryToSell = function(pedId, coords)
	
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("ndrp_drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end

    selling = true
	hasDrugs = false
	cachedPeds[pedId] = true
    ClearPedTasksImmediately(pedId)
    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    streetName = GetStreetNameFromHashKey(streetName)
    
    FreezeEntityPosition(PlayerPedId(), true)
	Citizen.Wait(50)
	TaskTurnPedToFaceEntity(pedId, PlayerPedId(), 8000)
	Citizen.Wait(100)
    PlayAnimNegotiate(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
	PlayAnimThinking(pedId, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss')
    
	Citizen.SetTimeout(8000, function()
        ClearPedTasks(PlayerPedId())
		ClearPedTasks(pedId)
        FreezeEntityPosition(PlayerPedId(), false)
        if canSell > Config.NotifyCopsPercentage then
            PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
            PlayAnim(pedId, 'mp_common', 'givetake1_a')
            Sell()
        else
            serverId = GetPlayerServerId(PlayerId())
            TriggerServerEvent('ndrp_outlawalert:custom', playerCoords, "someone", " ", "fas fa-cannabis", "10-31", "Drug sale in progress!", streetName, 496)
            exports['mythic_notify']:SendAlert('inform', 'I\'m calling the cops', 2500, { ['background-color'] = '#ff0000', ['color'] = '#fff' })
        end
		selling = false
		pressed = false
    end)
end

Sell = function()
    ESX.TriggerServerCallback("ndrp_drugsales:sellDrug", function(soldDrug)
        if soldDrug then
            exports['mythic_notify']:SendAlert('success', "Thanks! Here's $" .. soldDrug)
        else
            exports['mythic_notify']:SendAlert('error', "Well don't try to waste my time if you don't even have something to sell?")
        end
    end)
end

function PlayAnim(ped, lib, anim, r)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(ped, lib, anim, 8.0, -8, -1, r and 49 or 0, 0, 0, 0, 0)
    end)
end

function PlayAnimThinking(ped, lib, anim, r)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(ped, lib, anim, 8.0, 8.0, -1, 33, 0, 0, 0, 0)
    end)
end


function PlayAnimNegotiate(ped, lib, anim, r)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(ped, lib, anim, 8.0, 8.0, -1, 33, 0, 0, 0, 0)
    end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if not notification then
			notification = true
		end
	end
end)