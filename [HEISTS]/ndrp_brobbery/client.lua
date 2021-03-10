local MFF = MF_Fleeca
local cooldown = false

function MFF:Start(...)
  while not ESX do Citizen.Wait(0); end
  while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
  self.PlayerData = ESX.GetPlayerData()
  ESX.TriggerServerCallback('MF_Fleeca:GetBankData', function(usedActions,cops) 
    self.PoliceOnline = cops or 0
    self.UsedActions = usedActions    
    if self.dS and self.cS then self:Update(); end
  end)
end

function MFF:Update()
  local tick = 0
  local lastPolCheck = GetGameTimer()
  while self.dS and self.cS do
    local waitTime = 0

    tick = tick + 1
    local plyPed = GetPlayerPed(-1)
    local plyPos = GetEntityCoords(plyPed)
    local closestKey,closestVal,closestDist = self:GetClosestBank(plyPos)
    if closestDist < self.LoadDist then
      if self.PoliceOnline and self.PoliceOnline >= self.MinPoliceOnline then
        if not self.CurBank or self.CurBank.key ~= closestKey then
          self.CurBank = { key = closestKey, val = closestVal }
          ESX.TriggerServerCallback('MF_Fleeca:GetPolCount', function(count) self.PoliceOnline = count; end)
        end

        local actKey,actVal,actDist = self:GetClosestAction(plyPos,closestKey)
        if actDist < self.ActionDist then
          if not self.CurAction or self.CurAction.key ~= actKey then
            if actVal ~= "LootVault" or (actVal == "LootVault" and self.SafeOpen) then
              self.CurAction = { key = actKey, val = actVal }
              self.CurText = "Press [ ~r~E~s~ ] to " .. self.TextAddons[actVal]
            end
          end

          if not self.UsedActions[actKey] and not self.Interacting then
            Utils:DrawText3D(actKey.x, actKey.y, actKey.z, self.CurText)
            if Utils:GetKeyPressed(self.InteractKey) then
              self:Interact(self.CurAction)
            end
          end
        end
      else
        waitTime = 1000
      end
    else
      self.CurBank = false
      self.SafeOpen = false
      waitTime = 1000
    end

    if self.MovedDoors then
      for k,v in pairs(self.MovedDoors) do
        local plyPos = GetEntityCoords(GetPlayerPed(-1))
        local dist = Utils:GetVecDist(plyPos, GetEntityCoords(v))
        if dist > 50.0 then
          DeleteObject(v)
          table.remove(self.MovedDoors, k)
        end
      end
    end

    Citizen.Wait(waitTime)
  end
end

function MFF:GetClosestBank(plyPos)
  local closestKey,closestVal,closestDist
  for k,v in pairs(self.Banks) do
    local dist = Utils:GetVecDist(plyPos, v)
    if not closestDist or dist < closestDist then
      closestKey = k
      closestVal = v
      closestDist = dist
    end
  end
  if not closestDist then return false,false,999999
  else return closestKey,closestVal,closestDist
  end
end

function MFF:GetClosestAction(plyPos,key)
  local closestKey,closestVal,closestDist
  for k,v in pairs(self.Actions[key]) do
    local dist = Utils:GetVecDist(plyPos, k)
    if not closestDist or dist < closestDist then
      closestKey = k
      closestVal = v
      closestDist = dist
    end
  end
  if not closestDist then return false,false,999999
  else return closestKey,closestVal,closestDist
  end
end

function MFF:Interact(closest)
  if self.Interacting then return; end
  self.Interacting = closest
  if closest.val == "LockpickDoor" then
   ESX.TriggerServerCallback('MF_Fleeca:GetLockpickCount', function(count)
      if count then
        ESX.TriggerServerCallback('ndrp_base:isCooldown', function(result)
          if result then
            TriggerEvent('MF_LockPicking:StartMinigame')
            TriggerServerEvent('esx_extraitems:removethisitem','safecracker')
          else
            exports['mythic_notify']:SendAlert('error', 'You need to wait for some time!')
            self.Interacting = false
          end
        end)
      else
        exports['mythic_notify']:SendAlert('error', 'You need a safecracker and Access card')
        self.Interacting = false
      end
    end)
  elseif closest.val == "LootID" then
    self:LootHandler(closest,true)
    TriggerServerEvent('MF_Fleeca:NotifyPolice', closest)
  elseif closest.val == "OpenVault" then
    self:HandleVaultDoor(closest)
  elseif closest.val == "LootVault" then
    ESX.TriggerServerCallback('MF_Fleeca:GetOxyCount', function(count)
      if count and count > 0 then
        self:LootHandler(closest,false)
      else
		exports['mythic_notify']:SendAlert('inform', 'You need a Oxycutter to cut this open.')
        self.Interacting = false
      end
    end)
  end
