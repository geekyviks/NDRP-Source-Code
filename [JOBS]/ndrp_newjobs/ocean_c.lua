local randomcoords = {
    {x = 3144.94, y = -280.54, z = -10.31},
    {x = 3151.75, y = -286.02, z = -27.16},
    {x = 3127.14, y = -341.26, z = -23.14},
    {x = 3162.18, y = -357.39, z = -27.6},
    {x = 3195.47, y = -388.18, z = -32.16},
    {x = 3188.67, y = -395.82, z = -27.51},
    {x = 3221.45, y = -405.6, z = -48.48},
    {x = 3192.30, y = -385.23, z = -16.81},
}

local randomitems = {
    {item = 'scrap'},
    {item = 'glass'},
    {item = 'steel'},
    {item = 'WEAPON_KNIFE'},
    {item = 'WEAPON_BOTTLE'},
    {item = 'goldbar'},
    {item = 'thermite'},
    {item = 'WEAPON_WRENCH'}
}

local pickup = math.random(1,#randomcoords)
local item = 10
local lastpick = 0
local clicked = false

Citizen.CreateThread(function()
    local wait = 500
	while true do
        Citizen.Wait(wait)
        x = randomcoords[pickup].x
        y = randomcoords[pickup].y
        z = randomcoords[pickup].z
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, x,y,z, true)
        if distance < 200 and IsPedSwimmingUnderWater(playerPed)then
            wait = 10
            if distance > 3 then
                Draw3DText(x,y,z, "Distance: "..math.floor(distance*10)/10)
            else
                Draw3DText(x,y,z+1.0, '[E] to search')
            end
            if distance < 2 then
                if IsControlJustReleased(0, 46) and not clicked then
                    clicked = true
                    lastpick = pickup
                    item = math.random(1,200)
                    pickup = math.random(1,#randomcoords)
                    if item > 100 and item < 110 then
                        TriggerServerEvent("ndrp_ocean:collected",randomitems[math.random(4,6)].item)
                    elseif item == 150 then
                        TriggerServerEvent("ndrp_ocean:collected",randomitems[math.random(6,7)].item)
                    else
                        TriggerServerEvent("ndrp_ocean:collected",randomitems[math.random(1,3)].item)
                    end
                    Citizen.Wait(2000)
                    clicked = false
				end
            end
        else
            wait = 100
		end
	end
end)

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
end