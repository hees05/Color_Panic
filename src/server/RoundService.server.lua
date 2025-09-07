local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Stats = require(ReplicatedStorage:WaitForChild("Stats"))
local Constants = require(ReplicatedStorage:WaitForChild("Constants"))

--code to be implemented here depending on the change of round

--Choosing the colour of the round
local function chooseTarget()
    --get a random value of the contsants and return the colour. 
    local colour = math.random(1, #Constants)
    return Constants.COLORS[colour]
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
end


----------------------------------Allocating weapons to the users initially ----------------------------------
--equip initial tools to the users.
local function equipRoundWeapons(ply:Player)
end

--take away weapons from the users once the round is over.
local function stripWeapons(plr: Player)
end


