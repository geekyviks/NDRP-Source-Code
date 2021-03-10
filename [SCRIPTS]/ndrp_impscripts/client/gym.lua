workoutAreas = {
  [1] = { ["x"] = -1200.5871582031,["y"] = -1577.504516601,["z"] = 4.6084971427918, ["h"] = 312.37738037109, ["workType"] = "Pushups", ["emote"] = "pushup" },
  [2] = { ["x"] = -1253.05,["y"] = -1561.55,["z"] = 4.4, ["h"] = 308.9084777832, ["workType"] = "Situps", ["emote"] = "situp" },
  [3] = { ["x"] = -1215.0224609375,["y"] = -1541.6857910156,["z"] = 4.7281851768494, ["h"] = 119.79830169678, ["workType"] = "Yoga", ["emote"] = "Yoga" },
  [4] = { ["x"] = -1217.5916748047,["y"] = -1543.162109375,["z"] = 4.7207465171814, ["h"] = 119.81834411621, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [5] = { ["x"] = -1220.8453369141,["y"] = -1545.0277099609,["z"] = 4.6919565200806, ["h"] = 119.8260345459, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [6] = { ["x"] = -1224.6988525391,["y"] = -1547.2470703125,["z"] = 4.6254777908325, ["h"] = 119.86821746826, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [7] = { ["x"] = -1228.4945068359,["y"] = -1549.4294433594,["z"] = 4.5562300682068, ["h"] = 119.87698364258, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [8] =  { ['x'] = -1253.41,['y'] = -1601.65,['z'] = 3.15,['h'] = 213.34, ['info'] = ' Chinups 1', ["workType"] = "Chinups", ["emote"] = "chinup" },
  [9] =  { ['x'] = -1252.43,['y'] = -1603.14,['z'] = 3.13,['h'] = 213.78, ['info'] = ' Chinups 2', ["workType"] = "Chinups", ["emote"] = "chinup" },
  [10] =  { ['x'] = -1251.26,['y'] = -1604.81,['z'] = 3.14,['h'] = 217.94, ['info'] = ' Chinups 3', ["workType"] = "Chinups", ["emote"] = "chinup" },

}

function DrawText3DTest(x,y,z, text)
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

local inprocess = false
local returnedPass = false
local workoutType = 0

Citizen.CreateThread(function()
    while true do
      local playerped = GetPlayerPed(-1)
      local plyCoords = GetEntityCoords(playerped)        
      local waitCheck2 = GetDistanceBetweenCoords( GetEntityCoords( GetPlayerPed(-1) ), -1253.41,-1601.65,4.556230068206)
      local waitCheck = GetDistanceBetweenCoords( GetEntityCoords( GetPlayerPed(-1) ), -1228.4945068359,-1549.4294433594,4.556230068206)
      if (waitCheck > 40.0 and waitCheck2 > 40.0 ) or inprocess then
        Citizen.Wait(math.ceil(waitCheck))
      else
        Citizen.Wait(1)
        for i = 1, #workoutAreas do
          local distCheck = GetDistanceBetweenCoords( GetEntityCoords( GetPlayerPed(-1) ), workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"])
          if distCheck < 4.0 then
            DrawText3DTest(workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"], "[E] to do " .. workoutAreas[i]["workType"] .. "" )
          end
          if distCheck < 1.0 then
            if (IsControlJustReleased(1, 38)) then
              returnedPass = false
              workoutType = i
              TriggerEvent("doworkout")
            end
          end
        end
      end
    end
end)

RegisterNetEvent('doworkout')
AddEventHandler('doworkout', function()
    inprocess = true
    SetEntityCoords(GetPlayerPed(-1),workoutAreas[workoutType]["x"],workoutAreas[workoutType]["y"],workoutAreas[workoutType]["z"])
    SetEntityHeading(GetPlayerPed(-1),workoutAreas[workoutType]["h"])
    TriggerEvent("ndrp_emotes:playthisemote",workoutAreas[workoutType]["emote"])
    Citizen.Wait(30000)
    TriggerEvent('esx_status:remove', 'stress', 30000)
    TriggerEvent("ndrp_emotes:playthisemote","c")
    exports['mythic_notify']:SendAlert('inform', 'Stress Relieved')
    inprocess = false
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if inprocess then
      DisableAllControlActions(1)
      EnableControlAction(1,0)
      EnableControlAction(1,1)
      EnableControlAction(1,2)
      EnableControlAction(1,3)
      EnableControlAction(1,4)
      EnableControlAction(1,5)
    end
  end
end)

 --  Yoga Blip
	
 Citizen.CreateThread(function()
	Citizen.Wait(15000)
  local blip = AddBlipForCoord(-1215.0224609375,-1541.6857910156,4.7281851768494)
  SetBlipSprite (blip, 197) -- $ Sign
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.7)
  SetBlipColour	(blip, 37)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Gym and Yoga")
  EndTextCommandSetBlipName(blip)
end)