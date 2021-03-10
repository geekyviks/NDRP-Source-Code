-- Animations
animDict1 = "mp_player_int_upperwank"
animDict2 = "anim@mp_player_intcelebrationmale@wank"
anim1 = "mp_player_int_wank_01_enter"
anim2 = "mp_player_int_wank_01_exit"
anim3 = "wank"

-- Display 3D Text with 3dme
function DisplayText(text)
	TriggerServerEvent("3dme:shareDisplay", text) -- Edit if using a 3dme alternative
end

-- Get Animations
function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

-- Rock, Paper, Scissors
RegisterCommand("rps", function(source, args, command)
	local text = rpsPrefix
	local options = {"Rock!", "Paper!", "Scissors!"}
	local choice = ""
	if args[1] == "r" then
		choice = options[1]
	elseif args[1] == "p" then
		choice = options[2]
	elseif args[1] == "s" then
		choice = options[3]
	else
		return
	end
	text = text ..choice
	loadAnimDict(animDict1)
	TaskPlayAnim(PlayerPedId(-1), animDict1, anim1, 8.0, -8, -1, 8, 0, 0, 0, 0)
	Citizen.Wait(700)
	DisplayText(text)
end)
TriggerEvent("chat:addSuggestion", "/rps", "Rock, Paper, Scissors", {
    { name="r/p/s", help="r=Rock, p=Paper or s=Scissors" },
})

-- Flip Coin
RegisterCommand("flip", function(source, args, command)
	local text = flipPrefix
	local options = {"Heads", "Tails"}
	text = text ..options[math.random(1, #options)]
	loadAnimDict(animDict1)
	TaskPlayAnim(PlayerPedId(-1), animDict1, anim2, 8.0, -8, -1, 8, 0, 0, 0, 0)
	Citizen.Wait(700)
	DisplayText(text)
end)
TriggerEvent("chat:addSuggestion", "/flip", "Flip a coin")

-- Roll Dice
RegisterCommand("roll", function(source, args, command)
	local text = rollPrefix
	local dice = {}
	local numOfDice = tonumber(args[1]) and tonumber(args[1]) or 1
	local numOfSides = tonumber(args[2]) and tonumber(args[2]) or 6
	if (numOfDice < 1 or numOfDice > maxDice) then numOfDice = 1 end
	if (numOfSides < 2 or numOfSides > maxDiceSides) then numOfSides = 6 end
	for i = 1, numOfDice do
		dice[i] = math.random(1, numOfSides)
		text = text ..dice[i] .."/" ..numOfSides .."  "
	end
	loadAnimDict(animDict2)
	TaskPlayAnim(PlayerPedId(-1), animDict2, anim3, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(1500)
	ClearPedTasks(GetPlayerPed(-1))
	DisplayText(text)
end)
TriggerEvent("chat:addSuggestion", "/roll", "Roll dice", {
    { name="Dice", help="Number of dice (1-" ..maxDice ..")" },
    { name="Sides", help="Number of sides (2-" ..maxDiceSides ..")" },
})