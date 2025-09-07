local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--first look for the event in the replicatedstorage needed for client-server interaction, if it doesn't exist create a new event.
local event = ReplicatedStorage:FindFirstChild("JoinPadCountdown")
if not event then 
    event = Instance.new("RemoteEvent") --creating the remote event for the first time when it doesn't exist
    event.Name = "JoinPadCountdown"
    event.Parent = ReplicatedStorage
end

--referencing the joinpad in the workspace
local JoinPad = workspace:WaitForChild("JoinPad")

--referencing the spawn point where the users will be teleporting to. 
local Arena = workspace:WaitForChild("GameArena")
local ArenaSpawn = Arena:WaitForChild("ArenaSpawn")

--This will contain two values, one being the boolean value whether the player is touching the part and which task the player is on. 
local active = {}

--Checking whether the player has stepped off from the join pad 
--There are three cases why the countdown can be stopped
--one being the player stepping off the joinpad, one being the player moving on the joinpad, and the last being the player leaving the game. 
local function cancelCountdown(player:Player, reason:string?)
    local st = active[player]
    if not st then return end
    st.touching = false
    if st.task then 
        task.cancel(st.task) --removing the ongoing task
        st.task = nil --cancelling the current task
    end
        event:FireClient(player, { kind = "cancel", reason = reason or "stepped_off" })
end

--Checks if the player has left the joinpad. 
JoinPad.TouchEnded:Connect(function(hit)
local player = Players:GetPlayerFromCharacter(hit and hit.Parent)
    if player and active[player] and active[player].touching then 
        cancelCountdown(player, "touch_ended")
    end
end)

--cleaning up the table once the player leaves or gets kicked out of the game completely. 
Players.PlayerRemoving:Connect(function(player)
    cancelCountdown(player, "player_left")
    active[player] = nil
end)

--Starting countdown on touch
JoinPad.Touched:Connect(function(hit)
    local player = Players:GetPlayerFromCharacter(hit and hit.Parent)
    if not player then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    --creating the key value pair in the active table. 
    local st = active[player]
    if not st then 
        st = {touching = true, task = nil}
        active[player] = st
    else
        st.touching = true
        if st.task then return end --this means the countdown is ongoing.
    end

    --allocating the task to the task attribute of the active table. 
    st.task = task.spawn(function()
        local seconds = 10 --setting the time to display on the user screen. 
        event:FireClient(player, {kind = "start", total = seconds})

        while seconds >= 0 do 
            --checking whether the player is standing still on the joinpad.
            if not active[player] or not active[player].touching then return end
            event:FireClient(player, {kind = "tick", remaining = seconds})
            if seconds == 0 then break end
            task.wait(1)
            seconds -= 1
        end

        --if the player is still touching the block, then they can be teleported. 
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = ArenaSpawn.CFrame + Vector3.new(0, 5, 0)
        end

        event:FireClient(player, {kind = "done"})
        active[player].touching, active[player].task = false, nil --setting the active attributes back to its original values. 
    end)
end)