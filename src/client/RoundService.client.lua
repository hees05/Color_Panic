local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local event = ReplicatedStorage:WaitForChild("RoundServiceStart")

local gui = Instance.new("ScreenGui")
gui.Name = "RoundUI"
gui.ResetOnSpawn = false 
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.25, 0, 0.12, 0)
label.Position = UDim2.new(0.375, 0, 0.05, 0)
label.BackgroundTransparency = 0.2
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.new(1, 1, 1)
label.Parent = gui

local colourLabel = Instance.new("TextLabel")
colourLabel.Size = UDim2.new(0.25, 0, 0.12, 0)
colourLabel.Position = UDim2.new(0.375, 0, 0.12, 0)
colourLabel.BackgroundTransparency = 0.2
colourLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
colourLabel.TextScaled = true
colourLabel.Font = Enum.Font.GothamBold
colourLabel.TextColor3 = Color3.new(1, 1, 1)
colourLabel.Parent = gui

local function showCount(n , color)
    gui.Enabled = true
    label.Text = ("Be in %s by %d..."):format(color, n)
end

local function nextRoundCount(n)
    gui.Enabled = true
    label.Text = ("Next round starts in %d..."):format(n)
end
local function showColour(color)
    gui.Enabled = true
    colourLabel.Text = color
end

local function showMsg(msg)
    gui.Enabled = true
    label.Text = msg
end

local function hideGui()
    gui.Enabled = false
end

--now this will trigger the gui components to show once the player has entered the game 
--there will be different payloads for this gui. 
--1. when the player first joins the game
--2. when the player gets eliminated from the game
--3. winner announcement 
--4. game intermission ,to let the users know the time left until the next round starts
--5. 
event.OnClientEvent:Connect(function(payload)
    if typeof(payload) ~= "table" or not payload.kind then return end
    if payload.kind == "start" then 
        showMsg("Welcome to the game. You have limited time until you have to go in the selected colour. ")
        task.wait(5)
        showCount(payload.remaining or 0)
        
    elseif payload.kind == "eliminated" then
        showMsg("You've been eliminated")
        task.delay(1, hideGui)
    elseif payload.kind == "winner" then
        showMsg("%s is the winner of the game"):format(payload.str)
    elseif payload.kind == "nextRound" then 
        showCount(payload.remaining or 0)
    end
end)