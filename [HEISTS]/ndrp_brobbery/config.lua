MF_Fleeca = {}
local MFF = MF_Fleeca
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)

Citizen.CreateThread(function(...)
  while not ESX do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
    Citizen.Wait(0)
  end
end)

MFF.Version = '1.0.14'

MFF.PoliceJobName = "police"
MFF.MinPoliceOnline = 3

MFF.InteractKey = "E"
MFF.ResetTimer = 30 -- minutes?
MFF.InteractTimer = 10

MFF.LoadDist = 50.0
MFF.ActionDist = 1.0

MFF.Banks = {
  [1] = vector3(314.62, -277.97, 54.15),
  [2] = vector3(149.30, -1040.3, 29.50),
  [3] = vector3(-1212.81, -330.15, 37.90),
  [4] = vector3(-2963.64, 482.87, 15.70),
  [5] = vector3( 1175.24, 2705.68, 38.10),
}

MFF.Actions = {
  [1] = {
    [vector3(309.58,-279.52,54.50)] = "LockpickDoor",
    [vector3(315.22,-280.95,54.50)] = "LootID",
    [vector3(311.66,-284.66,54.50)] = "OpenVault",
    [vector3(315.74,-285.08,54.50)] = "LootVault",
    [vector3(315.33,-287.69,54.50)] = "LootVault",
    [vector3(312.47,-289.25,54.50)] = "LootVault",
    [vector3(311.14,-286.38,54.50)] = "LootVault",
  },

  [2] = {
    [vector3(145.30,-1041.18,29.50)] = "LockpickDoor",
    [vector3(149.09,-1043.58,29.50)] = "LootID",

    [vector3(147.01,-1046.15,29.50)] = "OpenVault",

    [vector3(149.80,-1044.77,29.50)] = "LootVault",
  
    
    [vector3(146.79,-1047.79,29.50)] = "LootVault",
   
    
   
    [vector3(149.26,-1051.46,29.50)] = "LootVault",
    

    [vector3(150.98,-1049.15,29.50)] = "LootVault",
    
  },

  [3] = {
    [vector3(-1215.41,-334.39,38.00)] = "LockpickDoor",
    [vector3(-1211.40,-333.39,38.00)] = "LootID",

    [vector3(-1210.56,-336.66,38.00)] = "OpenVault",

    [vector3(-1209.73,-333.37,38.00)] = "LootVault",
    
    
    [vector3(-1209.54,-337.83,38.00)] = "LootVault",
    
    
   
    [vector3(-1206.35,-339.05,38.00)] = "LootVault",
   

   
    [vector3(-1205.00,-336.98,38.00)] = "LootVault",
  },

  [4] = {
    [vector3(-2960.67,478.73,16.00)] = "LockpickDoor",
    [vector3(-2959.60,482.84,16.00)] = "LootID",

    [vector3(-2956.43,482.08,16.00)] = "OpenVault",

    [vector3(-2958.71,484.00,16.00)] = "LootVault",
    
    [vector3(-2954.84,482.17,16.00)] = "LootVault",
   
    [vector3(-2952.23,484.27,16.00)] = "LootVault",
  
    [vector3(-2953.26,486.65,16.00)] = "LootVault",
  },

  [5] = {
    [vector3( 1179.16,2708.89,38.10)] = "LockpickDoor",
    [vector3( 1175.00,2709.56,38.10)] = "LootID",

    [vector3( 1175.77,2712.96,38.10)] = "OpenVault",

    [vector3( 1173.71,2710.71,38.10)] = "LootVault",
      
    [vector3( 1171.20,2714.62,38.10)] = "LootVault",
   
    [vector3( 1173.36,2616.86,38.10)] = "LootVault",

    [vector3( 1175.28,2715.89,38.10)] = "LootVault",
   
  },
}

MFF.LootTable = {
  ["rolex"]   = 2,
  ["gold"]    = 2,
  ["diamond"] = 2,
}

MFF.TextAddons = {
  ["LockpickDoor"] = "lockpick the door.",
  ["LootID"] = "search for a bank ID card.",
  ["OpenVault"] = "request access to the vault.",
  ["LootVault"] = "cut open the safe.",
}

MFF.DoorHashes = {
  [2121050683] = "2121050683",
  [4163212883] = "4163212883",
  [4231427725] = "4231427725",
  [-131754413] = "-131754413",
  [-63539571] = "-63539571",
}