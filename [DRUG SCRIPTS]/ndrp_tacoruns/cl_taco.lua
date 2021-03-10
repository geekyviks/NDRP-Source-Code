ESX = nil

local inMission = false
local MissionCoords = false
local Mblip = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end
end)
    
local locations = { -- Random Delivers Location Config 
    vector4(-212.88, -1618.16, 34.87, 183.45),
    vector4(-223.15, -1617.6, 34.87, 90.52),
    vector4(-223.15, -1601.2, 34.88, 89.98),
    vector4(-223.06, -1585.81, 34.87, 96.12),
    vector4(-219.32, -1579.92, 34.87, 56.45),
    vector4(-215.66, -1576.28, 34.87, 328.55),
    vector4(-208.74, -1600.64, 34.87, 262.82),
    vector4(-210.01, -1607.03, 34.87, 258.99),
    vector4(-205.7, -1585.59, 38.05, 261.13),
    vector4(-215.73, -1576.32, 38.05, 318.59),
    vector4(-219.29, -1579.92, 38.05, 57.37),
    vector4(-223.09, -1585.89, 38.05, 84.95),
    vector4(-223.07, -1601.14, 38.05, 91.67),
    vector4(-223.08, -1617.59, 38.06, 100.36),
    vector4(-212.1, -1617.63, 38.05, 253.22),
    vector4(-209.96, -1607.11, 38.05, 262.46),
    vector4(-208.63, -1600.57, 38.05, 264.01),
    vector4(-160.08, -1636.25, 34.03, 319.31),
    vector4(-161.1, -1638.77, 34.03, 139.27),
    vector4(-161.66, -1638.4, 37.25, 142.38),
    vector4(159.96, -1636.3, 37.25, 326.86),
    vector4(-150.35, -1625.66, 33.66, 235.2),
    vector4(-151.32, -1622.34, 33.65, 56.46),
    vector4(-144.95, -1618.58, 36.05, 230.86),
    vector4(-152.42, -1623.58, 36.85, 51.96),
    vector4(-150.36, -1625.62, 36.85, 236.43),
    vector4(20.43, -1505.37, 31.85, 54.24),
    vector4(-1098.15, -345.84, 37.8, 355.64),
    vector4(-1102.43, -367.91, 37.78, 211.79),
    vector4(365.12, -2064.71, 21.74, 231.7),
    vector4(-1112.61, -355.77, 37.8, 86.28),
    vector4(-1077.63, -354.84, 37.8, 204.43),
    vector4(-930.84, -214.46, 38.55, 265.65),
    vector4(-783.65, -390.64, 37.33, 334.83),
    vector4(-733.45, -317.38, 36.55, 343.73),
    vector4(-1200.24, -156.96, 40.09, 193.64),
    vector4(-1440.64, -174.37, 47.7, 93.43),
    vector4(-336.23, 30.89, 47.86, 258.93),
    vector4(-338.85, 21.43, 47.86, 258.64),
    vector4(-345.18, 17.91, 47.86, 168.13),
    vector4(-360.45, 20.89, 47.86, 174.26),
    vector4(-371.42, 23.1, 47.86, 178.76),
    vector4(-362.25, 57.76, 54.43, 2.21),
    vector4(-350.59, 57.74, 54.43, 359.38),
    vector4(-344.57, 57.55, 54.43, 354.84),
    vector4(-333.07, 57.1, 54.43, 354.49),
    vector4(-483.53, -18.08, 45.09, 176.3),
    vector4(-492.97, -17.99, 45.06, 177.8),
    vector4(-500.47, -19.27, 45.13, 218.85),
    vector4(-569.88, 169.57, 66.57, 85.5),
    vector4(-476.72, 217.54, 83.7, 177.98),
    vector4(-310.15, 221.54, 87.93, 194.03),
    vector4(-169.9, 285.42, 93.76, 355.38),
    vector4(57.58, 449.66, 147.03, 151.65),
    vector4(318.84, 561.05, 155.0, 199.5),
    vector4(228.73, 765.8, 204.97, 238.66),
    vector4(-429.48, 1109.5, 327.68, 165.38),
    vector4(1179.77, -394.61, 68.0, 73.78),
    vector4(1114.32, -391.27, 68.95, 243.22),
    vector4(1028.76, -408.28, 66.34, 40.17),
    vector4(945.84, -519.02, 60.63, 121.84),
    vector4(964.3, -596.2, 59.9, 253.62),
    vector4(996.89, -729.58, 57.82, 128.54),
    vector4(1207.47, -620.29, 66.44, 268.16),
    vector4(1341.31, -597.31, 74.7, 48.81),
    vector4(1389.03, -569.57, 74.5, 293.76),
    vector4(1303.21, -527.36, 71.46, 340.6),
    vector4(213.08, -592.83, 43.87, 342.72),
    vector4(269.81, -640.79, 42.02, 245.95),
    vector4(-192.43, -652.64, 40.68, 71.02),
    vector4(-759.92, -709.14, 30.06, 94.47),
    vector4(-741.55, -982.29, 17.44, 203.21),
    vector4(-884.2, -1072.55, 2.53, 212.04),
    vector4(-978.07, -1108.35, 2.15, 214.74),
    vector4(-985.86, -1121.67, 4.55, 302.03),
    vector4(-991.71, -1103.4, 2.15, 31.96),
    vector4(-1113.9, -1193.92, 2.38, 215.16),
    vector4(-1207.17, -1264.31, 7.08, 150.31),
    vector4(-1150.83, -1519.37, 4.36, 308.62),
    vector4(-935.52, -1523.16, 5.24, 287.73),
    vector4(347.01, 2618.08, 44.67, 213.95),
}

