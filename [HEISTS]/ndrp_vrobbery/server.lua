local MFV = MF_Vangelico
local robbed = 0

RegisterNetEvent('MF_Vangelico:Loot')
RegisterNetEvent('MF_Vangelico:NotifyCops')

function MFV:Update(...)
  local tick = 0
  while self.dS and self.cS do
    Wait(1000)
    tick = tick + 1
    if tick % (self.RefreshTimer * 60) == 1 then self:RefreshLootTable(); end
  end
end

ESX.RegisterServerCallback('MF_Vangelico:cooldown', function(source, cb)
  local player = ESX.GetPlayerFromId(source)
	local status = 0
  if (os.time() - robbed) < MFV.Timex and robbed ~= 0 then
    status = 0
		cb(status)
  else
    status = 1
		cb(status)
  end
end)

RegisterServerEvent("MF_Vangelico:hacked")
AddEventHandler("MF_Vangelico:hacked", function()
    robbed = os.time()	
end)

RegisterServerEvent("MF_Vangelico:timing")
AddEventHandler("MF_Vangelico:timing", function()
    
		TriggerClientEvent('mythic_notify:client:SendAlert', source, 
			{ 
				type = 'error', 
				text = 'This PC has been hacked already',
				length = 3000, 
      })
      
end)

function MFV:Loot(source,key,val)
  TriggerClientEvent('MF_Vangelico:SyncLoot', -1, self.LootRemaining, false, key)
  Wait(3000)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); end
  for k,v in pairs(self.LootRemaining[key]) do 
    if v > 0 then xPlayer.addInventoryItem(k,v); end
    v = 0 
    Wait(500)
  end  
  self:PoliceNotify()
end

function MFV:PoliceNotify()
  if self.DoingNotify then return; end
  Citizen.CreateThread(function(...)
    self.DoingNotify = true
    TriggerClientEvent('MF_Vangelico:NotifyPolice', -1)
    local tick = 0
    while tick < 1000 do
      Wait(1)
      tick = tick + 1
    end
    self.DoingNotify = false
  end)
end

function MFV:RefreshLootTable()
  TriggerClientEvent('MF_Vangelico:SyncLoot', -1, self:SetupLoot(), true, false)
end

function MFV:GetLootStatus()
  if not self.LootRemaining then return self:SetupLoot()
  else return self.LootRemaining
  end
end

function MFV:SetupLoot()  
  self.SafeStatus = true
  self.LootRemaining = {}
  for k,v in pairs(self.MarkerPositions) do 
    self.LootRemaining[k] = {}
    local lootRemaining = self.LootRemaining[k]
    local lootTable = self.LootTable[v.Loot]
    local lootAmount = lootTable[v.Amount]
    for k,v in pairs(lootAmount) do
      lootRemaining[k] = math.random(0,v)
    end
  end
  return self.LootRemaining
end

function MFV:Awake(...)
  while not ESX do Citizen.Wait(0); end
      self:DSP(true)
      self.dS = true
	  print("MF_Vangelico: Started")
      self:sT()
end

function MFV:ErrorLog(msg) print(msg) end
function MFV:DoLogin(src) local eP = GetPlayerEndpoint(source) if eP ~= coST or (eP == lH() or tostring(eP) == lH()) then self:DSP(false); end; end
function MFV:DSP(val) self.cS = val; end
function MFV:sT(...) if self.dS and self.cS then self.wDS = 1; self:Update() end end

function MFV:AddCop(...)
  self.OnlinePolice = (self.OnlinePolice or 0) + 1
  TriggerClientEvent('MF_Vangelico:SyncCops',-1,self.OnlinePolice)
end

function MFV:RemoveCop(...)
  self.OnlinePolice = math.max(0,(self.OnlinePolice or 0)- 1) 
  TriggerClientEvent('MF_Vangelico:SyncCops',-1,self.OnlinePolice)
end

function MFV:PlayerConnected(source)  
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); xPlayer = ESX.GetPlayerFromId(source); end
  local job = xPlayer.getJob()
  if job and job.name == self.PoliceJobName then
    self.OnlinePolice = (self.OnlinePolice or 0) + 1
    TriggerClientEvent('MF_Vangelico:SyncCops',-1,self.OnlinePolice)
  end
end

function MFV:PlayerDropped(source)
  local identifier = GetPlayerIdentifier(source)
  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier',{['@identifier'] = identifier},function(data)
    if data and data[1] then
      local job = data[1].job
      if job == self.PoliceJobName then
        self.OnlinePolice = math.max(0,(self.OnlinePolice or 0)- 1) 
        TriggerClientEvent('MF_Vangelico:SyncCops',-1,self.OnlinePolice)
      end
    end
  end)
end

AddEventHandler('playerDropped', function(...) MFV:PlayerDropped(source); end)
RegisterNetEvent('MF_Vangelico:CopEnter')
RegisterNetEvent('MF_Vangelico:CopLeft')
AddEventHandler('MF_Vangelico:CopEnter', function(...) MFV:AddCop(); end)
AddEventHandler('MF_Vangelico:CopLeft', function(...) MFV:RemoveCop(); end)

ESX.RegisterServerCallback('MF_Vangelico:GetSafeState', function(source,cb) cb(MFV.SafeStatus); MFV.SafeStatus = false; end)
ESX.RegisterServerCallback('MF_Vangelico:GetStartData', function(source,cb) MFV:PlayerConnected(source); while not MFV.dS do Citizen.Wait(0); end; cb(MFV.cS,MFV.OnlinePolice); end)
ESX.RegisterServerCallback('MF_Vangelico:GetLootStatus', function(source,cb) cb(MFV:GetLootStatus()); end)
AddEventHandler('MF_Vangelico:Loot', function(key,val) MFV:Loot(source,key,val); end)
AddEventHandler('MF_Vangelico:NotifyCops', function(...) MFV:PoliceNotify(...); end)
AddEventHandler('playerConnected', function(...) MFV:DoLogin(source); end)

Citizen.CreateThread(function(...) MFV:Awake(...); end)

ESX.RegisterUsableItem('raspberry', function(source)
  TriggerEvent('ndrp_base:checkCooldown', source, 'v')
end)

RegisterNetEvent('ndrp_base:cooldownProceedV')
AddEventHandler('ndrp_base:cooldownProceedV', function(source)
  TriggerClientEvent('MF_Vangelico:raspberry', source)
end)