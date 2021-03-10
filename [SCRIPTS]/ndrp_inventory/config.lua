Config = {}
Config.Locale = 'en'
Config.IncludeCash = false -- Include cash in inventory?
Config.IncludeAccounts = false -- Include accounts (bank, black money, ...)?
Config.ExcludeAccountsList = {"bank"} -- List of accounts names to exclude from inventory
Config.CheckOwnership = false -- If true, Only owner of vehicle can store items in trunk.
Config.AllowPolice = false -- If true, police will be able to search players' trunks.
Config.OpenControl = 311 -- Key for opening inventory. Edit html/js/config.js to change key for closing it.
Config.OpenKey = 246 -- Key for opening trunk

-- List of item names that will close ui when used
Config.CloseUiItems = {"headbag", "fishingrod", "tunerlaptop", "binoculars", "gps", "joint", "cigarette", "cigar", "fixkit", "rollingpaper", "cocaine", "meth"}

Config.ShopBlipID = 52
Config.LiquorBlipID = 93
Config.YouToolBlipID = 402
Config.PrisonShopBlipID = 52
Config.WeedStoreBlipID = 140
Config.WeaponShopBlipID = 110

Config.ShopLength = 14
Config.LiquorLength = 10
Config.YouToolLength = 2
Config.PrisonShopLength = 2

Config.Color = 2
Config.WeaponColor = 1

Config.WeaponLiscence = {x = 12.47, y = -1105.5, z = 29.8}
Config.LicensePrice = 5000

Config.Shops = {
    RegularShop = {
        Locations = {
			{x = 373.875, y = 325.896, z = 102.566},
			{x = 2557.458, y = 382.282, z = 107.622},
			{x = -3038.939, y = 585.954, z = 6.908},
			{x = -3241.927, y = 1001.462, z = 11.830},
			{x = 547.431,   y = 2671.710, z = 41.156},
			{x = 1961.464,  y = 3740.672, z = 31.343},
			{x = 2678.916,  y = 3280.671, z = 54.241},
			{x = 1729.216,  y = 6414.131, z = 34.037},
			{x = -48.519,   y = -1757.514, z = 28.421},
			{x = 1163.373,  y = -323.801,  z = 68.205},
			{x = -707.501,  y = -914.260,  z = 18.215},
			{x = -1820.523, y = 792.518,   z = 137.118},
			{x = 1698.388,  y = 4924.404,  z = 41.063},
			{x = 25.723,   y = -1346.966, z = 28.497}, 
        },
        Items = {
			{name = 'phone'},
            {name = 'bread'},
			{name = 'water'},
			{name = 'donut'},
			{name = 'sandwich'},
			{name = 'greenapple'},
			{name = 'bandage'},
			{name = 'firstaidkit'},
			{name = 'bait'},
			{name = 'notepad'},
			{name = 'lighter'},
			{name = 'cigarette'},
		}
	},

    RobsLiquor = {
		Locations = {
			{x = 1135.808,  y = -982.281,  z = 45.415},
			{x = -1222.915, y = -906.983,  z = 11.326},
			{x = -1487.553, y = -379.107,  z = 39.163},
			{x = -2968.243, y = 390.910,   z = 14.043},
			{x = 1166.024,  y = 2708.930,  z = 37.157},
			{x = 1392.562,  y = 3604.684,  z = 33.980},
			{x = -1393.409, y = -606.624,  z = 29.319}
        },
        Items = {
            {name = 'beer'},
            {name = 'wine'},
            {name = 'vodka'},
            {name = 'tequila'},
            {name = 'whisky'},
            {name = 'grand_cru'}
    }},

    YouTool = {
        Locations = {
			{x = 45.2,   y = -1748.43,  z = 28.6},
			{x = 2748.6,  y = 3473.14,  z = 54.70},
			{x = -3153.36, y = 1054.41,  z = 19.86}
        },
        Items = {
			{name =  'lockpick'},
			{name =  'binoculars'},
			{name =  'bulletproof'},
			{name =  'boltcutter'},
			{name =  'WEAPON_FLASHLIGHT'},
			{name =  'oxygen_mask'},
			{name =  'GADGET_PARACHUTE'},
			{name =  'pickaxe'},
			{name =  'fishingrod'},
			{name =  'radio'},
    	}},

    PrisonShop = {
        Locations = {
            {x = 460.17, y = -979.39, z = 30.69},
        },
        Items = {
			{ name = 'WEAPON_NIGHTSTICK' },
			{ name = 'WEAPON_FLASHLIGHT' },
			{ name = 'WEAPON_STUNGUN' },
			{ name = 'WEAPON_PISTOL_MK2' },
			{ name = 'WEAPON_COMBATPISTOL' },
			{ name = 'WEAPON_SMG' },
			{ name = 'WEAPON_ADVANCEDRIFLE' },
			{ name = 'WEAPON_PUMPSHOTGUN' },
			{ name = 'bulletproof' },
			{ name = 'disc_ammo_pistol' },
			{ name = 'disc_ammo_smg' },
			{ name = 'disc_ammo_rifle' },
			{ name = 'disc_ammo_shotgun' },
    }},

    WeaponShop = {
        Locations = {
            { x = -662.180, y = -934.961, z = 20.829 },
            { x = 810.25, y = -2157.60, z = 28.62 },
            { x = 1693.44, y = 3760.16, z = 33.71 },
            { x = -330.24, y = 6083.88, z = 30.45 },
            { x = 252.63, y = -50.00, z = 68.94 },
            { x = 22.09, y = -1107.28, z = 28.80 },
            { x = 2567.69, y = 294.38, z = 107.73 },
            { x = -1117.58, y = 2698.61, z = 17.55 },
            { x = 842.44, y = -1033.42, z = 27.19 },
        },
        Items = {
			{ name = 'WEAPON_BAT' },
			{ name = 'WEAPON_KNIFE' },
			{ name = 'WEAPON_PISTOL' },
			{ name = 'WEAPON_VINTAGEPISTOL' },
			{ name = 'WEAPON_SNSPISTOL' },
			{ name = 'disc_ammo_pistol' },
			{ name = 'disc_ammo_smg' },
			{ name = 'disc_ammo_rifle' },
			{ name = 'disc_ammo_shotgun' },
        }},
}

