Config = {}

Config.RequiredPoliceOnline = 5		-- required police online for players to do missions
Config.PoliceDatabaseName = "police"	-- set the exact name from your jobs database for police
Config.PoliceNotfiyEnabled = true		-- police notification upon truck robbery enabled (true) or disabled (false)
Config.PoliceBlipShow = true 			-- enable or disable blip on map on police notify
Config.PoliceBlipTime = 60				-- miliseconds that blip is active on map (this value is multiplied with 4 in the script)
Config.PoliceBlipRadius = 50.0			-- set radius of the police notify blip
Config.PoliceBlipAlpha = 250			-- set alpha of the blip
Config.PoliceBlipColor = 5				-- set blip color

-- Set cooldown timer, which player has to wait before being able to do a mission again, in minutes here:

Config.CooldownTimer = 5

-- Enable or disable player wearing a 'heist money bag' after the robbery:

Config.EnablePlayerMoneyBag = false

-- Hacking Settings:

Config.EnableAnimationB4Hacking = true			-- enable/disable hacking or typing animation
Config.HackingBlocks = 3						-- amount of blocks u have to match
Config.HackingSeconds = 30						-- seconds to hack

-- Mission Cost Settings:

Config.MissionCost = 0		-- taken from bank account // set to 0 to disable mission cost


-- Mission Blip Settings:

Config.EnableMapBlip = false						-- set between true/false
Config.BlipNameOnMap = "Hack Truck"					-- set name of the blip
Config.BlipSprite = 67								-- set blip sprite, lists of sprite ids are here: https://docs.fivem.net/game-references/blips/
Config.BlipDisplay = 4								-- set blip display behaviour, find list of types here: https://runtime.fivem.net/doc/natives/#_0x9029B2F3DA924928
Config.BlipScale = 0.7								-- set blip scale/size on your map
Config.BlipColour = 5								-- set blip color, list of colors available in the bottom of this link: https://docs.fivem.net/game-references/blips/

-- Armored Truck Blip Settings:

Config.BlipNameForTruck = "Bank Truck"				-- set name of the blip
Config.BlipSpriteTruck = 1							-- set blip sprite, lists of sprite ids are here: https://docs.fivem.net/game-references/blips/
Config.BlipColourTruck = 5							-- set blip color, list of colors available in the bottom of this link: https://docs.fivem.net/game-references/blips/
Config.BlipScaleTruck = 0.9							-- set blip scale/size on your map

-- Mission Start Location:

Config.MissionSpot = {
	{ ["x"] = 205.96, ["y"] = -994.87, ["z"] = -99.0, ["h"] = 0 },
}

-- Mission Marker Settings:

Config.MissionMarker = 27 												-- marker type
Config.MissionMarkerColor = { r = 240, g = 52, b = 52, a = 100 } 		-- rgba color of the marker
Config.MissionMarkerScale = { x = 1.25, y = 1.25, z = 1.25 }  			-- the scale for the marker on the x, y and z axis
Config.Draw3DText = "Press ~g~[E]~s~ to ~y~ Start Mission ~s~"			-- set your desired text here

-- Control Keys

Config.KeyToStartMission = 38	-- default: [E] // set key to start the mission
Config.KeyToOpenTruckDoor = 47
Config.KeyToRobFromTruck = 38										

-- ESX.ShowNotifications:

Config.NoMissionsAvailable = "No truck available, please try again later!"
Config.HackingFailed = "Missio failed"
Config.TruckMarkedOnMap = "Bank truck marked on gps"
Config.KillTheGuards = "Take out the guards"
Config.MissionCompleted = "Mission Finished"
Config.BeginToRobTruck = "Go to the Armored Truck and start stealing"
Config.GuardsNotKilledYet = "Clear the guards from truck"
Config.TruckIsNotStopped = "Stop the truck before stealing"
Config.NotEnoughMoney = "You don't have enough cash"
Config.NotEnoughPolice = "Not enough security"
Config.CooldownMessage = "No mission available right now"
Config.RewardMessage = "You have robbed the truck"
Config.DispatchMessage = "Bank Truck robbery at %s"

-- ESX.ShowHelpNotifications:

Config.OpenTruckDoor = "Press ~INPUT_DETONATE~ to Plant C4"
Config.RobFromTruck = "Press ~INPUT_PICKUP~ To Loot"

-- ProgressBars text

Config.Progress1 = "INJECTING EXPLOITS"
Config.Progress2 = "PLANTING C4 EXPLOSIVE"
Config.Progress3 = "Countdown to Explosion"
Config.Progress4 = "LOOTING THE MONEY"

-- ProgressBar Timers, in seconds:

Config.RetrieveMissionTimer = 7.5	-- time from pressed E to receving location on the truck
Config.DetonateTimer = 180			-- time until bomb is detonated
Config.RobTruckTimer = 15			-- time spent to rob the truck

-- Guards Weapons:

Config.DriverWeapon = "WEAPON_ADVANCEDRIFLE"		-- weapon for driver
Config.PassengerWeapon = "WEAPON_ADVANCEDRIFLE" 	-- weapon for passenger

-- Armored Truck Spawn Locations

Config.ArmoredTruck = 
{
	{ 
		Location = vector3(-665.34,-603.03,24.4), 
		InUse = false,
		heading = 352.27
	},
	{ 
		Location = vector3(-1327.84,-802.54,16.65), 
		InUse = false,
		heading = 128.0
	},
	{ 
		Location = vector3(-891.61,-2046.37,8.3), 
		InUse = false,
		heading = 133.89
	},
} 

Config.mLoc = 
{
	{ 
		Location = vector3(-670.36,-602.56,31.55), 
	},
	{ 
		Location = vector3(-1317.02,-816.82,17.11),  
	},
	{ 
		Location = vector3(-965.43,-2067.66,9.410), 
	},
}