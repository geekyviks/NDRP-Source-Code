local trunkData
local isInInventory = false
ESX = nil
local fastWeapons = {
	[1] = nil,
	[2] = nil,
	[3] = nil
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) then
            Citizen.Wait(50)
            openInventory()
        end
    end
end)

RegisterCommand('trunk', function(source, args)
    openmenuvehicle()
end, false)

function openInventory()
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage({action = "display", type = "normal"})
    SetNuiFocus(true, true)
end

function openTrunkInventory()
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage({action = "display", type = "trunk"})
    SetNuiFocus(true, true)
end

function closeInventory()
    isInInventory = false
    SendNUIMessage({action = "hide"})
    SetNuiFocus(false, false)
    ClearPedSecondaryTask(GetPlayerPed(-1))
end

RegisterNUICallback("NUIFocusOff", function()
	closeInventory()
	Citizen.Wait(50)
end)

RegisterNUICallback("GetNearPlayers", function(data, cb)
	local playerPed = PlayerPedId()
	local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
	local foundPlayers = false
	local elements = {}

	for i = 1, #players, 1 do
		if players[i] ~= PlayerId() then
			foundPlayers = true
			table.insert(
				elements,
                {
                    label = GetPlayerName(players[i]),
                    player = GetPlayerServerId(players[i])
                }
            )
        end
    end

	if not foundPlayers then
        exports['mythic_notify']:SendAlert('error', _U("players_nearby"))
    else
        SendNUIMessage(
            {
                action = "nearPlayers",
                foundAny = foundPlayers,
                players = elements,
                item = data.item
            }
        )
    end
    cb("ok")
end)

RegisterNUICallback("PutIntoTrunk", function(data, cb)
	if IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	if type(data.number) == "number" and math.floor(data.number) == data.number then
		local count = tonumber(data.number)
		TriggerServerEvent("esx_trunk:putItem", trunkData.plate, data.item.type, data.item.name, count, trunkData.max, trunkData.myVeh, data.item.label)
    end
    
    Wait(500)
    if string.starts(data.item.name, "WEAPON_") then
        RemoveAllPedWeapons(GetPlayerPed(-1),true)
    end
    loadPlayerInventory()
    cb("ok")
end)

RegisterNUICallback("TakeFromTrunk", function(data, cb)
	if IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	if type(data.number) == "number" and math.floor(data.number) == data.number then
		TriggerServerEvent("esx_trunk:getItem", trunkData.plate, data.item.type, data.item.name, tonumber(data.number), trunkData.max, trunkData.myVeh)
	end

    Wait(500)
    loadPlayerInventory()
    cb("ok")
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("esx:useItem", data.item.name)

    if shouldCloseInventory(data.item.name) then
        closeInventory()
    else
        Citizen.Wait(250)
        loadPlayerInventory()
    end
    cb("ok")

end)

RegisterNUICallback("DropItem", function(data, cb)
	if IsPedSittingInAnyVehicle(playerPed) then
		return
	end
	if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number)
    end
   
    Wait(500)
    if string.starts(data.item.name, "WEAPON_") then
        RemoveAllPedWeapons(GetPlayerPed(-1),true)
    end
    loadPlayerInventory()
    cb("ok")
end)

RegisterNUICallback("GiveItem", function(data, cb)
    
    local playerPed = PlayerPedId()
	local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
	local foundPlayer = false
	for i = 1, #players, 1 do
		if players[i] ~= PlayerId() then
			if GetPlayerServerId(players[i]) == data.player then
				foundPlayer = true
            end
        end
    end

	if foundPlayer then
		local count = tonumber(data.number)
        TriggerServerEvent("esx:giveInventoryItem", data.player, data.item.type, data.item.name, count)
        Wait(500)
        if string.starts(data.item.name, "WEAPON_") then
            RemoveAllPedWeapons(playerPed,true)
        end
        loadPlayerInventory()
    else
        exports['mythic_notify']:SendAlert('error', _U("player_nearby"))
	end
    cb("ok")

end)

function shouldCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end
    return false
end

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end

    return false
end

--local arrayWeight = Config.localWeight
function getInventoryWeight(inventory)
  local weight = 0
  local itemWeight = 0
  if inventory ~= nil then
    for i = 1, #inventory, 1 do
      if inventory[i] ~= nil then
        itemWeight = Config.DefaultWeight
        if arrayWeight[inventory[i].name] ~= nil then
          itemWeight = arrayWeight[inventory[i].name]
        end
        weight = weight + (itemWeight * (inventory[i].count or 1))
      end
    end
  end
  return weight
end

function loadPlayerInventory()
    ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
        items = {}
        fastItems = {}
        inventory = data.inventory
        accounts = data.accounts
        money = data.money

        if Config.IncludeCash and money ~= nil and money > 0 then
            for key, value in pairs(accounts) do
                moneyData = {
                    label = _U("cash"),
                    name = "cash",
                    type = "item_money",
                    count = money,
                    usable = false,
                    rare = false,
                    limit = -1,
                    canRemove = true
                }
                table.insert(items, moneyData)
            end
        end

        if Config.IncludeAccounts and accounts ~= nil then
            for key, value in pairs(accounts) do
                if not shouldSkipAccount(accounts[key].name) then
                    local canDrop = accounts[key].name ~= "bank"
                    if accounts[key].money > 0 then
                        accountData = {
                            label = accounts[key].label,
                            count = accounts[key].money,
                            type = "item_account",
                            name = accounts[key].name,
                            usable = false,
                            rare = false,
                            limit = -1,
                            canRemove = canDrop
                        }
                        table.insert(items, accountData)
                    end
                end
            end
        end
			
        if inventory ~= nil then
            for key, value in pairs(inventory) do
                if inventory[key].count <= 0 then
                    inventory[key] = nil
                else
                    inventory[key].type = "item_standard"
                    table.insert(items, inventory[key])
                end
            end
        end

			
		local arrayWeight = Config.localWeight
		local weight = 0
		local itemWeight = 0
		local itemsW = 0
		if items ~= nil then
		    for i = 1, #items, 1 do
                if items[i] ~= nil then
                    if string.starts(items[i].name, "WEAPON_") then
                        itemWeight = Config.DefaultWeight
			            itemWeight = itemWeight
			            if arrayWeight[items[i].name] ~= nil then
			                itemWeight = arrayWeight[items[i].name]
			                items[i].limit = itemWeight / 1000
			            end
			            weight = weight + (itemWeight * (1))
                    else
                        itemWeight = Config.DefaultWeight
			            itemWeight = itemWeight / items[1].count * 0.0
			            if arrayWeight[items[i].name] ~= nil then
			                itemWeight = arrayWeight[items[i].name]
			                items[i].limit = itemWeight / 1000
			            end
			            weight = weight + (itemWeight * (items[i].count or 1))
                    end
                end
            end
        end
    
        local texts =  _U("player_info", GetPlayerName(PlayerId()), (weight / 1000), (Config.Limit / 1000))
		texts =  _U("player_info", GetPlayerName(PlayerId()), (weight / 1000), (Config.Limit / 1000))
        SendNUIMessage(
            {
                action = "setItems",
                itemList = items,
                fastItems = fastItems,
				text = texts
            }
        )	
    end, GetPlayerServerId(PlayerId()))
end

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

RegisterNetEvent("esx_inventoryhud:openTrunkInventory")
AddEventHandler("esx_inventoryhud:openTrunkInventory", function(data, inventory)
	setTrunkInventoryData(data, inventory)
	openTrunkInventory()
end)

RegisterNetEvent("esx_inventoryhud:refreshTrunkInventory")
AddEventHandler("esx_inventoryhud:refreshTrunkInventory", function(data, inventory)
	setTrunkInventoryData(data, inventory)
end)

