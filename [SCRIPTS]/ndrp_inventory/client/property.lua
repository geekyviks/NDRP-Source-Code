RegisterNetEvent("esx_inventoryhud:openPropertyInventory")
AddEventHandler("esx_inventoryhud:openPropertyInventory", function(data)
	TriggerScreenblurFadeIn(0)
	setPropertyInventoryData(data)
	openPropertyInventory()
	if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_player', 3) then
		ESX.Streaming.RequestAnimDict('mini@repair', function()
		TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
		end)
	end
end)

function refreshPropertyInventory()
    ESX.TriggerServerCallback("esx_property:getPropertyInventory", function(inventory)
		setPropertyInventoryData(inventory)
        end, ESX.GetPlayerData().identifier
    )
end

function setPropertyInventoryData(data)
    items = {}
    local propertyItems = data.items
   
    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    SendNUIMessage({action = "setSecondInventoryItems", itemList = items})
end

function openPropertyInventory()
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage({action = "display", type = "property"})
    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoProperty", function(data, cb)
	if IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	if type(data.number) == "number" and math.floor(data.number) == data.number then
		local count = tonumber(data.number)
		TriggerServerEvent("esx_property:putItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count)
    end

    Wait(250)
    refreshPropertyInventory()
    Wait(250)
    loadPlayerInventory()
    cb("ok")
end)

RegisterNUICallback("TakeFromProperty", function(data, cb)
	if IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	if type(data.number) == "number" and math.floor(data.number) == data.number then
		TriggerServerEvent("esx_property:getItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number))
	end

    Wait(250)
    refreshPropertyInventory()
    Wait(250)
    loadPlayerInventory()
    cb("ok")
end)