end

function MFF:LootHandler(closest,idcard)
  ESX.TriggerServerCallback('MF_Fleeca:TryLoot',function(isLooted)
    if not isLooted then
      local plyPed = GetPlayerPed(-1)

      TaskTurnPedToFaceCoord(plyPed, closest.key.x, closest.key.y, closest.key.z, -1)
      FreezeEntityPosition(plyPed,true)
      if idcard then
			 exports['mythic_progbar']:Progress({
					name = "searching",
					duration = self.InteractTimer * 2000,
					label = "Upgrading the access card",
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = true,
						disableCombat = true,
					},
					animation = {
						animDict = "mp_prison_break",
						anim = "hack_loop"
					},
					
				})
        Wait(20000)
        TriggerServerEvent('esx_extraitems:removethisitem','accesscard')
        exports['mythic_notify']:SendAlert('inform', 'Successfully Upgraded Access Card')
      else
			  exports['mythic_progbar']:Progress({
					name = "cutting",
					duration = self.InteractTimer * 1500,
					label = "cutting",
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = true,
						disableCombat = true,
					},
					animation = {
						animDict = "nil",
						anim = "nil",
						task = "WORLD_HUMAN_WELDING"
					},
					
				})
			ClearPedTasksImmediately(plyPed)
			Wait(self.InteractTimer * 1500)
			TriggerServerEvent("MF_Fleeca:removeoxy")
      end
      if idcard then
        TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, false)
        Wait(1500)
      end

      self.UsedActions[closest.key] = true
      TriggerServerEvent('MF_Fleeca:SyncBankData', closest.key)
      TriggerServerEvent('MF_Fleeca:RewardPlayer', closest.key,idcard)

      ClearPedTasksImmediately(plyPed)
      FreezeEntityPosition(plyPed,false)
      self.Interacting = false

      Wait(100)
      local obj = ESX.Game.GetClosestObject({},GetEntityCoords(plyPed))
      if GetEntityModel(obj)% 0x100000000 == 3284676632 then
        SetEntityAsMissionEntity(obj,false)
        DeleteObject(obj)
      end
    else
		exports['mythic_notify']:SendAlert('inform', 'Somebody else is looting this already.')
      self.Interacting = false
    end
  end,closest)
end

function MFF:LockpickComplete(result)
  local plyPed = GetPlayerPed(-1)
  FreezeEntityPosition(plyPed,false)
  if result then
    TriggerServerEvent('ndrp_base:setCoolDown')
    local closest,closestDist
    local allObjs = ESX.Game.GetObjects()
    for k,v in pairs(allObjs) do
      local modelHash = GetEntityModel(v)
      local revHash = modelHash % 0x100000000
      if self.DoorHashes[modelHash] or self.DoorHashes[modelHash] then
        local dist = Utils:GetVecDist(self.Interacting.key,GetEntityCoords(v))
        if not closestDist or dist < closestDist then
          closest = v
          closestDist = dist
        end
      end
    end

    if not closest or closestDist > self.LoadDist then 
      self.Interacting = false
      return 
    end

    local players = ESX.Game.GetPlayersInArea(self.Interacting.key,self.LoadDist)   
    for k,v in pairs(players) do
      local newV = GetPlayerServerId(v)
      TriggerServerEvent('MF_Fleeca:SyncDoor', newV, self.Interacting.key)
    end

    TriggerServerEvent('MF_Fleeca:SyncBankData', self.Interacting.key)
    timer = GetGameTimer()
    Citizen.CreateThread(function()
      while (GetGameTimer() - timer) < 500 do
        Citizen.Wait(0)
        DisableControlAction(0,18,true) -- disable attack
        DisableControlAction(0,24,true) -- disable attack
        DisableControlAction(0,25,true) -- disable aim
        DisableControlAction(0,47,true) -- disable weapon
        DisableControlAction(0,58,true) -- disable weapon
        DisableControlAction(0,69,true) -- disable weapon
        DisableControlAction(0,92,true) -- disable weapon
        DisableControlAction(0,106,true) -- disable weapon
        DisableControlAction(0,122,true) -- disable weapon
        DisableControlAction(0,135,true) -- disable weapon
        DisableControlAction(0,142,true) -- disable weapon
        DisableControlAction(0,144,true) -- disable weapon
        DisableControlAction(0,176,true) -- disable weapon
        DisableControlAction(0,223,true) -- disable melee
        DisableControlAction(0,229,true) -- disable melee
        DisableControlAction(0,237,true) -- disable melee
        DisableControlAction(0,257,true) -- disable melee
        DisableControlAction(0,263,true) -- disable melee
        DisableControlAction(0,264,true) -- disable melee
        DisableControlAction(0,257,true) -- disable melee
        DisableControlAction(0,140,true) -- disable melee
        DisableControlAction(0,141,true) -- disable melee
        DisableControlAction(0,142,true) -- disable melee
        DisableControlAction(0,143,true) -- disable melee
        DisableControlAction(0,329,true) -- disable melee
        DisableControlAction(0,347,true) -- disable melee
      end
    end)
    Citizen.Wait(200)
    self.Interacting = false
  else
    self.Interacting = false
  end
