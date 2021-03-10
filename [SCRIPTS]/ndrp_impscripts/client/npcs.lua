Citizen.CreateThread(function()
	DensityMultiplier = 0.1
	while true do
		Citizen.Wait(0)
		SetVehicleModelIsSuppressed(GetHashKey("rubble"), true)
		SetVehicleModelIsSuppressed(GetHashKey("taco"), true)
		SetVehicleModelIsSuppressed(GetHashKey("biff"), true)
		SetVehicleModelIsSuppressed(GetHashKey("trash"), true)
		SetVehicleModelIsSuppressed(GetHashKey("trash2"), true)
		local pPed = PlayerPedId()
		local playerCoords = GetEntityCoords(pPed)
		local distSouth = #(vector3(106.93, -1940.49, 20.8) - playerCoords)
		local distBikers = #(vector3(946.5, -157.56, 74.55) - playerCoords)
		local distMrrPark = #(vector3(1131.68, -534.97, 63.73) - playerCoords)
		if distSouth < 500 or distBikers < 100 or distMrrPark < 250 then
			
			if (distBikers < 100 and not bikersSpawned) then
				local hash = GetHashKey( "g_m_y_lost_01" )
				if not HasModelLoaded(hash) then
					RequestModel(hash)
					Wait(200)
				end
				local ped = CreatePed( PED_TYPE_GANG_BIKER_1, hash, 956.19, -138.63, 73.48, 150.6, false, true )
				local ped2 = CreatePed( PED_TYPE_GANG_BIKER_1, hash, 962.90, -142.63, 73.51, 150.6, false, true )
				FreezeEntityPosition(ped, true)
				SetEntityInvincible(ped, true)
				SetBlockingOfNonTemporaryEvents(ped, true)
				FreezeEntityPosition(ped2, true)
				SetEntityInvincible(ped2, true)
				SetBlockingOfNonTemporaryEvents(ped2, true)
				local WeaponHash = GetHashKey( "WEAPON_PISTOL" )
				GiveWeaponToPed(ped, WeaponHash, 20, true, true )
				GiveWeaponToPed(ped2, WeaponHash, 20, true, true )
				bikersSpawned = true
			end
			
			SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
			SetPedDensityMultiplierThisFrame(1.0)
			SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
			SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
			SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)
		else
			SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
			SetPedDensityMultiplierThisFrame(0.3)
			SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
			SetParkedVehicleDensityMultiplierThisFrame(0.3)
			SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		RemoveIpl("rc12b_fixed")
		RemoveIpl("rc12b_destroyed")
		RemoveIpl("rc12b_default")
		RemoveIpl("rc12b_hospitalinterior_lod")
		RemoveIpl("rc12b_hospitalinterior")
	end
end)