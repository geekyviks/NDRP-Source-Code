Config = {}
Config.EnableMeatSell = false --if using fivem_hunting set to true
Config.Fishes = {
	['salmon'] = { 
		['name'] = 'salmon',
		['label'] = 'Salmon',
		['price'] = 200,
		['value'] = 60/1000,
		['weight'] = {18000, 42000},
	},
	['trout'] = { 
		['name'] = 'trout',
		['label'] = 'Trout',
		['price'] = 125,
		['value'] = 75/1000,
		['weight'] = {1400, 2100},
	},
	['char'] = { 
		['name'] = 'char',
		['label'] = 'Char',
		['price'] = 150,
		['value'] = 75/1000,
		['weight'] = {800,1200},
	},
	['pike'] = { 
		['name'] = 'pike',
		['label'] = 'Pike',
		['price'] = 125,
		['value'] = 80/1000,
		['weight'] = {1500,5000},
	},
	['goldfish'] = {
		['name'] = 'goldfish',
		['label'] = 'goldfish from the Ark Zoo',
		['price'] = 250,
		['value'] = 50/1000,
		['weight'] = {150, 400},
	},
	['whitefish'] = { 
		['name'] = 'whitefish',
		['label'] = 'White Fish',
		['price'] = 75,
		['value'] = 90/1000,
		['weight'] = {4000,5500},
	},
	['roach'] = { 
		['name'] = 'roach',
		['label'] = 'Roach',
		['price'] = 50,
		['value'] = 99/1000,
		['weight'] = {200, 700},
	},
	['mackerel'] = { 
		['name'] = 'mackerel',
		['label'] = 'Mackerel',
		['price'] = 50,
		['value'] = 99/1000,
		['weight'] = {750,1250},
	},
	['lobster'] = { 
		['name'] = 'lobster',
		['label'] = 'Lobster',
		['price'] = 250,
		['value'] = 60/1000,
		['weight'] = {500,1200},
	},
	['crawfish'] = { 
		['name'] = 'crawfish',
		['label'] = 'Craw Fish',
		['price'] = 100,
		['value'] = 70/1000,
		['weight'] = {150,450},
	},
}