Config.Limit = 250000
Config.DefaultWeight = 0
Config.localWeight = {

	accesscard = 1000,
	acid = 10000,
	adrenaline = 1000,
	airbag = 1000,
	arepairkit = 20000,
	bait = 2000,
	bandage = 2000,
	bandage1 = 1000,
	bankidcard = 1000,
	battery = 1000,
	beer = 10000,
	binoculars = 1000,
	black_bills = 0000,
	blowpipe = 2000,
	blowtorch = 1000,
	blue_bills = 0000,
	bodykit = 10000,
	boltcutter = 10000,
	bread = 2000,
	bulletproof = 10000,
	bun = 2000,
	burnerphone = 10000,
	c4_bank = 1000,
	cannabis = 3000,
	card_death = 1000,
	card_famine = 1000,
	card_pestilence = 1000,
	card_war = 1000,
	carokit = 3000,
	carotool = 2000,
	cbrick = 10000,
	char = 1000,
	cheese = 2000,
	chickenburger = 10000,
	chickenpatty = 5000,
	chocolate = 5000,
	choppedcarparts = 10000,
	chopradio = 5000,
	cigarette = 5000,
	clip = 10000,
	cocacola = 10000,
	cocaine = 1000,
	coffee = 10000,
	coffeepowder = 5000,
	coke = 1000,
	contrat = 5000,
	copper = 2000,
	cprkit = 10000,
	crawfish = 2000,
	croquettes = 1000,
	cuffs = 5000,
	cuff_keys = 2000,
	darknet = 1000,
	diamond = 1000,
	dildo = 10000,
	disc_ammo_pistol = 2000,
	disc_ammo_pistol_large = 2000,
	disc_ammo_rifle = 6000,
	disc_ammo_rifle_large = 6000,
	disc_ammo_shotgun = 8000,
	disc_ammo_shotgun_large = 8000,
	disc_ammo_smg = 4000,
	disc_ammo_smg_large = 4000,
	disc_ammo_snp = 10000,
	disc_ammo_snp_large = 10000,
	donut = 2000,
	drill = 1000,
	electronics = 1000,
	energy = 5000,
	enginekit = 10000,
	firstaidkit = 10000,
	fishingpermit = 5000,
	fishingrod = 5000,
	fishpatty = 5000,
	fixkit = 3000,
	fixtool = 2000,
	fries = 2000,
	GADGET_PARACHUTE = 1000,
	gauze = 1000,
	gazbottle = 2000,
	glass = 2000,
	gold = 2000,
	goldbar = 15000,
	golden_satellite_phone = 10000,
	goldfish = 2000,
	golem = 5000,
	greenapple = 3000,
	green_bills = 0000,
	green_satellite_phone = 10000,
	hifi = 1000,
	highradio = 1000,
	highrim = 1000,
	hydrocodone = 1000,
	ice = 5000,
	icetea = 5000,
	ifak = 10000,
	iron = 2000,
	jager = 5000,
	jagerbomb = 5000,
	joint = 2000,
	jusfruit = 5000,
	lighter = 5000,
	limonade = 5000,
	lobster = 3000,
	lockpick = 5000,
	lowradio = 1000,
	mackerel = 1000,
	marijuana = 5000,
	martini = 5000,
	medikit = 2000,
	menthe = 10000,
	meth = 5000,
	metreshooter = 3000,
	milk = 5000,
	mimiburger = 12000,
	mixapero = 3000,
	mojito = 5000,
	morphine = 1000,
	notepad = 2000,
	opium = 1000,
	oxy = 1000,
	oxycutter = 5000,
	oxygen_mask = 5000,
	phone = 5000,
	pickaxe = 2000,
	pike = 1000,
	p_v_43_safe_s = 15000,
	radio = 5000,
	raspberry = 10000,
	red_bills = 0000,
	red_satellite_phone = 10000,
	Red_USB = 5000,
	repairkit = 5000,
	rhum = 5000,
	rhumcoca = 1000,
	rhumfruit = 1000,
	roach = 1000,
	safecracker = 5000,
	salmon = 1000,
	sandwich = 4000,
	sauce = 2000,
	saucisson = 5000,
	scrap = 2000,
	skateboard = 20000,
	soda = 1000,
	steel = 5000,
	stockrim = 1000,
	stones = 2000,
	suger = 1000,
	taco = 1000,
	tacomeet = 1000,
	tacopack = 1000,
	tea = 2000,
	teacup = 5000,
	tequila = 5000,
	thermite = 5000,
	trout = 1000,
	truckcard = 1000,
	tunerchip = 15000,
	vegburger = 10000,
	veggies = 2000,
	vegpatty = 5000,
	vicodin = 1000,
	vodka = 5000,
	vodkaenergy = 5000,
	washedstones = 2000,
	water = 2000,
	WEAPON_ADVANCEDRIFLE = 1000,
	WEAPON_APPISTOL = 1000,
	WEAPON_ASSAULTRIFLE = 1000,
	WEAPON_ASSAULTSHOTGUN = 1000,
	WEAPON_ASSAULTSMG = 1000,
	WEAPON_AUTOSHOTGUN = 1000,
	WEAPON_BALL = 1000,
	WEAPON_BAT = 1000,
	WEAPON_BATTLEAXE = 1000,
	WEAPON_BOTTLE = 1000,
	WEAPON_BULLPUPRIFLE = 1000,
	WEAPON_BULLPUPSHOTGUN = 1000,
	WEAPON_BZGAS = 1000,
	WEAPON_CARBINERIFLE = 1000,
	WEAPON_CARBINERIFLE_MK2 = 1000,
	WEAPON_COMBATMG = 1000,
	WEAPON_COMBATPDW = 1000,
	WEAPON_COMBATPISTOL = 15000,
	WEAPON_COMPACTLAUNCHER = 1000,
	WEAPON_COMPACTRIFLE = 20000,
	WEAPON_CROWBAR = 1000,
	WEAPON_DAGGER = 1000,
	WEAPON_DBSHOTGUN = 1000,
	WEAPON_DIGISCANNER = 1000,
	WEAPON_DOUBLEACTION = 1000,
	WEAPON_FIREEXTINGUISHER = 1000,
	WEAPON_FIREWORK = 1000,
	WEAPON_FLARE = 1000,
	WEAPON_FLAREGUN = 1000,
	WEAPON_FLASHLIGHT = 1000,
	WEAPON_GARBAGEBAG = 1000,
	WEAPON_GOLFCLUB = 1000,
	WEAPON_GRENADE = 1000,
	WEAPON_GRENADELAUNCHER = 1000,
	WEAPON_GUSENBERG = 1000,
	WEAPON_HAMMER = 1000,
	WEAPON_HANDCUFFS = 1000,
	WEAPON_HATCHET = 1000,
	WEAPON_HEAVYPISTOL = 1000,
	WEAPON_HEAVYSHOTGUN = 20000,
	WEAPON_HEAVYSNIPER = 1000,
	WEAPON_HOMINGLAUNCHER = 1000,
	WEAPON_KNIFE = 1000,
	WEAPON_KNUCKLE = 1000,
	WEAPON_MACHETE = 1000,
	WEAPON_MACHINEPISTOL = 1000,
	WEAPON_MARKSMANPISTOL = 1000,
	WEAPON_MARKSMANRIFLE = 1000,
	WEAPON_MG = 1000,
	WEAPON_MICROSMG = 1000,
	WEAPON_MINIGUN = 1000,
	WEAPON_MINISMG = 1000,
	WEAPON_MOLOTOV = 1000,
	WEAPON_MUSKET = 1000,
	WEAPON_NIGHTSTICK = 1000,
	WEAPON_PETROLCAN = 1000,
	WEAPON_PISTOL = 0000,
	WEAPON_PISTOL50 = 15000,
	WEAPON_POOLCUE = 1000,
	WEAPON_PROXMINE = 1000,
	WEAPON_PUMPSHOTGUN = 20000,
	WEAPON_RAILGUN = 1000,
	WEAPON_REVOLVER = 1000,
	WEAPON_SAWNOFFSHOTGUN = 1000,
	WEAPON_SMG = 1000,
	WEAPON_SMOKEGRENADE = 1000,
	WEAPON_SNIPERRIFLE = 1000,
	WEAPON_SNOWBALL = 1000,
	WEAPON_SNSPISTOL = 1000,
	WEAPON_SPECIALCARBINE = 1000,
	WEAPON_STICKYBOMB = 1000,
	WEAPON_STINGER = 1000,
	WEAPON_STUNGUN = 1000,
	WEAPON_SWITCHBLADE = 1000,
	WEAPON_VINTAGEPISTOL = 1000,
	WEAPON_WRENCH = 1000,
	weed = 2000,
	whisky = 5000,
	whiskycoca = 5000,
	whitefish = 2000,
	windowkit = 10000,
	wine = 10000,
	wire = 2000,
	xanax = 1000,
	yellow_bills = 0000000,
}

Config.VehicleLimit = {
    [0] = 300000, --Compact
    [1] = 400000, --Sedan
    [2] = 500000, --SUV
    [3] = 250000, --Coupes
    [4] = 300000, --Muscle
    [5] = 300000, --Sports Classics
    [6] = 300000, --Sports
    [7] = 300000, --Super
    [8] = 25000, --Motorcycles
    [9] = 300000, --Off-road
    [10] = 300000, --Industrial
    [11] = 70000, --Utility
    [12] = 600000, --Vans
    [13] = 0, --Cycles
    [14] = 0, --Boats
    [15] = 0, --Helicopters
    [16] = 0, --Planes
    [17] = 0, --Service
    [18] = 0, --Emergency
    [19] = 0, --Military
    [20] = 600000, --Commercial
    [21] = 0 --Trains
}

Config.VehiclePlate = {
    taxi = "TAXI",
    cop = "LSPD",
    ambulance = "EMS0",
    mecano = "MECA"
}
