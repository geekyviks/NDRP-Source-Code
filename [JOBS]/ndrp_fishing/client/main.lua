ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	end
end)

Citizen.CreateThread(function()
	while true do
		local location = nil
		local sleepThread = 1000
		if not fishing then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			for k,v in pairs(Config.Locations) do
				local distance = GetDistanceBetweenCoords(coords, v['x'], v['y'], v['z'], true)
				if distance < 15.0 then
					sleepThread = 5
					DrawMarker(25, v['x'], v['y'], v['z'] - 1, 0, 0, 0, 0, 0, 0.0, 0.6, 0.6, 0.01, 255, 255, 255, 0.5, 0, 0, 0,0) 
					if distance < 1.0 then
						if v['position'] == 'sell' then
							DrawText3D(v['x'], v['y'], v['z'], 'Press [E] to speak with the buyer')
							if IsControlJustReleased(0, 38) then
								OpenSellMenu()
							end	
						else
							DrawText3D(v['x'], v['y'], v['z'], 'Press [E] to fish')
							if IsControlJustReleased(0, 38) then
								ESX.TriggerServerCallback('fivem_fishing:checkIfPlayerCanFish', function(state)
									if state == true then
										StartFishing(k, v)
									else 
										ESX.ShowNotification("You need a fishingrod and some bait")
									end
								end)
								Citizen.Wait(10)
							end	
						end	
					end
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

StartFishing = function(location, data)
	local fishes = {}
	local randomWait = math.random(800, 4000) 
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local count = 1
	local catchPeriod = 1000
	local failure = 500
	local msg = ''
	fishing = true
	for k,v in pairs(data['fishes']) do
		Citizen.Wait(5)
		table.insert(fishes, Config.Fishes[v])
	end
	SetEntityHeading(playerPed, data['h'])
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_FISHING", 0, true)
	while fishing do
		x = 0.95
		if randomWait > 0 then
			count = count + 1
			if count >= 100 then 
				count = 1
				msg = 'Wait'..''
			elseif count >= 75 then 
				msg = 'Wait'..'...'
			elseif count >= 50 then
				msg = 'Wait'..'..'
			elseif count >= 25 then
				msg = 'Wait'..'.'
			end
			randomWait = randomWait - 1
		elseif catchPeriod > 0 and randomWait <= 0 then
			catchPeriod = catchPeriod - 1
			x = 0.85
			msg = 'Press [ENTER] to catch the fish'
			DrawTxt(0.9, 0.75, 1.0, 1.0, 0.5, 'The rod is twitching', 0, 151, 226, 255)
		elseif failure > 0 then
			x = 0.9
			failure = failure - 1
			if failure == 1 then
				local breakChance = math.random(1, 100)
				if breakChance == 1 then
					x = 0.825
					msg = 'The fish got away and snapped your fishingrod..'
					TriggerServerEvent('strandatt_fishing:breakFishingRod')
				else
					msg = 'The fish got away..'
				end
			else
				msg = 'The fish got away..'
			end
		else
			ClearPedTasks(playerPed)
			fishing = false
			local FishingRod = GetClosestObjectOfType(coords.x, coords.y, coords.z, 15.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
			if FishingRod ~= 0 then
				SetEntityAsMissionEntity(FishingRod, false, true)
				DeleteObject(FishingRod)
			end
		end
		if IsControlJustReleased(0, 18) then
			ClearPedTasks(playerPed)
			local FishingRod = GetClosestObjectOfType(coords.x, coords.y, coords.z, 15.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
			if FishingRod ~= 0 then
				SetEntityAsMissionEntity(FishingRod, false, true)
				DeleteObject(FishingRod)
			end
			fishing = false
			if randomWait <= 0 and catchPeriod > 0 then 
				GetFishProbability(fishes)
			end
		elseif IsControlJustReleased(0, 73) then 
			ClearPedTasks(playerPed)
			local FishingRod = GetClosestObjectOfType(coords.x, coords.y, coords.z, 15.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
			if FishingRod ~= 0 then
				SetEntityAsMissionEntity(FishingRod, false, true)
				DeleteObject(FishingRod)
			end
			fishing = false
		end	
		DrawTxt(x, 0.8, 1.0, 1.0, 0.5, msg, 0, 151, 226, 255)
		Citizen.Wait(5)
	end
end

DrawTxt = function(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

OpenSellMenu = function()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{['label'] = 'Sell fish', ['value'] = 'sell_fish'}
	}
	if Config.EnableMeatSell then
		table.insert(elements, {['label'] = 'Sell meat', ['value'] = 'sell_meat'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'invite_player',
	{
		title    = 'What would you like to sell',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'sell_fish'  then
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('strandatt_fishing:sellFish')
		elseif data.current.value == 'sell_meat' then
			ESX.UI.Menu.CloseAll()
			TriggerEvent('fivem_hunting:openHuntingSellMenu')
		end
	end, function(data, menu)
		menu.close()
	end)
end

GetFishProbability = function(fishes)
	local defaultFish = Config.Fishes['mackerel']
	local rNbr = math.random()
	local baseVal = 0
	local turn = 0
	for name, fish in pairs(fishes) do
		turn = turn + 1
		baseVal = baseVal + fish['value']
		if rNbr <= baseVal then
			local weight = math.random(fish['weight'][1], fish['weight'][2])
			ESX.ShowNotification('You caught a ' .. fish['label']..' at '..weight..' gram')
			TriggerServerEvent('fivem_fishing:caughtFish', fish, weight)
			break
		elseif turn == 6 then
			local weight = math.random(defaultFish['weight'][1],defaultFish['weight'][2])
			ESX.ShowNotification('You caught a ' .. defaultFish['label']..' at '..weight..' gram')
			TriggerServerEvent('fivem_fishing:caughtFish', defaultFish, weight)
        end
	end
end

DrawText3D = function(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 320
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end