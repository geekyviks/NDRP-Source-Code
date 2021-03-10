RegisterNetEvent('MF_Vangelico:NotifyPolice')
RegisterNetEvent('MF_Vangelico:SyncLoot')
RegisterNetEvent('MF_Vangelico:SyncCops')

local MFV = MF_Vangelico
local canrob  = false
local stage1 = false
local canrobb = 0

MFV.PoliceOnline = 0
function MFV:Start(...)
  self.SoundID    = GetSoundId() 
  self.Timer      = GetGameTimer()
  self:SetupBlip()
  self.Looted = {}
  self.CurJob = ESX.GetPlayerData().job
  ESX.TriggerServerCallback('MF_Vangelico:GetLootStatus', function(loot) 
    self.LootRemaining = loot
    for k,v in pairs(self.LootRemaining) do 
      local loot = true
      local noloot = false 
      for k,v in pairs(v) do
        if v == 0 then
          if not loot then
            noloot = true
          else 
            loot = false
          end 
        else
          if noloot then noloot = false; end
          loot = true
        end
      end
      if not loot and noloot then
        self.Looted[k] = true
      end
    end
    if self.dS and self.cS then self:Update(); end
  end)
end

function MFV:Update()
  local tick = 0
  while self.cS and self.dS do
    Citizen.Wait(0)  
    tick = tick + 1
    --if self.CurJob and self.CurJob.name ~= self.PoliceJobName then
      local plyPed = GetPlayerPed(-1)
      local plyPos = GetEntityCoords(plyPed)
      if (Utils:GetVecDist(plyPos, self.VangelicoPosition) < self.LoadZoneDist) and not self.DoingAction then   
        if not self.InZone then     
          self.InZone = true
        end
        if self.PoliceOnline and self.PoliceOnline >= self.MinPoliceOnline then  
          if not self.DeletedSeats then self:DeleteSeats(); end
          local key,val,closestDist,safe = self:GetClosestMarker(plyPos)
          if closestDist < self.InteractDist then
            if not safe then              
              if self.UsingSafe then
                self.UsingSafe = false
              end
              local lootRemains
              for k,v in pairs(self.LootRemaining[key]) do if v > 0 then lootRemains = true; end; end
              if (not self.Looted or (self.Looted and not self.Looted[key])) and lootRemains and canrob then
                Utils:DrawText3D(val.Pos.x,val.Pos.y,val.Pos.z, "Press [~r~E~s~] to break the glass.")
                if Utils:GetKeyPressed("E") then
                  self:Interact(key,val, plyPed,false)
                end
              end
            elseif not self.SafeUsed then          
              
            end
          else
            if self.UsingSafe then
              self.UsingSafe = false
              
            end
          end
        else

          self.InZone = false
          self.DeletedSeats = false
          self.SentCopNotify = false
          Citizen.Wait(1000)
        end
      else
        self.InZone = false
        self.DeletedSeats = false
        self.SentCopNotify = false
        Citizen.Wait(1000)
      end
    --end
  end
end     

function MFV:DeleteSeats()
  local newPos = vector3(-625.243, -223.44, 37.78)
  TriggerEvent('MF_SafeCracker:SpawnSafe', false, newPos, 0.0)
  self.DeletedSeats = true
  local objects = ESX.Game.GetObjects()
  for k,v in pairs(objects) do
    local model = GetEntityModel(v) % 0x100000000
    if model == self.SeatHash then 
      SetEntityAsMissionEntity(v,false)
      DeleteObject(v)
    end
  end
end

function MFV:SetupBlip()
 
end

function MFV:GetClosestMarker(pos)
  local key,val,dist,safe
  for k,v in pairs(self.MarkerPositions) do
    local curDist = Utils:GetVecDist(pos, v.Pos.xyz)
    if not dist or curDist < dist then
      key = k
      val = v
      dist = curDist
      safe = false
    end
  end

  local curDist = Utils:GetVecDist(pos, self.SafePos)
  if not dist or curDist < dist then
    key = false
    val = false
    dist = curDist
    safe = true
  end

  if not dist then return false,false,false,false
  else return key,val,dist,safe
  end
end

function MFV:Interact(key,val, plyPed, safe)
  if not safe then
    local plySkin
    local plyWeapon = GetCurrentPedWeapon(plyPed)

    local weapHash = GetSelectedPedWeapon(plyPed) % 0x100000000

    local matching = false
    for k,v in pairs(self.MeleeWeapons) do if v == weapHash then matching = true; end; end

    TriggerEvent('skinchanger:getSkin', function(skin) plySkin = skin; end)
    if not matching and plyWeapon then
      self.Looted = self.Looted or {}
      self.Looted[key] = true
      self.DoingAction = true
      TriggerServerEvent('MF_Vangelico:Loot', key,val)
      local loot = self.LootRemaining[key]

      TaskTurnPedToFaceCoord(plyPed, val.Pos.x, val.Pos.y, val.Pos.z, -1)
      Wait(1500)

      ESX.Streaming.RequestAnimDict('missheist_jewel', function(...)
        TaskPlayAnim( plyPed, "missheist_jewel", "smash_case_tray_a", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )     
      end)
      Wait(500)

      if not HasNamedPtfxAssetLoaded("scr_jewelheist") then RequestNamedPtfxAsset("scr_jewelheist"); end
      while not HasNamedPtfxAssetLoaded("scr_jewelheist") do Citizen.Wait(0); end    

      SetPtfxAssetNextCall("scr_jewelheist")
      StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", val.Pos.x, val.Pos.y, val.Pos.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)                
      PlaySoundFromCoord(-1, "Glass_Smash", val.Pos.x, val.Pos.y, val.Pos.z, 0, 0, 0, 0)
      Wait(2400)

      ClearPedTasksImmediately(plyPed)
      Wait(1000)
      if not self.SentCopNotify then
        
      end

      self.DoingAction = false
    elseif not plyWeapon then
      ESX.ShowNotification("You need something to break the glass with.")
    elseif plySkin["bags_2"] == 0 and plySkin["bags_1"] == 0 then
      ESX.ShowNotification("You need a bag to carry the goods with.")
    elseif matching then
      ESX.ShowNotification("You can't break the glass with this.")      
    end
  else 
    self.SafeUsed = true
    ESX.TriggerServerCallback('MF_Vangelico:GetSafeState', function(canUse)
      if canUse then
        self.UsingSafe = true
      else
        ESX.ShowNotification("Somebody has already cracked this safe.")
      end
    end)
  end
