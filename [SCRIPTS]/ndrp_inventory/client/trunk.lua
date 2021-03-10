local PlayerData, vehiclePlate = {}, {}
local lastVehicle, entityWorld, globalplate
local lastOpen, CloseToVehicle = false, false
local arrayWeight = Config.localWeight
local lastChecked = 0

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
    lastChecked = GetGameTimer()
end)

AddEventHandler("onResourceStart", function()
    PlayerData = xPlayer
    lastChecked = GetGameTimer()
end)

function getItemyWeight(item)
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

function OpenCoffreInventoryMenu(plate, max, myVeh)
	ESX.TriggerServerCallback("esx_trunk:getInventoryV",function(inventory)
		text = _U("trunk_info", plate, (inventory.weight / 1000), (max / 1000))
		data = {plate = plate, max = max, myVeh = myVeh, text = text}
		TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory.items)
    end, plate)
end

function openmenuvehicle()
  	local playerPed = GetPlayerPed(-1)
	if not IsPedInAnyVehicle(playerPed) then
		local vehicle = ESX.Game.GetVehicleInDirection()
		local coords = GetEntityCoords(playerPed)
    	local locked = GetVehicleDoorLockStatus(vehicle)
    	local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    	local boot = GetEntityBoneIndexByName(vehicle, 'platelight')
    	if model == 'TROPHYTRUCK' then
      		boot = GetEntityBoneIndexByName(vehicle, 'bonnet')      
    	end
		local bootCoords = GetWorldPositionOfEntityBone(vehicle, boot)
    	local distance = GetDistanceBetweenCoords(bootCoords, coords, true)
		if distance < 2 then
			if vehicle > 0 and vehicle ~= nil and GetPedInVehicleSeat(vehicle, -1) ~= GetPlayerPed(-1) then
				lastVehicle = vehicle
				local class = GetVehicleClass(vehicle)
				ESX.UI.Menu.CloseAll()
				if ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "inventory") then
				else
					if locked == 1 or class == 15 or class == 16 or class == 14 then
						ESX.UI.Menu.CloseAll()
						OpenCoffreInventoryMenu(GetVehicleNumberPlateText(vehicle), Config.VehicleLimit[class], false)
					end
				end
			end
		end
	end
end

local count = 0

function all_trim(s)
	if s then
		return s:match "^%s*(.*)":match "(.-)%s*$"
	else
		return "noTagProvided"
	end
end

function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
  end
end