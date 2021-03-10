ESX = nil

local lspdcolor, emscolor, bcsocolor = 57, 61, 56
local lspdBlips = {}
local emsBlips = {}
local bcsoBlips = {}
local vjobs = {'bcso','police','ambulance'}
local offjobs = {'offbcso','offpolice','pffambulance'}
local canSeeBlip = false

Citizen.CreateThread(function()
    
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    Citizen.Wait(200)

    if ESX.PlayerData and ESX.PlayerData.job then
        local job = ESX.PlayerData.job.name
        for k,v in pairs(vjobs) do 
            if job == v then
                canSeeBlip = true
            end
        end
    end

    if canSeeBlip then
        TriggerServerEvent('ndrp_cops:playerData')
    end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    Citizen.Wait(500)
    if ESX.PlayerData and ESX.PlayerData.job then
        local job = ESX.PlayerData.job.name
        for k,v in pairs(vjobs) do 
            if job == v then
                canSeeBlip = true
            end
        end
    end
    if ESX.PlayerData and ESX.PlayerData.job then
        local job = ESX.PlayerData.job.name
        for k,v in pairs(offjobs) do 
            if job == v then
                TriggerServerEvent('ndrp_cops:playerData')
                canSeeBlip = false
            end
        end
    end
    if canSeeBlip then
        TriggerServerEvent('ndrp_cops:playerData')
    else
        RemoveAllBlips()
    end
end)

RegisterNetEvent('ndrp_cops:updateBlips')
AddEventHandler('ndrp_cops:updateBlips', function(tab)
    if canSeeBlip then
        CreateThread(function()
            local players = tab
            RemoveAllBlips()
            for i=1, #players, 1 do
                if players[i].job.name == 'police' then
                    local id = GetPlayerFromServerId(players[i].source)
                    if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                        createBlipLSPD(id,'LSPD - ' ..players[i].name)
                    end
                elseif players[i].job.name == 'ambulance' then
                    local id = GetPlayerFromServerId(players[i].source)
                    if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                        createBlipEMS(id,'EMS - ' ..players[i].name)
                    end
                elseif players[i].job.name == 'bcso' then
                    local id = GetPlayerFromServerId(players[i].source)
                    if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                        createBlipBCSO(id,'BCSO - ' ..players[i].name)
                    end
                end
            end
        end)
    end
end)

function createBlipLSPD(id,xname)
	local ped = GetPlayerPed(id)
    local blip = AddBlipForEntity(ped)
    SetBlipSprite(blip, 1)
    ShowHeadingIndicatorOnBlip(blip, true) 
    SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) 
    SetBlipScale(blip, 0.85) 
    SetBlipColour(blip, lspdcolor)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(xname)
    EndTextCommandSetBlipName(blip)
    table.insert(lspdBlips, blip)
end

function createBlipBCSO(id,xname)
	local ped = GetPlayerPed(id)
	local blip = AddBlipForEntity(ped)
	SetBlipSprite(blip, 1)
	ShowHeadingIndicatorOnBlip(blip, true) 
	SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) 
    SetBlipScale(blip, 0.85) 
    SetBlipColour(blip, bcsocolor)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(xname)
	EndTextCommandSetBlipName(blip)
	table.insert(bcsoBlips, blip)
end

function createBlipEMS(id,xname)
	local ped = GetPlayerPed(id)
    local blip = AddBlipForEntity(ped)
	SetBlipSprite(blip, 1)
	ShowHeadingIndicatorOnBlip(blip, true) 
	SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) 
    SetBlipScale(blip, 0.85) 
    SetBlipColour(blip, emscolor)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(xname)
	EndTextCommandSetBlipName(blip)
	table.insert(emsBlips, blip)
end

function RemoveAllBlips()
    for k, existingBlip in pairs(lspdBlips) do
        RemoveBlip(existingBlip)
    end
    for k, existingBlip in pairs(emsBlips) do
        RemoveBlip(existingBlip)
    end
    for k, existingBlip in pairs(bcsoBlips) do
        RemoveBlip(existingBlip)
    end
    lspdBlips, emsBlips, bcsoBlips = {},{},{}
end