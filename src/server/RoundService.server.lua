local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local Stats = require(ReplicatedStorage:WaitForChild("Stats"))
local Constants = require(ReplicatedStorage:WaitForChild("Constants"))

local LobbySpawn = workspace:WaitForChild("LobbySpawn") :: SpawnLocation
local ArenaFolder = workspace:WaitForChild("ColorMap") ::Folder
local ArenaSpawn = workspace:WaitForChild("ArenaSpawn") :: Part  

local ROUND_MIN_PLAYERS = 2
local COUNTDOWN_SECONDS = 5
local BETWEEN_ROUNDS = 6

--Creating the event to bind with to trigger the GUI components related to the round service. 
local event = ReplicatedStorage:FindFirstChild("RoundServiceStart")
if not event then 
    event = Instance.new("RemoteEvent") --creating the remote event for the first time when it doesn't exist
    event.Name = "RoundServiceStart"
    event.Parent = ReplicatedStorage
end

--checks who is currentnly alive in this round. 
local Alive: {[Player]: boolean} = {}
local Connections: {[Player]: RBXScriptConnection} = {}

local function teleportCharacterTo(part: BasePart, character: Model)
    if not character.PrimaryPart then 
        local hrp = character:FindFirstChild("HumanoidRootPart")::BasePart?
        if hrp then 
            character.PrimaryPart = hrp
        else
            hrp = character:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                character.PrimaryPart = hrp
            end
        end
    end
    
    character:PivotTo(part.CFrame + Vector3.new(0, 4, 0))
end


--code to respawn the player to the initial spawning point when the player joins the game. 
Players.PlayerAdded:Connect(function(player)
    player.RespawnLocation = LobbySpawn
    player.CharacterAdded:Connect(function(char)
        if not Alive[player] then 
            task.wait()
            teleportCharacterTo(LobbySpawn, char)
        end
    end)
end)

--function to fetch all the players in the Alive table 
local function getActiveFighters(): {Player}
    local t = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if Alive[player] then table.insert(t, player) end
    end
    return t
end

--code to be implemented here depending on the change of round

--Choosing the colour of the round
local function chooseTarget()
    --get a random value of the contsants and return the colour. 
    local colour = math.random(1, #Constants)
    return Constants.COLORS[colour]
    --then use this returned value to pass on to the function in the UI client file after firing OnClient

end

local function colorPhase()
    local color = chooseTarget()
    local deadline = os.clock() + 3  -- 3 seconds to reach tile, for example

    event:FireAllClients({Type = "ColorPrompt", Color = color, Deadline = deadline})
    -- wait until deadline then validate
    while os.clock() < deadline do task.wait() end
    -- server-side: check each alive player is on the right tile; eliminate if not
end
--Clearing the arena and rebuilding the grid
local function rebuildGrid()
end

--timer loops to let the users know how much time there are left.
local function countdown(seconds)
end

--give players scores based on their presence of standing on the correct tile. 
local function judgePlayers(targetName) --target name is the colour of the current round
end

--playing one full round
local function playOneRound()
    --first pick the colour to be displayed for the users
    --then give players time to find the colour (maybe 5 seconds)
    --then check if the player is on the correct colour as chosen 
    --give scores to the survived users
    --repeat the game if there still exists the players. 
end

playOneRound()



