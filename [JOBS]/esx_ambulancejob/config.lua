Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 27, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 500  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = false -- enable anti-combat logging?
Config.LoadIpl                    = true -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 4 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 50 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = false
Config.RemoveItemsAfterRPDeath    = false

-- Let the player pay for respawning early, only if he can afford it.

Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = { coords = vector3(308.04, -595.16, 43.29), heading = 210.06 }

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(308.1, -595.27, 43.29),
			sprite = 61,
			scale  = 0.8,
			color  = 2
		},

		AmbulanceActions = {
			vector3(301.57, -598.89, 42.30)
		},

		Pharmacies = {
			vector3(309.63, -568.28, 42.30)
		},

		FastTravels = {
			{
				From = vector3(359.58, -584.9, 27.84),
				To = { coords = vector3(330.51, -594.89, 42.30), heading = 76.95 },
				Marker = { type = 27, x = 1.2, y = 1.2, z = 0.2, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(332.31, -595.55, 42.30),
				To = { coords = vector3(361.05, -584.9, 27.84), heading = 238.66 },
				Marker = { type = 27, x = 1.2, y = 1.2, z = 0.2, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(3330.01, -6601.01, 42.30),
				To = { coords = vector3(340.21, -584.47, 73.17), heading = 250.40 },
				Marker = { type = 27, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(338.57, -583.97, 73.17),
				To = { coords = vector3(327.71, -602.17, 42.30), heading = 334.98 },
				Marker = { type = 27, x = 1.2, y = 1.2, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(-68.87, 63.61, 70.91),
				To = { coords = vector3(238.339, -1004.89, -99.9), heading = 94.42 },
				Marker = { type = 27, x = 1.2, y = 1.2, z = 1.2, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(240.27, -1004.89, -99.9),
				To = { coords = vector3(-69.64, 62.21, 71.00), heading = 137.11 },
				Marker = { type = 27, x = 1.2, y = 1.2, z = 1.2, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(327.18, -603.41, 42.30),
				To = { coords = vector3(340.21, -584.47, 73.17), heading = 250.40 },
				Marker = { type = 27, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = "Press ~INPUT_CONTEXT~ to use lift"
			},

			{
				From = vector3(256.5, -1357.7, 36.0),
				To = { coords = vector3(340.21, -584.47, 73.17), heading = 250.40 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		}

	}
}
