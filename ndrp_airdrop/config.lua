Config              = {}
Config.DrawDistance = 100.0

Config.Locale       = 'en'
Config.Timex		= 720

Config.Vehicles = {
	
	Truck = {
		Spawner = 1,
		Label = 'Rent Plane For $1000',
		Hash = "dodo",
		Livery = 0,
		Trailer = "none"
	}
}

Config.Zones = {

	Cloakroom = {
		Pos     = {x = 2122.76, y = 4785.32, z = 40.97},
		Size    = {x = 1.5, y = 1.5, z = 0.3},
		Color   = {r = 11, g = 203, b = 159},
		Type    = -1,
		BlipSprite = 308,
		BlipColor = 5,
		BlipName = _U('blip_locker'),
		hint = _U('prompt_locker')
	},

	VehicleSpawner = {
		Pos   = {x = 2130.76, y = 4785.32, z = 40.97},
		Size  = {x = 1.5, y = 1.5, z = 0.3},
		Color = {r = 11, g = 203, b = 159},
		Type  = -1,
		BlipName = _U('blip_vehicle'),
		hint = _U('prompt_vehicle')
	},

	VehicleSpawnPoint = {
		Pos   = {x = 2133.01, y = 4784.27, z = 40.97},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = -1,
		Heading = 25.48
	},

	VehicleDeleter = {
		Pos   = {x = 2136.76, y = 4780.32, z = 40.97},
		Size  = {x = 6.0, y = 6.0, z = 1.3},
		Color = {r = 255, g = 0, b = 0},
		Type  = -1,
		BlipName = _U('blip_vehicledeleter'),
		hint = _U('prompt_vehicledeleter')
	},
}

--Config.Pool = {

--	{ [ 'x' ] = 	 -2507.00	, [ 'y' ] = 	4836.00	, [ 'z' ] = 	-0.0	},
--	{ [ 'x' ] = 	 -3413.00	, [ 'y' ] = 	2766.00	, [ 'z' ] = 	-0.0	},
--	{ [ 'x' ] = 	 -1683.00	, [ 'y' ] = 	6212.00	, [ 'z' ] = 	-0.0	},
--	{ [ 'x' ] = 	 -3648.00	, [ 'y' ] = 	1436.00	, [ 'z' ] = 	-0.0	},	
--}