end

function MFF:Awake(...)
    while not ESX do Citizen.Wait(0); end
    while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
    ESX.TriggerServerCallback('MF_Fleeca:GetStartData', function(retVal) self.dS = true; self.cS = retVal; self:Start(); end)
end
local closer 
function MFF:HandleVaultDoor(closest)
  closer = closest
  ESX.TriggerServerCallback('MF_Fleeca:GetIDCount', function(count)
    if count and count > 0 then
      local plyPed = GetPlayerPed(-1)
      TaskTurnPedToFaceCoord(plyPed, closest.key.x, closest.key.y, closest.key.z, -1)
      Wait(100)
  
	    exports['mythic_progbar']:Progress({
					
					name = "Requesting Access",
					duration = self.InteractTimer * 1000,
					label = "Requesting Access",
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "nil",
						anim = "nil",
						task = "PROP_HUMAN_ATM"
					},
					
				})
      Wait(self.InteractTimer * 1000) 
      TriggerEvent("mhacking:show")
      TriggerEvent("mhacking:start",2,35,dummy)
      TriggerServerEvent('MF_Fleeca:NotifyPolice', closest)
    else
		  exports['mythic_notify']:SendAlert('error', 'Unauthorized access not allowed')
      self.Interacting = false
    end
  end)
end

function dummy(success, timeremaining)
  MFF:mycb(success, timeremaining)
end

function dummy2(success, timeremaining)
  MFF:mycb2(success, timeremaining)
end

function dummy3(success, timeremaining)
  MFF:mycb3(success, timeremaining)
end

function MFF:NotifyPolice(data)

  local streetrob, _ = GetStreetNameAtCoord(data.key.x, data.key.y, data.key.z)
  streerRob = GetStreetNameFromHashKey(streetrob)
  
  PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)

  TriggerEvent('chat:addMessage', {
	  templateId = 'outlaw',
	  color =  {255,255,255},
	  multiline = false,
	  args = {"Dispatch: 10-90", " Fleeca bank at " ..streerRob}
	}) 


  Citizen.CreateThread(function(...)
    local blipA = AddBlipForRadius(data.key.x, data.key.y, data.key.z, 50.0)
    SetBlipHighDetail(blipA, true)
    SetBlipColour(blipA, 1)
    SetBlipAlpha (blipA, 128)

    local blipB = AddBlipForCoord(data.key.x, data.key.y, data.key.z)
    SetBlipSprite               (blipB, 458)
    SetBlipDisplay              (blipB, 4)
    SetBlipScale                (blipB, 1.0)
    SetBlipColour               (blipB, 1)
    SetBlipAsShortRange         (blipB, true)
    SetBlipHighDetail           (blipB, true)
    BeginTextCommandSetBlipName ("STRING")
    AddTextComponentString      ("Robbery In Progress")
    EndTextCommandSetBlipName   (blipB)

    local timer = GetGameTimer()
    while GetGameTimer() - timer < 30000 do
      Citizen.Wait(0)
    end

    RemoveBlip(blipA)
    RemoveBlip(blipB)
  end)
