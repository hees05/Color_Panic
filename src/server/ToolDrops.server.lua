--File to alloate all the tools on the tiles for users to pick up and fight. 
local ServerStorage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")
local WeaponsFolder = ServerStorage:WaitForChild("Weapons")
local SpawnFolder = workspace:WaitForChild("ToolSpawns")

local MAX_TOOLS = 10
local SPAWN_INTERVAL = 8
local DESPAWN_TIME = 30

while true do 
    task.wait(SPAWN_INTERVAL)

    local currentTools = workspace:GetChildren()
    --count how many tools there exists already.
    local count = 0
    for _, obj in ipairs(currentTools) do
        if obj:IsA("Tool") then
            count += 1
        end
    end

    if count <MAX_TOOLS then
        local weapons = WeaponsFolder:GetChildren()
        local spawns = SpawnFolder:GetChildren()
        if #weapons>0 and #spawns >0 then
            local weapon = weapons[math.random(1, #weapons)]:Clone()
            local spawnPoint = spawns[math.random(1, #spawns)]

            weapon.Parent = workspace
            weapon.Handle.CFrame = spawnPoint.CFrame

            Debris:AddItem(weapon, DESPAWN_TIME)
        end
    end
end
