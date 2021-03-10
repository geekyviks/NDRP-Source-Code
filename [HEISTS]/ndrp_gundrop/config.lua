Config              = { Locale = "en" }
Config.DrawDistance = 30.0
Config.MarkerType   = 20
Config.MarkerSize   = { x = 0.7, y = 0.7, z = 0.7 }
Config.MarkerColor  = { r = 51, g = 51, b = 255 }
Config.Marker = {
    {
        name = 'machinepistol',
        puzzle = vector3(261.18, -1783.73, 27.11),
        craft = vector3(845.39, -951.6, 26.52),
        material = {electronics = 50, wire = 10, scrap = 50, money = 10000}
    },
    {
        name = 'heavypistol',
        puzzle = vector3(-815.04, -957.69, 15.47),
        craft = vector3(-32.45, -184.6, 53.73),
        material = {electronics = 30, wire = 2, scrap = 50, money = 3500}
    },
    {
        name = 'appistol',
        puzzle = vector3(-719.7, -410.9, 34.98),
        craft = vector3(853.33, -2120.45, 30.58),
        material = {electronics = 40, wire = 7, scrap = 50, money = 7500}
    },
}

Config.Satellite = {
    enter = vector3(-1335.16, -199.23, 43.76),
    exit = vector3(1173.77, -3196.63, -39.01),
    marker = vector3(1162.73, -3196.38, -39.01),
    red = {
        weapon = 'WEAPON_ASSAULTRIFLE',
        price = 75000
    },
    golden = {
        weapon = 'WEAPON_CARBINERIFLE',
        price = 120000
    },
    green = {
        weapon = 'WEAPON_ASSAULTSMG',
        price = 50000
    },
}
