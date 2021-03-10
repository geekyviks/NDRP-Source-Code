local propertyData, propertyName

RegisterNetEvent("esx_inventoryhud:openDiscPropertyInventory")
AddEventHandler("esx_inventoryhud:openDiscPropertyInventory", function(data)
	propertyName = data.inventory_name
	setDiscPropertyInventoryData(data)
	openDiscPropertyInventory()
	TriggerScreenblurFadeIn(0)
	if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_player', 3) then
		ESX.Streaming.RequestAnimDict('mini@repair', function()
			TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
		end)
    end
end)

RegisterNetEvent("esx_inventoryhud:refreshDiscPropertyInventory")
AddEventHandler("esx_inventoryhud:refreshDiscPropertyInventory", function()
    refreshDiscPropertyInventory()
    Citizen.Wait(200)
    loadPlayerInventory()
end)

function refreshDiscPropertyInventory()
    ESX.TriggerServerCallback("disc-property:getPropertyInventoryFor", function(data)
		setDiscPropertyInventoryData(data)
    end, propertyName
    )
end

function setDiscPropertyInventoryData(data)
    propertyData = data
    items = {}

    local accounts = data.item_account or {}
    local moneys = data.item_money or {}
    local propertyItems = data.item_standard or {}

    for i = 1, #accounts, 1 do
        local account = accounts[i]
        accountData = {
            label = _U(account.name),
            count = account.count,
            type = "item_account",
            name = account.name,
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #moneys, 1 do
        local money = moneys[i]
        accountData = {
            label = _U(money.name),
            count = money.count,
            type = "item_money",
            name = money.name,
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.label = item.name
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

function openDiscPropertyInventory()
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage({action = "display", type = "disc-property"})
    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoDiscProperty", function(data, cb)
	if type(data.number) == "number" and math.floor(data.number) == data.number then
		local count = tonumber(data.number)
		TriggerServerEvent("disc-property:putItemInPropertyFor", propertyName, data.item, count)
	end
	cb("ok")
end)

RegisterNUICallback("TakeFromDiscProperty", function(data, cb)
	if type(data.number) == "number" and math.floor(data.number) == data.number then
		local count = tonumber(data.number)
		TriggerServerEvent("disc-property:takeItemFromProperty", propertyName, data.item, count)
	end
	cb("ok")
end)