end

function MFF:SyncDoor(location)
  if not location then return; end
  Citizen.CreateThread(function(...)
    local isaVault = false
    self.MovedDoors = self.MovedDoors or {}
    local closest,closestDist
    local allObjs = ESX.Game.GetObjects()
    for k,v in pairs(allObjs) do
      local modelHash = GetEntityModel(v)
      local revHash = modelHash % 0x100000000
      if self.DoorHashes[modelHash] or self.DoorHashes[revHash] then
        local dist = Utils:GetVecDist(location,GetEntityCoords(v))
        if not closestDist or dist < closestDist then
          if modelHash == 2121050683 or revHash == 2121050683 then isaVault = true; else isaVault = false; end
          closest = v
          closestDist = dist
        end
      end
    end
    
    if not closest or closestDist > self.LoadDist then 
      self.Interacting = false
      return 
    end

    SetEntityAsMissionEntity(closest,false)
    local heading = GetEntityHeading(closest)
    local tick = 0
    while ((heading - 100.0) < GetEntityHeading(closest)) and tick < 350 do
      Citizen.Wait(0)
      tick = tick + 1
      local heading = GetEntityHeading(closest)
      SetEntityHeading(closest, heading - 0.3)
    end
    if isaVault then self.SafeOpen = true; end
    table.insert(self.MovedDoors, closest)
  end)
end



function MFF:mycb(success, timeremaining)
  if success then
    TriggerEvent("mhacking:show")
    TriggerEvent("mhacking:start",2,30,dummy2)
	else
    self.Interacting = false
    exports['mythic_notify']:SendAlert('error', 'You failed to hack into the doors')
		TriggerEvent('mhacking:hide')
	end
end

function MFF:mycb2(success, timeremaining)
  if success then
    TriggerEvent("mhacking:show")
    TriggerEvent("mhacking:start",2,25,dummy3)
	else
    self.Interacting = false
    exports['mythic_notify']:SendAlert('error', 'You failed to hack into the doors')
    TriggerEvent('mhacking:hide')
	end
end

function MFF:mycb3(success, timeremaining)
  if success then
    TriggerEvent("mhacking:hide")
    self.UsedActions[closer.key] = true
		TriggerServerEvent('MF_Fleeca:SyncBankData', closer.key)
    ClearPedTasksImmediately(plyPed)
    Wait(100)
    MFF:LockpickComplete(true)
    Self.SafeOpen = true
	else 
    self.Interacting = false
    exports['mythic_notify']:SendAlert('error', 'You failed to hack into the doors')
		TriggerEvent('mhacking:hide')
	end
end


function MFF.SetJob(source,job)
  local self = MFF
  local lastData = self.PlayerData
  if lastData.job.name == self.PoliceJobName then
    TriggerServerEvent('MF_Fleeca:CopLeft')
  elseif lastData.job.name ~= self.PoliceJobName and job.name == self.PoliceJobName then
    TriggerServerEvent('MF_Fleeca:CopEnter')
  end
  self.PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) MFF.SetJob(source,job); end)

RegisterNetEvent('MF_Fleeca:SyncDoor')
AddEventHandler('MF_Fleeca:SyncDoor', function(location) MFF:SyncDoor(location); end)

RegisterNetEvent('MF_Fleeca:NotifyPolice')
AddEventHandler('MF_Fleeca:NotifyPolice', function(data) MFF:NotifyPolice(data); end)

RegisterNetEvent('MF_Fleeca:SyncBankData')
AddEventHandler('MF_Fleeca:SyncBankData', function(data) MFF.UsedActions = data; end)

RegisterNetEvent('MF_Fleeca:SyncCops')
AddEventHandler('MF_Fleeca:SyncCops', function(count) MFF.PoliceOnline = count; end)

RegisterNetEvent('MF_LockPicking:MinigameComplete')
AddEventHandler('MF_LockPicking:MinigameComplete', function(result) MFF:LockpickComplete(result); end)

Citizen.CreateThread(function(...) MFF:Awake(...); end)