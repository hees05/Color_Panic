local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

--creating remote event for teleporting player from the base to another part of the map.
local event = ReplicatedStorage:WaitForChild("JoinPadCountdown")

--creating the gui for showing the player teleporting status. 
local gui = Instance.new("ScreenGui")
gui.Name = "JoinPadGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = player:WaitForChild("PlayerGui")

--creating the label to be displayed to the user, placing it inside the gui I've created. 
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.25, 0, 0.12, 0)
label.Position = UDim2.new(0.375, 0, 0.05, 0)
label.BackgroundTransparency = 0.2
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.new(1, 1, 1)
label.Parent = gui

--function that'll be used in the case of time ticking task. 
local function showCount(n)
    gui.Enabled = true
    label.Text = ("Teleporting in %d..."):format(n)
end

--function to show message in the case of stepping on the joinpad and leaving the joinpad. 
local function showMsg(msg)
    gui.Enabled = true
    label.Text = msg
end

--hiding all the components of the GUI (There's only one) once the user has finished teleporting or stepped out of the joinpad. 
local function hideGui()
    gui.Enabled = false
end

event.OnClientEvent:Connect(function(payload)
    if typeof(payload) ~= "table" or not payload.kind then return end
    if payload.kind == "start" then
        showMsg(("Stand still for %d seconds to join"):format(payload.total or 10))
    elseif payload.kind == "tick" then
        showCount(payload.remaining or 0)
    elseif payload.kind == "cancel" then
        showMsg("Cancelled, step on the pad to try again")
        task.delay(1, hideGui)
    elseif payload.kind == "done" then
        showMsg("Teleporting...")
        task.delay(0.5, hideGui)
    end
end)