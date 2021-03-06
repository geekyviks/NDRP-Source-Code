Config = {}

Config.JailPositions = {
	["Cell"] = { ["x"] = 1799.8345947266, ["y"] = 2489.1350097656, ["z"] = -119.02998352051, ["h"] = 179.03021240234 }
}

Config.Cutscene = {
	["PhotoPosition"] = { ["x"] = 402.91567993164, ["y"] = -996.75970458984, ["z"] = -99.000259399414, ["h"] = 186.22499084473 },

	["CameraPos"] = { ["x"] = 402.88830566406, ["y"] = -1003.8851318359, ["z"] = -97.419647216797, ["rotationX"] = -15.433070763946, ["rotationY"] = 0.0, ["rotationZ"] = -0.31496068835258, ["cameraId"] = 0 },

	["PolicePosition"] = { ["x"] = 402.91702270508, ["y"] = -1000.6376953125, ["z"] = -99.004028320313, ["h"] = 356.88052368164 }
}

Config.JobPos = {
	{x = 1664.89, y = 2501.37, z = 44.56},
	{x = 1679.82, y = 2480.58, z = 44.56},
	{x = 1718.72, y = 2527.9, z = 44.56},
	{x = 1761.58, y = 2540.11, z = 44.57},
	{x = 1627.92, y = 2538.33, z = 44.56},
	{x = 1652.51, y = 2563.66, z = 44.56},
	{x = 1737.38, y = 2504.89, z = 44.57}
}

Config.Teleports = {
	["Prison Work"] = { 
		["x"] = 1636.24,
		["y"] = 2565.62,
		["z"] = 45.56,
		["h"] = 177.94,
		["goal"] = { 
			"Jail",
			"Visitor"
		} 
	},

	["Boiling Broke"] = { 
		["x"] = 1845.6022949219, 
		["y"] = 2585.8029785156, 
		["z"] = 45.672061920166,
		["h"] = 92.469093322754, 
		["goal"] = { 
			"Security" 
		} 
	},

	["Jail"] = { 
		["x"] = 1800.6979980469, 
		["y"] = 2483.0979003906, 
		["z"] = -122.68814849854, 
		["h"] = 271.75274658203, 
		["goal"] = { 
			"Prison Work", 
			--"Security",
			"Visitor" 
		} 
	},

	["Security"] = {
		["x"] = 1706.7625732422,
		["y"] = 2581.0793457031,
		["z"] = -69.407371520996,
		["h"] = 267.72802734375,
		["goal"] = {
			"Boiling Broke"
		}
	},

	["Visitor"] = {
		["x"] = 1699.7196044922, 
		["y"] = 2574.5314941406, 
		["z"] = -69.403930664063, 
		["h"] = 169.65020751953, 
		["goal"] = { 
			"Jail",
			"Prison Work"
		} 
	},

	["Unjail"] = {
		["x"] = 1765.65,
		["y"] = 2565.76,
		["z"] = 45.57,
		["h"] = 184.45,
		["goal"] = {
			"Boiling Broke"
		}
	}
}