Config.Locations = {
	--los_santos_pier
	{ ["x"] = -1729.4377441406, ["y"] = -1127.0867919922, ["z"] = 13.019190788269, ["h"] = 145.40907287598 , ['position'] = 'los_santos_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -1726.8502197266, ["y"] = -1129.3839111328, ["z"] = 13.019768714905, ["h"] = 138.55718994141 , ['position'] = 'los_santos_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -1726.8502197266, ["y"] = -1129.3839111328, ["z"] = 13.019768714905, ["h"] = 138.55718994141 , ['position'] = 'los_santos_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -1723.5467529297, ["y"] = -1132.3701171875, ["z"] = 13.02321434021, ["h"] = 132.00126647949  , ['position'] = 'los_santos_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -1721.6689453125, ["y"] = -1133.9752197266, ["z"] = 13.022834777832, ["h"] = 141.25 			, ['position'] = 'los_santos_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -1719.8568115234, ["y"] = -1135.5460205078, ["z"] = 13.022346496582, ["h"] = 152.62545776367 , ['position'] = 'los_santos_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -1716.3084716797, ["y"] = -1138.0594482422, ["z"] = 13.025685310364, ["h"] = 144.79898071289 , ['position'] = 'los_santos_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -1713.6912841797, ["y"] = -1140.29296875, ["z"] = 13.026702880859, ["h"] = 140.90113830566   , ['position'] = 'los_santos_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	--chumash_pier
	{ ["x"] = -3428.3122558594, ["y"] = 978.115234375, ["z"] = 8.3466930389404, ["h"] = 97.40372467041, ['position'] = 'chumash_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -3428.3212890625, ["y"] = 975.34222412109, ["z"] = 8.3466930389404, ["h"] = 99.886077880859, ['position'] = 'chumash_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -3428.37109375, 	["y"] = 969.92846679688, ["z"] = 8.3466930389404, ["h"] = 90.673683166504  ,   ['position'] = 'chumash_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -3428.2888183594, ["y"] = 964.50463867188, ["z"] = 8.3466930389404, ["h"] = 102.70695495605, ['position'] = 'chumash_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -3428.34375, 		["y"] = 961.73101806641, ["z"] = 8.3466930389404, ["h"] = 99.787033081055 , ['position'] = 'chumash_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -3428.4411621094, ["y"] = 959.00384521484, ["z"] = 8.3466930389404, ["h"] = 99.604385375977, ['position'] = 'chumash_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = -3428.0061035156, ["y"] = 951.81207275391, ["z"] = 8.3466930389404, ["h"] = 182.38989257813, ['position'] = 'chumash_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	--paleto_cove
	{ ["x"] = -1612.8624267578, ["y"] = 5262.5766601563, ["z"] = 3.9741015434265, ["h"] = 32.252586364746, ['position'] = 'paleto_cove', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike' }},
	{ ["x"] = -1609.9715576172, ["y"] = 5263.7978515625, ["z"] = 3.9741015434265, ["h"] = 29.007883071899, ['position'] = 'paleto_cove', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike' }},
	{ ["x"] = -1608.0836181641, ["y"] = 5264.4345703125, ["z"] = 3.9741015434265, ["h"] = 26.154483795166, ['position'] = 'paleto_cove', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike' }},
	{ ["x"] = -1615.0227050781, ["y"] = 5259.94140625, ["z"] = 3.9741013050079, ["h"] = 116.21309661865, ['position'] = 'paleto_cove', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike' }},	
	--lighthouse
	{ ["x"] = 3867.396484375,  ["y"] = 4462.6284179688, ["z"] = 2.7240386009216, ["h"] = 277.77474975586, ['position'] = 'lighthouse', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'  }},
	{ ["x"] = 3867.5285644531, ["y"] = 4464.6274414063, ["z"] = 2.7235767841339, ["h"] = 279.59808349609, ['position'] = 'lighthouse', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike' }},
	{ ["x"] = 3864.7697753906, ["y"] = 4464.955078125, ["z"] = 2.7239830493927, ["h"] = 358.49795532227, ['position'] = 'lighthouse', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'  }},
	{ ["x"] = 3863.4357910156, ["y"] = 4462.3823242188, ["z"] = 2.7179083824158, ["h"] = 178.42832946777, ['position'] = 'lighthouse', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike' }},
	--yacht
	{ ["x"] = -2099.880859375, ["y"] = -1019.5953979492, ["z"] = 8.9719743728638, ["h"] = 173.36888122559 , ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2101.1896972656, ["y"] = -1019.430480957, ["z"] = 8.9721012115479, ["h"] = 176.15567016602 , ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2102.7956542969, ["y"] = -1018.7056274414, ["z"] = 8.972020149231, ["h"] = 170.82302856445 , ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2104.0944824219, ["y"] = -1018.2451782227, ["z"] = 8.972017288208, ["h"] = 167.18406677246 , ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2108.5554199219, ["y"] = -1016.1299438477, ["z"] = 8.9757413864136, ["h"] = 153.23072814941, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2097.7221679688, ["y"] = -1007.4663696289, ["z"] = 8.9720001220703, ["h"] = 351.70599365234, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2095.4926757813, ["y"] = -1008.4398803711, ["z"] = 8.9720239639282, ["h"] = 356.3512878418 , ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2071.4931640625, ["y"] = -1015.9486083984, ["z"] = 11.907350540161, ["h"] = 337.93405151367, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2069.3361816406, ["y"] = -1016.6315307617, ["z"] = 11.907382011414, ["h"] = 352.14434814453, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2067.5139160156, ["y"] = -1017.4236450195, ["z"] = 11.907388687134, ["h"] = 353.67492675781, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2063.9670410156, ["y"] = -1018.6361694336, ["z"] = 11.907437324524, ["h"] = 341.93673706055, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2053.9118652344, ["y"] = -1021.6297607422, ["z"] = 11.907551765442, ["h"] = 3.1917054653168, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2058.5844726563, ["y"] = -1033.3400878906, ["z"] = 11.907543182373, ["h"] = 183.70986938477, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2068.3564453125, ["y"] = -1030.0098876953, ["z"] = 11.907423019409, ["h"] = 168.48794555664, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	{ ["x"] = -2072.4353027344, ["y"] = -1028.5858154297, ["z"] = 11.907382011414, ["h"] = 168.54730224609, ['position'] = 'yacht', ['fishes'] = {'goldfish', 'lobster', 'crawfish', 'salmon', 'char','trout' }},--klar
	--alamo_sea_pier
	{ ["x"] = 1299.3134765625, ["y"] = 4215.7846679688, ["z"] = 33.908641815186, ["h"] = 174.91044616699, ['position'] = 'alamo_sea_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike' }},
	{ ["x"] = 1297.1314697266, ["y"] = 4216.3129882813, ["z"] = 33.908641815186, ["h"] = 163.02433776855 , ['position'] = 'alamo_sea_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike'}},
	{ ["x"] = 1297.3391113281, ["y"] = 4220.041015625, ["z"] = 33.908641815186, ["h"] = 85.019096374512, ['position'] = 'alamo_sea_pier', ['fishes'] = {'mackerel', 'roach', 'whitefish', 'goldfish', 'trout', 'pike' }},
	--train_passage
	{ ["x"] = -508.62612915039, ["y"] = 4423.892578125, ["z"] = 89.636611938477, ["h"] = 286.16461181641, ['position'] = 'train_passage', ['fishes'] = {'salmon', 'goldfish'}},--klar
	--mountain_river
	{ ["x"] = -860.48669433594, ["y"] = 4437.5122070313, ["z"] = 15.219162940979, ["h"] = 228.95330810547, ['position'] = 'mountain_river', ['fishes'] = {'goldfish', 'lobster', 'crawfish' }},--klar
	{ ["x"] = -858.78533935547, ["y"] = 4422.0859375, ["z"] = 15.249315261841, ["h"] = 342.44134521484, ['position'] = 'mountain_river', ['fishes'] = {'goldfish', 'lobster', 'crawfish' }},--klar
	{ ["x"] = -809.44799804688, ["y"] = 4434.94140625, ["z"] = 15.266304016113, ["h"] = 339.81692504883, ['position'] = 'mountain_river', ['fishes'] = {'goldfish', 'lobster', 'crawfish' }},--klar
	{ ["x"] = 949.06500244141, ["y"] = -1733.3645019531, ["z"] = 31.641366958618, ["h"] = 102.24913787842,  ['position'] = 'sell' },
}
