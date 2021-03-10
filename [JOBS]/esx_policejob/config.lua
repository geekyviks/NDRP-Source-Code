Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 27
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.7 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'en'


Config.PoliceArmory = {
	{ ["x"] = 460.06, ["y"] = -979.46, ["z"] = 29.709582824707, ["h"] = 0 },
}
Config.ArmoryMarker = 22
Config.ArmoryMarkerColor = { r = 50, g = 50, b = 204, a = 100 }
Config.AmmoAmount = 250

Config.WeaponsInArmory = {	
	{ ["weaponHash"] = "WEAPON_FLASHLIGHT", ["name"] = "Flashlight" },
	{ ["weaponHash"] = "WEAPON_NIGHTSTICK", ["name"] = "Nightstick" },
	{ ["weaponHash"] = "WEAPON_STUNGUN", ["name"] = "Tazer" },
	{ ["weaponHash"] = "WEAPON_PISTOL_MK2", ["name"] = "MK2 Pistol" },
	{ ["weaponHash"] = "WEAPON_SMG", ["name"] = "SMG" },	
	{ ["weaponHash"] = "WEAPON_ADVANCEDRIFLE", ["name"] = "Advanced Rifle" },
	{ ["weaponHash"] = "WEAPON_PUMPSHOTGUN", ["name"] = "Shotgun" },
}

Config.Zones = {

	PoliceDuty = {
	  Pos   = { x = 439.825, y = -975.693, z = 30.60 },
	  Size  = { x = 0.8, y = 0.8, z = 0.5 },
	  Color = { r = 50, g = 50, b = 204 },
	  Type = 22,
	},
  
	AmbulanceDuty = {
	  Pos = { x = 307.3, y = -600.16, z = 42.29 },
	  Size = { x = 1.5, y = 1.5, z = 1.5 },
	  Color = { r = 102, g = 0, b = 102 },
	  Type = 27,
	},
  }


Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.8,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(452.6, -992.8, 30.6)
		},

		Armories = {
			vector3(451.7, -980.1, 30.6)
		},
		BossActions = {
			vector3(448.4, -973.2, 30.6)
		}

	}

}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	
	cadet_wear = {
		male = {
			['tshirt_1'] = 37,  ['tshirt_2'] = 0,
			['torso_1'] = 102,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 87,   ['pants_2'] = 2,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 2,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	officer_wear = {
		male = {
			['tshirt_1'] = 37,  ['tshirt_2'] = 0,
			['torso_1'] = 101,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 12,
			['pants_1'] = 87,   ['pants_2'] = 2,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 24,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	senior_wear = {
		male = {
			['tshirt_1'] = 37,  ['tshirt_2'] = 0,
			['torso_1'] = 101,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 1,
			['arms'] = 12,
			['pants_1'] = 87,   ['pants_2'] = 2,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 24,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	sergeant_wear = {
		male = {
			['tshirt_1'] = 37,  ['tshirt_2'] = 0,
			['torso_1'] = 101,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 12,
			['pants_1'] = 87,   ['pants_2'] = 2,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 12,  ['bproof_2'] = 3,
			['bproof_1'] = 24,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	lieutenant_wear = { -- currently the same as intendent_wear
		male = {
			['tshirt_1'] = 37,  ['tshirt_2'] = 0,
			['torso_1'] = 101,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 12,
			['pants_1'] = 87,   ['pants_2'] = 2,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 12,  ['bproof_2'] = 3,
			['bproof_1'] = 24,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	captain_wear = {
		male = {
			['tshirt_1'] = 41,  ['tshirt_2'] = 1,
			['torso_1'] = 3,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 49,   ['pants_2'] = 1,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 24,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	deputy_wear = { -- currently the same as chef_wear
	male = {
		['tshirt_1'] = 11,  ['tshirt_2'] = 7,
		['torso_1'] = 4,   ['torso_2'] = 4,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 12,
		['pants_1'] = 10,   ['pants_2'] = 4,
		['shoes_1'] = 10,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = -1,    ['chain_2'] = 5,
		['ears_1'] = 2,     ['ears_2'] = 0,
		['bproof_1'] = 24,  ['bproof_2'] = 0
	},
	female = {
		['tshirt_1'] = 35,  ['tshirt_2'] = 0,
		['torso_1'] = 48,   ['torso_2'] = 0,
		['decals_1'] = 7,   ['decals_2'] = 3,
		['arms'] = 44,
		['pants_1'] = 34,   ['pants_2'] = 0,
		['shoes_1'] = 27,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 0,
		['ears_1'] = 2,     ['ears_2'] = 0
	}
	},

	chief_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 10,  ['tshirt_2'] = 0,
			['torso_1'] = 4,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 12,
			['pants_1'] = 10,   ['pants_2'] = 4,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 38,    ['chain_2'] = 5,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 24,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},


	bullet_wear = {
		male = {
			['bproof_1'] = 12,  ['bproof_2'] = 3
		},
		female = {
			['bproof_1'] = 12,  ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}

}