function setTrunkInventoryData(data, inventory)
    trunkData = data
	SendNUIMessage({action = "setInfoText", text = data.text})			
    items = {}

    if inventory ~= nil then
        for key, value in pairs(inventory) do
            if inventory[key].count <= 0 then
                inventory[key] = nil
            else
                inventory[key].type = "item_standard"
                inventory[key].usable = false
                inventory[key].rare = false
                inventory[key].limit = -1
                inventory[key].canRemove = false
                table.insert(items, inventory[key])
            end
        end
    end
    SendNUIMessage({action = "setSecondInventoryItems",itemList = items})
end

function openTrunkInventory()
    loadPlayerInventory()
    isInInventory = true
    local playerPed = GetPlayerPed(-1)
    if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_player', 3) then
        ESX.Streaming.RequestAnimDict('mini@repair', function()
            TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
        end)
    end
    SendNUIMessage({action = "display", type = "trunk"})
    SetNuiFocus(true, true)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isInInventory then
            local playerPed = PlayerPedId()
            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S (fault in Keys table!)
            DisableControlAction(0, 30, true) -- D (fault in Keys table!)
            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'enter'?
            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job
            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(2, 36, true) -- Disable going stealth
            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
    end
end)

-- HIDE WEAPON WHEEL

Citizen.CreateThread(function ()
	Citizen.Wait(2000)
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame(19)
		HideHudComponentThisFrame(20)
		BlockWeaponWheelThisFrame()
		DisableControlAction(0, 37,true)
	end
end)

--FAST ITEMS

RegisterNUICallback("PutIntoFast", function(data, cb)
	if data.item.slot ~= nil then
		fastWeapons[data.item.slot] = nil
	end
	fastWeapons[data.slot] = data.item.name
	TriggerServerEvent("esx_inventoryhud:changeFastItem",data.slot,data.item.name)
	loadPlayerInventory()
	cb("ok")
end)

RegisterNUICallback("TakeFromFast", function(data, cb)
	fastWeapons[data.item.slot] = nil
	TriggerServerEvent("esx_inventoryhud:changeFastItem",0,data.item.name)
	loadPlayerInventory()
	cb("ok")
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if IsDisabledControlJustReleased(1, 157) then
            if fastWeapons[1] ~= nil then
                if string.starts(fastWeapons[1], "WEAPON_") then
                    TriggerServerEvent("esx:useItem", fastWeapons[1])
                end
			end
        end

		if IsDisabledControlJustReleased(1, 158) then
            if fastWeapons[2] ~= nil then
                if string.starts(fastWeapons[2], "WEAPON_") then
                    TriggerServerEvent("esx:useItem", fastWeapons[2])
                end
			end
        end

		if IsDisabledControlJustReleased(1, 160) then
            if fastWeapons[3] ~= nil then
                if string.starts(fastWeapons[3], "WEAPON_") then
                    TriggerServerEvent("esx:useItem", fastWeapons[3])
                end
			end
        end

        if IsDisabledControlJustReleased(1, 164) then
            if fastWeapons[4] ~= nil then
                if string.starts(fastWeapons[4], "WEAPON_") then
                    TriggerServerEvent("esx:useItem", fastWeapons[4])
                end
			end
        end

        if IsDisabledControlJustReleased(1, 166) then
            if fastWeapons[5] ~= nil then
                if string.starts(fastWeapons[5], "WEAPON_") then
                    TriggerServerEvent("esx:useItem", fastWeapons[5])
                end
			end
        end

    end
end) 

--Add Items--

RegisterNetEvent('esx_inventoryhud:client:addItem')
AddEventHandler('esx_inventoryhud:client:addItem', function(itemname, itemlabel)
    local data = { name = itemname, label = itemlabel }
    SendNUIMessage({type = "addInventoryItem", addItemData = data})
end)