end

function MFV:Awake(...)
    while not ESX do Citizen.Wait(0); end
    while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
    ESX.TriggerServerCallback('MF_Vangelico:GetStartData', function(retVal,cops) self.PoliceOnline = cops; self.dS = true; self.cS = retVal; end)
    while not self.dS do Citizen.Wait(0); end
    self.PlayerData = ESX.GetPlayerData()
    self:Start()
end

function MFV:DoNotifyPolice(...)
  if not ESX then return; end
  local plyData = ESX.GetPlayerData()
  if plyData.job.name == self.PoliceJobName or plyData.job.name == 'weazelnews' then
    TriggerEvent('chat:addMessage', {
      templateId = 'outlaw',
      color =  {255,255,255},
      multiline = false,
      args = {"Dispatch", " Someone has hacked the Vangelico store security"}
      }) 
    ESX.ShowNotification('Somebody is robbing Vangelicos jewelry store.')
  end
end

function MFV:DoSyncLoot(loot,new,key)
  if not self.LootRemaining then return; end
  self.LootRemaining = loot
  if key and self.Looted then self.Looted[key] = true; end
  if new then
    self.SafeUsed = false
    self.Looted = {}
  end
end

function MFV:SetJob(job)
  self.CurJob = job;
  local lastData = self.PlayerData
  if lastData.job.name == self.PoliceJobName then
    TriggerServerEvent('MF_Vangelico:CopLeft')
  elseif lastData.job.name ~= self.PoliceJobName and job.name == self.PoliceJobName then
    TriggerServerEvent('MF_Vangelico:CopEnter')
  end
  self.PlayerData = ESX.GetPlayerData()
end

AddEventHandler('MF_Vangelico:NotifyPolice', function(...) MFV:DoNotifyPolice(...); end)
AddEventHandler('MF_Vangelico:SyncLoot', function(loot,new,key) MFV:DoSyncLoot(loot,new,key); end)
AddEventHandler('MF_Vangelico:SyncCops', function(cops) MFV.PoliceOnline = cops; end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) MFV:SetJob(job); end)

Citizen.CreateThread(function(...) MFV:Awake(...); end)

RegisterNetEvent('MF_Vangelico:raspberry')
AddEventHandler('MF_Vangelico:raspberry', function()
  print(canrob)
  ESX.TriggerServerCallback('MF_Vangelico:cooldown', function(hb)
    canrobb = hb
    print(canrobb)
    if canrobb == 1 then
      
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)
      local boneIndex = GetPedBoneIndex(playerPed, 28422)
      
      if GetDistanceBetweenCoords(coords, -631.4, -230.17, 38.06 , true) < 1 then
        AttachEntityToEntity('prop_cs_tablet', playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
        ESX.Streaming.RequestAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@idle_a', function()
				  TaskPlayAnim(playerPed, 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a', 'idle_a', 8.0, -8, -1, 49, 0, 0, 0, 0)
        end)
        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start",4,35,mycb)
      end
    else
      TriggerServerEvent("MF_Vangelico:timing")
    end
  end)
end)

function mycb(success, timeremaining)
  if success then
    TriggerServerEvent('ndrp_base:setCoolDown')
    stage1= true
    exports['mythic_notify']:SendAlert('success', 'Successfully Hacked Computer', 4500, { ['background-color'] = '#ffd700', ['color'] = '#000000' })
    TriggerEvent('mhacking:hide')
    ClearPedSecondaryTask(PlayerPedId())
  else
    print('Failure')
    TriggerEvent('mhacking:hide')
    ClearPedSecondaryTask(PlayerPedId())
  end
end

Citizen.CreateThread(function()

  while true do
    Citizen.Wait(1)
    if stage1 then
      ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to disable store security")
      if IsControlJustReleased(0, 38) then
        TriggerServerEvent("MF_Vangelico:hacked")
        TriggerServerEvent('MF_Vangelico:NotifyCops')
        exports['mythic_progbar']:Progress({
              name = "Hacking",
              duration = 60000,
              label = "Disabling the security system",
              useWhileDead = false,
              canCancel = false,
              controlDisables = {
                  disableMovement = true,
                  disableCarMovement = true,
                  disableMouse = false,
                  disableCombat = true,
              },
              animation = {
                  animDict = "mp_prison_break",
                  anim = "hack_loop",
                  flags = 49,
              }
        })
        Citizen.Wait(60000)
        exports['mythic_notify']:SendAlert('success', 'Store security disabled', 4500, { ['background-color'] = '#ffd700', ['color'] = '#000000' })
        canrob = true
        stage1 = false
      end
    end
  end
end)