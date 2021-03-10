ESX = nil

local coords = { x = 2433.91, y = 4965.50, z = 42.00, h = 43.69 }

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 68)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local distance = #(vector3(coords.x, coords.y, coords.z) - plyCoords)
        if distance < 10 then
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 3 then
			        Draw3DText(coords.x, coords.y, coords.z + 0.5, '[E] - Get treated by Grandma for $1,000')
                        if IsControlJustReleased(0, 54) then
                            DisableControlAction(0, 54, true)
                            if (GetEntityHealth(PlayerPedId()) <= 200) then
                                exports['mythic_progbar']:Progress({
                                    name = "grandmas_house",
                                    duration = 60000,
                                    label = "Grandma is treating you.",
                                    useWhileDead = true,
                                    canCancel = true,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = "timetable@tracy@sleep@",
                                        anim = "idle_c",
                                        flags = 33,
                                    },
                                    prop = {

                                    },
                                }, function(status)
                                    if not status then
                                        TriggerEvent('esx_ambulancejob:revive')
                                        TriggerEvent('esx_ambulancejob:heal', 'big', true)
                                        TriggerServerEvent('ndrp_grandmas:payBill')
                                        EnableControlAction(0, 54, true)
                                    end
                                end)
                            else
                                exports['mythic_notify']:DoHudText('error', 'You do not need medical attention')
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
    end
end)