-- Teslimat Başlama
function TeslimatBasla()
    inMission = true
    ClearPedSecondaryTask(PlayerPedId())
    ClearPedTasks(PlayerPedId())
    local random = math.random(1,#locations)
    Mblip = true
        MissionCoords = {
        x = locations[random][1],
        y = locations[random][2],
        z = locations[random][3],
        h = locations[random][4]
    }

    exports['mythic_notify']:SendAlert('inform', 'Delivery point marked on GPS', 5000)
    Mblip = CreateMissionBlip(MissionCoords.x, MissionCoords.y, MissionCoords.z)
end

-- Teslimat Blip Çıkartma/YokEtme
function CreateMissionBlip(x,y,z)
    local blip = AddBlipForCoord(x,y,z)
    SetBlipSprite(blip, 514)
    SetBlipColour(blip, 4)
    AddTextEntry('MYBLIP', "Delivery Point")
    BeginTextCommandSetBlipName('MYBLIP')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(10)
        if inMission == false and Mblip ~= false then
            RemoveBlip(Mblip)
            Mblip = false
        end
    end
end)

--- Et Pişirme

EtPisir = {vector3(11.36,-1599.27,29.39)}

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(10)
        for k,v in pairs(EtPisir) do
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 5)  then
                DrawMarker(2, v.x, v.y, v.z-0.10, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
                if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.3)  then
                    if not inMission then
                        DrawText3D(v.x, v.y, v.z+0.15, '~g~E~w~ - Taco Meat')
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent('sh1no-serveretkontrol')
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("sh1no-tacoetkontrol")
AddEventHandler("sh1no-tacoetkontrol", function()
    EtAnim()
    exports['mythic_progbar']:Progress({
     name = "taco_pisirdim",
     duration = 10000,
     label = 'Preparing Meat for Taco',
     useWhileDead = false,
     canCancel = false,
     controlDisables = {
         disableMovement = true,
         disableCarMovement = true,
         disableMouse = false,
         disableCombat = true,
     }
 }, function(cancelled)
     if not cancelled then
         TriggerServerEvent('sh1no-sualti3')
         etbittimikontrol = false
        end
    end)
end)

function EtAnim()
    local ped = GetPlayerPed(-1)
    LoadAnim('amb@prop_human_bbq@male@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    SpatelObject = CreateObject(GetHashKey("prop_fish_slice_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(SpatelObject, ped, GetPedBoneIndex(ped, 57005), 0.08, 0.0, -0.02, 0.0, -25.0, 130.0, true, true, false, true, 1, true)
    EtAnimKontrol()
end

function EtAnimKontrol()
    etbittimikontrol = true
    Citizen.CreateThread(function()
        while true do
            local ped = GetPlayerPed(-1)
            if etbittimikontrol then
                if not IsEntityPlayingAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 3) then
                    LoadAnim('amb@prop_human_bbq@male@idle_a')
                    TaskPlayAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                end
            else
                DetachEntity(SpatelObject)
                DeleteEntity(SpatelObject)
                ClearPedTasksImmediately(ped)
                break
            end
            Citizen.Wait(200)
        end
    end)
end


--- Taco Hazırlamak

TacoHazirlamak = {vector3(15.4,-1598.02,29.377908706665)}

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(10)
        for k,v in pairs(TacoHazirlamak) do
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 5)  then
                DrawMarker(2, v.x, v.y, v.z-0.10, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
                if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.3)  then
                    if not inMission then
                        DrawText3D(v.x, v.y, v.z+0.15, '~g~E~w~ - Prepare Taco')
                        if IsControlJustReleased(0, 38) then
                            hangitacoyapsash1no()
                        end
                    end
                end
            end
        end
    end
end)


