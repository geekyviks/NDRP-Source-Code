Config = {}
Config.Locale = 'en'

Config.Draw3DText = "~r~Locked~r~"
Config.Draw3DTexts = "Press ~g~[E]~s~ for ~y~Unlock~s~"

Config.DoorList = {

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = false,
		distance = 2.0,
		doors = {
			{
				objName = 'v_ilev_ph_door01',
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = 'v_ilev_ph_door002',
				objYaw = -90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},

	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objYaw = 90.0,
		objCoords  = vector3(449.6, -986.4, 30.6),
		textCoords = vector3(450.1, -986.3, 31.7),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objYaw = 90.0,
		objCoords  = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.3, -984.0, 44.8),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 90.0,
		objCoords  = vector3(461.2, -985.3, 30.8),
		textCoords = vector3(461.5, -986.0, 31.5),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -90.0,
		objCoords  = vector3(452.6, -982.7, 30.6),
		textCoords = vector3(453.0, -982.6, 31.7),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -180.0,
		objCoords  = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.2, -980.0, 31.7),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- To downstairs (double doors)
	{
		textCoords = vector3(444.6, -989.4, 31.7),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = true,
		distance = 2.0,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 180.0,
				objCoords = vector3(443.9, -989.0, 30.6)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 0.0,
				objCoords = vector3(445.3, -988.7, 30.6)
			}
		}
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(463.8, -992.6, 24.9),
		textCoords = vector3(463.3, -992.6, 25.1),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(463.4, -1003.5, 25.0),
		textCoords = vector3(464.0, -1003.5, 25.5),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	
	
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 180.0,
		objCoords  = vector3(468.49, -998.19, 25.0),
		textCoords = vector3(468.49, -998.19, 25.5),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

		{
		objName = 'v_ilev_gtdoor',
		objYaw = 180.0,
		objCoords  = vector3(471.26, -997.38, 25.0),
		textCoords = vector3(471.26, -997.38, 25.5),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 180.0,
		objCoords  = vector3(474.04, -997.38, 25.0),
		textCoords = vector3(474.04, -997.38, 25.5),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

		{
		objName = 'v_ilev_gtdoor',
		objYaw = 180.0,
		objCoords  = vector3(477.06, -997.42, 25.0),
		textCoords = vector3(477.06, -997.42, 25.5),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	
		{
		objName = 'v_ilev_gtdoor',
		objYaw = 180.0,
		objCoords  = vector3(479.6, -998.02, 25.0),
		textCoords = vector3(479.6, -998.02, 25.5),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	
		{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(467.42, -1003.37, 25.0),
		textCoords = vector3(467.42, -1003.37, 25.5),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	--
	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = true,
		distance = 2.0,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objYaw = 30.0,
		objCoords  = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = false,
		distance = 2.0,
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = false,
		distance = 2.0,
		doors = {
			{
				objName = 'v_ilev_shrf2door',
				objYaw = -45.0,
				objCoords  = vector3(-443.1, 6015.6, 31.7),
			},

			{
				objName = 'v_ilev_shrf2door',
				objYaw = 135.0,
				objCoords  = vector3(-443.9, 6016.6, 31.7)
			}
		}
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = true,
		distance = 12,
		size = 2
	},
	

	
	-- Double doors for extended PD
	{
	        textCoords = vector3(465.55, -990.00, 25.00),
	        authorizedJobs = { 'police' , 'offpolice'},
	        locked = true,
	        distance = 2.0,
	        doors = {
		{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 90.0,
		objCoords = vector3(465.55, -989.45, 24.91)
		},

		{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = -90.0,
		objCoords = vector3(465.60, -990.63, 24.91)
		}
	}
	},
	
	
--[[
	Cell 4 (Left 1)
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(466.03, -998.55, 24.9149),
		textCoords = vector3(466.02, -998.75, 25.064),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Cell 5 (Left 2)
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(466.12, -1002.16, 24.9149),
		textCoords = vector3(466.02, -1002.35, 25.064),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
]]--
	-- Interrogation wing cell left
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(482.02, -988.35, 24.91),
		textCoords = vector3(481.6, -988.35, 25.064),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- Interrogation wing cell right
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(481.86, -991.61, 24.91),
		textCoords = vector3(481.46, -991.61, 25.064),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},

	-- To interrogation observation room left
	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = vector3(472.01, -988.3, 24.91),
		textCoords = vector3(472.01, -988.3, 24.91),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	-- To interrogation room left
	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = vector3(477.52, -988.44, 24.91),
		textCoords = vector3(477.52, -988.44, 24.91),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	-- To interrogation observation room right
	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = vector3(472.02, -991.62, 24.91),
		textCoords = vector3(472.02, -991.62, 24.91),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	-- To interrogation room right
	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = vector3(477.56, -991.56, 24.91),
		textCoords = vector3(477.56, -991.56, 24.91),
		authorizedJobs = { 'police' , 'offpolice'},
		distance = 2.0,
		locked = true
	},
	
	-- principal bank
	{
		objName = 'hei_v_ilev_bk_gate2_pris',
		objCoords  = vector3(261.99899291992, 221.50576782227, 106.68346405029),
		textCoords = vector3(261.99899291992, 221.50576782227, 107.68346405029),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = true,
		distance = 2.0,
		size = 2
	},

	{
		objName = 'hei_prop_station_gate',
		objCoords = vector3(411.20,-1026.06, 29.40),
		textCoords = vector3(411.20,-1026.06, 29.40),
		authorizedJobs = { 'police' , 'offpolice'},
		locked = true,
		distance = 10,
		size = 2
	},

	
	--Sidewalk Door to Parking Lot
	
	{
	objName = 'hei_prop_bh1_08_hdoor',
	objCoords = vector3(419.73,-1018.68, 29.24),
	textCoords = vector3(419.03,-1017.71, 29.51),
	authorizedJobs = { 'police' , 'offpolice'},
	locked = true,
	distance = 2
	},
	
	--Side gate to parking lot
	
	{
	objName = 'v_ilev_cbankvaulgate01',
	objCoords = vector3(423.05,-992.00, 30.71),
	textCoords = vector3(423.78,-991.43, 30.71),
	authorizedJobs = { 'police' , 'offpolice'},
	locked = true,
	distance = 2
	},
	
	-- Pillbox
	-- locker room
	{
		objName = 'gabz_pillbox_singledoor',
		objCoords = vector3(303.39,-597.53, 43.28),
		textCoords = vector3(303.39,-597.53, 44.00),
		authorizedJobs = { 'ambulance' , 'offambulance'},
		locked = true,
		distance = 2
	},

	-- Pharmacy

	{
		objName = 'gabz_pillbox_singledoor',
		objCoords = vector3(308.00,-570.00, 43.28),
		textCoords = vector3(308.00,-570.00, 44.00),
		authorizedJobs = { 'ambulance' , 'police' , 'offpolice', 'offambulance'},
		locked = true,
		distance = 2
	},


	{
		objName = 'gabz_pillbox_singledoor',
		objCoords = vector3(337.28,-580.00, 43.28),
		textCoords = vector3(337.28,-580.00, 44.00),
		authorizedJobs = { 'ambulance' , 'police' , 'offpolice', 'offambulance'},
		locked = true,
		distance = 3
	},

	{
		objName = 'gabz_pillbox_singledoor',
		objCoords = vector3(339.8,-587.00, 43.28),
		textCoords = vector3(339.8,-587.00, 44.00),
		authorizedJobs = { 'ambulance' , 'police' , 'offpolice', 'offambulance'},
		locked = true,
		distance = 3
	},

	{
		objName = 'gabz_pillbox_singledoor',
		objCoords = vector3(341.72,-581.46, 43.28),
		textCoords = vector3(341.72,-581.46, 44.00),
		authorizedJobs = { 'ambulance' , 'police' , 'offpolice', 'offambulance'},
		locked = true,
		distance = 3
	},

	{
		objName = 'gabz_pillbox_singledoor',
		objCoords = vector3(347.8,-583.66, 43.28),
		textCoords = vector3(347.8,-583.66, 44.00),
		authorizedJobs = { 'ambulance' , 'police' , 'offpolice', 'offambulance'},
		locked = true,
		distance = 3
	},

	-- wardrobe
	{
		objName = 'gabz_pillbox_singledoor',
		objCoords = vector3(304.21,-571.56, 43.28),
		textCoords = vector3(304.21,-571.56, 44.00),
		authorizedJobs = { 'ambulance' , 'police' , 'offpolice', 'offambulance'},
		locked = true,
		distance = 2
	},

	-- reception

	{
		objName = 'gabz_pillbox_singledoor',
		objCoords = vector3(313.58,-596.00, 43.28),
		textCoords = vector3(313.58,-596.00, 44.00),
		authorizedJobs = { 'ambulance' , 'police' , 'offpolice', 'offambulance'},
		locked = true,
		distance = 2
	},



--[[	{
		textCoords = vector3(312.9, -571.50, 43.28),
		authorizedJobs = { 'ambulance' , 'police' , 'offpolice', 'offambulance'},
		locked = false,
		distance = 2.0,
		doors = {
			{
				objName = 'gabz_pillbox_doubledoor_l',
				objYaw = -90.0,
				objCoords = vector3(313.27, -571.65, 43.28)
			},

			{
				objName = 'gabz_pillbox_doubledoor_r',
			--	objYaw = -90.0,
				objCoords = vector3(313.68, -571.65, 43.28)
			}
		}
	}, ]]--

	
}