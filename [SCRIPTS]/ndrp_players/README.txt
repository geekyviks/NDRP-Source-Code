

INSTALL INSTRUCTIONS:                                                

1. Goto "esx_kashacters" > client > main.lua > Find the following Thread

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            Citizen.Wait(500)

----------------------------------------------

THEN ADD THE FOLLOW INSIDE THE ABOVE THREAD:

TriggerServerEvent("esx-scoreboard:AddPlayer")

----------------------------------------------

IT SHOULD THEN LOOK LIKE THIS:

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            Citizen.Wait(500)
	    TriggerServerEvent("esx-scoreboard:AddPlayer")
	    TriggerEvent("kashactersC:SetupCharacters")
            return -- break the loop
        end
    end
end)

OR IF YOU USE MY NOPIXEL KASHACTERS IT SHOULD LIKE THIS:

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            Citizen.Wait(500)
	    TriggerServerEvent("esx-scoreboard:AddPlayer")
	    TriggerEvent("kashactersC:WelcomePage")
	    TriggerEvent("kashactersC:SetupCharacters")
            return -- break the loop
        end
    end
end)

