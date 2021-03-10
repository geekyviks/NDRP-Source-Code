Config = {
    Camera = true,
    LoseConnectionDistance = 100.0
}

Config.CooldownPolice = 1000
Config.cooldown		  = 2000

Config.Weapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_FLAREGUN",
	"WEAPON_STUNGUN",
	"WEAPON_REVOLVER",
}

maxDice = 6						-- Maximum number of dice to roll			Default = 6
maxDiceSides = 100				-- Maximum number of sides on dice			Default = 100
rpsPrefix = "Showed: "			-- Rock, Paper, Scissors result prefix		Default = "Showed: "
flipPrefix = "Flipped: "		-- Flip Coin result prefix					Default = "Flipped: "
rollPrefix = "Rolled: "			-- Roll Dice result prefix					Default = "Rolled: "

Config.Logouts = {
	vector3(-211.96571350098,-1034.4597167969,30.139377593994)
}

Config.beanmachine = {
	vector3(-629.74,241.71,81.89)
}

Config.courthouse = {
	vector3(416.15,-1084.79,30.06)
}

Config.bahamas = {
	vector3(-1388.8,-587.25,30.22)
}

Config.news = {
	vector3(-601.55,-929.36,23.86)
}

Config.Locale = 'en'

Config['CancelAnimation'] = 105
Config['PoleDance'] = { -- allows you to pole dance at the strip club, you can of course add more locations if you want.
    ['Enabled'] = true,
    ['Locations'] = {
        {['Position'] = vector3(112.60, -1286.76, 28.56), ['Number'] = '3'},
        {['Position'] = vector3(104.18, -1293.94, 29.26), ['Number'] = '1'},
        {['Position'] = vector3(102.24, -1290.54, 29.26), ['Number'] = '2'}
    }
}

Config.TackleDistance				= 3.0