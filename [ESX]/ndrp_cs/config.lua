Config = {}

-- # Locale to be used. You can create your own by simple copying the 'en' and translating the values.
Config.Locale       				= 'en' -- Traduções disponives en / br

-- # By how many services a player's community service gets extended if he tries to escape
Config.ServiceExtensionOnEscape		= 5

-- # Don't change this unless you know what you are doing.
Config.ServiceLocation 				= {x =  205.3, y = -852.36, z = 30.59}

-- # Don't change this unless you know what you are doing.
Config.ReleaseLocation				= {x = 427.33, y = -979.51, z = 30.2}


-- # Don't change this unless you know what you are doing.
Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(205.3, -852.36, 30.59) },
	{ type = "cleaning", coords = vector3(216.05, -855.67, 30.33) },
	{ type = "cleaning", coords = vector3(230.06, -862.37, 29.96) },
	{ type = "cleaning", coords = vector3(235.89, -863.79, 29.82) },
	{ type = "cleaning", coords = vector3(242.85, -866.44, 29.65) },
	{ type = "cleaning", coords = vector3(254.98, -870.36, 29.34) },
	{ type = "cleaning", coords = vector3(245.66, -883.13, 30.49) },
	{ type = "cleaning", coords = vector3(223.67, -875.74, 30.49) },
	{ type = "gardening", coords = vector3(207.23, -869.73, 31.5) },
	{ type = "gardening", coords = vector3(185.74, -869.46, 31.5) },
	{ type = "gardening", coords = vector3(201.23, -880.31, 31.5) },
	{ type = "gardening", coords = vector3(203.35, -857.4, 30.56) },
	{ type = "gardening", coords = vector3(213.2, -858.98, 30.33) }
}



Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 56, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 0, ['pants_1']  = 64,
			['pants_2']  = 6,   ['shoes_1']  = 16,
			['shoes_2']  = 3,  ['chain_1']  = 0,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1']  = 79,  ['torso_2']  = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 118,  ['pants_1'] = 3,
			['pants_2']  = 15,  ['shoes_1']  = 16,
			['shoes_2']  = 3,   ['chain_1']  = 0,
			['chain_2']  = 0
		}
	}
}
