local arrayWeight = Config.localWeight
local VehicleList, VehicleInventory = {}, {}
local DataStoresIndex, DataStores, SharedDataStores = {}, {}, {}
Items = {}

function getItemWeight(item)
  local weight = 0
  local itemWeight = 0
  if item ~= nil then
    itemWeight = Config.DefaultWeight
    if arrayWeight[item] ~= nil then
      itemWeight = arrayWeight[item]
    end
  end
  return itemWeight
end

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

function getTotalInventoryWeight(plate)
  local total
  TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
      local W_coffre = getInventoryWeight(store.get("coffre") or {})
      total = W_coffre
    end)
  return total
end

ESX.RegisterServerCallback("esx_trunk:getInventoryV", function(source, cb, plate)
  TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
    local items = {}
    local coffre = (store.get("coffre") or {})
    for i = 1, #coffre, 1 do
      table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
    end
    local weight = getTotalInventoryWeight(plate)
    cb({items = items, weight = weight})
  end)
end)

RegisterServerEvent("esx_trunk:getItem")
AddEventHandler("esx_trunk:getItem", function(plate, type, item, count, max, owned)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  if type == "item_standard" then
    local targetItem = xPlayer.getInventoryItem(item)
    if targetItem.limit == -1 or xPlayer.canCarryItem then
      TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
        local coffre = (store.get("coffre") or {})
        for i = 1, #coffre, 1 do
          if coffre[i].name == item then
            if (coffre[i].count >= count and count > 0) then
              xPlayer.addInventoryItem(item, count)
              if (coffre[i].count - count) == 0 then
                table.remove(coffre, i)
              else
                coffre[i].count = coffre[i].count - count
              end
              break
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U("invalid_quantity") } )
            end
          end
        end
        store.set("coffre", coffre)
        local items = {}
        local coffre = (store.get("coffre") or {})
        for i = 1, #coffre, 1 do
          table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
        end
        local weight = getTotalInventoryWeight(plate)
        text = _U("trunk_info", plate, (weight / 1000), (max / 1000))
        data = {plate = plate, max = max, myVeh = owned, text = text}
        TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, items)
      end)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U("player_inv_no_space") } )
    end
  end
end)

RegisterServerEvent("esx_trunk:putItem")
AddEventHandler("esx_trunk:putItem", function(plate, type, item, count, max, owned, label)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)
  if type == "item_standard" then
    local playerItemCount = xPlayer.getInventoryItem(item).count
    if (playerItemCount >= count and count > 0) then
      TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
        local found = false
        local coffre = (store.get("coffre") or {})
        for i = 1, #coffre, 1 do
          if coffre[i].name == item then
            coffre[i].count = coffre[i].count + count
            found = true
          end
        end
        if not found then
          table.insert(
            coffre,
            {
              name = item,
              count = count
            })
        end
        if (getTotalInventoryWeight(plate) + (getItemWeight(item) * count)) > max then
          TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U("insufficient_space") } )
        else
          xPlayer.removeInventoryItem(item, count)
	        store.set("coffre", coffre)
          MySQL.Async.execute("UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate", {
            ["@plate"] = plate,
            ["@owned"] = owned
          })
        end
      end)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U("invalid_quantity") } )
    end
  end

  TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
    local items = {}
    local coffre = (store.get("coffre") or {})
    for i = 1, #coffre, 1 do
      table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
    end
    local weight = getTotalInventoryWeight(plate)
    text = _U("trunk_info", plate, (weight / 1000), (max / 1000))
    data = {plate = plate, max = max, myVeh = owned, text = text}
    TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, items)
  end)

end)

ESX.RegisterServerCallback("esx_trunk:getPlayerInventory", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory
    cb({items = items})
end)

function all_trim(s)
  if s then
    return s:match "^%s*(.*)":match "(.-)%s*$"
  else
    return "noTagProvided"
  end
end

function loadInvent(plate)
  local result =
    MySQL.Sync.fetchAll("SELECT * FROM trunk_inventory WHERE plate = @plate", {
      ["@plate"] = plate
    })
  local data = nil
  if #result ~= 0 then
    for i = 1, #result, 1 do
      local plate = result[i].plate
      local owned = result[i].owned
      local data = (result[i].data == nil and {} or json.decode(result[i].data))
      local dataStore = CreateDataStore(plate, owned, data)
      SharedDataStores[plate] = dataStore
    end
  end
end

function MakeDataStore(plate)
  local data = {}
  local owned = 1
  local dataStore = CreateDataStore(plate, owned, data)
  SharedDataStores[plate] = dataStore
  MySQL.Async.execute("INSERT INTO trunk_inventory(plate,data,owned) VALUES (@plate,'{}',@owned)", {
      ["@plate"] = plate,
      ["@owned"] = owned
  })
  loadInvent(plate)
end

function GetSharedDataStore(plate)
  if SharedDataStores[plate] == nil then
    MakeDataStore(plate)
  end
  return SharedDataStores[plate]
end

AddEventHandler("esx_trunk:getSharedDataStore", function(plate, cb)
    cb(GetSharedDataStore(plate))
end)