function hangitacoyapsash1no()
	local elements ={  
        { label = 'Normal Taco', value = 'tazetazeetlitaco'},
        { label = 'Fish Taco', value = 'ananasokayim'},
	}
	
	ESX.UI.Menu.CloseAll() 
	ESX.UI.Menu.Open('default', GetCurrentResourceName(),'ventacyc',{
		title = 'Which taco do you want to make?', 
		align = 'top-right',
		elements = elements  
	
	}, function(data, menu)
	
	if data.current.value == 'tazetazeetlitaco' then 
		menu.close()
		local ped = PlayerPedId()
        exports['mythic_progbar']:Progress({
            name = "etli_taco",
            duration = 20000,
            label = 'Preparing a normal Taco',
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 49,
            }
        }, function(cancelled)
            if not cancelled then
                TriggerServerEvent("sh1no-etlitaco")
            end
        end)
    elseif data.current.value == 'ananasokayim' then
        menu.close()
		local ped = PlayerPedId()
        exports['mythic_progbar']:Progress({
            name = "balikli_taco",
            duration = 20000,
            label = 'Preparing a fish taco',
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 49,
            }
        }, function(cancelled)
            if not cancelled then
                TriggerServerEvent("sh1no-fishtacoyaptim")
            end
        end)
	end

end, function(data, menu)
    menu.close()
    exports['mythic_notify']:SendAlert('error', 'Action Cancelled', 3000)
	ClearPedTasks(player)
	FreezeEntityPosition(player,false)
end, function(data, menu)
end)
end


--- Taco Paketleme

TacoPaketleme = {vector3(8.5,-1606.33,29.50)}

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(10)
        for k,v in pairs(TacoPaketleme) do
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 5)  then
            DrawMarker(2, v.x, v.y, v.z-0.10, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.3)  then
            if not inMission then
               DrawText3D(v.x, v.y, v.z+0.15, '~g~E~w~ - Taco Packaging')
               if IsControlJustReleased(0, 38) then
                exports['mythic_progbar']:Progress({
                    name = "taco_paketleme",
                    duration = 10000,
                    label = 'Packing Taco for delivery',
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        anim = "machinic_loop_mechandplayer",
                        flags = 49,
                    }
                }, function(cancelled)
                    if not cancelled then
                        TriggerServerEvent('sh1no-tacopaketledim')
                       end
                   end)
                        end
                    end
                end
            end
        end
    end
end)

--- Taco Satışşş

TacoSatis = {vector3(5.25,-1605.23,29.39)}

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(10)
		for k,v in pairs(TacoSatis) do
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 5)  then
            DrawMarker(2, v.x, v.y, v.z-0.10, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.3)  then
				if not inMission then
                    DrawText3D(v.x, v.y, v.z+0.15, '~g~E~w~ - Green Taco(+$50)')	
					if IsControlJustReleased(0, 46) and (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.5) then
                        TriggerServerEvent("sh1no-parakontrol")
					end
				else
					DrawText3D(v.x, v.y, v.z+0.15, '~g~E~w~ - Cancel the delivery')		
					if IsControlJustReleased(0, 46) and (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.5) then
						SetPedComponentVariation(ped, 5, 20, 0, 0)
                        inMission = false
                        exports['mythic_notify']:SendAlert('inform', 'You cancelled the taco delivery!', 5000)
					    end
				    end
                end
            end
	    end
    end
end)

RegisterNetEvent('sh1no-kontrolgecti')
AddEventHandler('sh1no-kontrolgecti', function()
    TeslimatBasla()
end)

-- Satış Kontrol
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(10)
    local pcoords = GetEntityCoords(GetPlayerPed(-1))
    local coords = GetBlipInfoIdCoord(Mblip)
    local d = GetDistanceBetweenCoords(pcoords, coords[1], coords[2], coords[3], true)
    if inMission == true and MissionCoords ~= false and d < 20.0 then
    DrawMarker(2, coords[1], coords[2], coords[3]-0.10, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 0, 255, 0, 200, 0, 0, 0, 1, 0, 0, 0)
    if inMission == true and MissionCoords ~= false and d < 0.5 then
    DrawText3D(coords[1], coords[2], coords[3], '~g~E~w~ - Knock on the door')
    if IsControlJustReleased(0, 38) and d < 0.5 then
    inMission = false
    MissionCoords = false
    ClearPedSecondaryTask(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), true)
    exports['mythic_progbar']:Progress({
        name = "taco_satis",
        duration = 10000,
        label = 'You are delivering taco',
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "timetable@jimmy@doorknock@",
            anim = "knockdoor_idle",
            flags = 49,
        }
    }, function(cancelled)
        if not cancelled then
            TriggerServerEvent("sh1no-tacouyusturucukontrol")
            FreezeEntityPosition(PlayerPedId(), false)
            ClearPedTasks(PlayerPedId())
                        end
                    end)
                end
            end
        end
    end
end)

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
end