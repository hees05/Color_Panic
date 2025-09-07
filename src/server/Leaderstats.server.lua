local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    --shows allocated score based on the user play
    local score = Instance.new("IntValue")
    score.Name = "Score"
    score.Value = 0
    score.Parent = leaderstats

    --shows how many times user won the rounds.
    local wins = Instance.new("IntValue")
    wins.Name = "Wins"
    wins.Value = 0
    wins.Parent = leaderstats

    --shows how many times user won the rounds in a row
    local best = Instance.new("IntValue")
    best.Name = "BestStreak"
    best.Value = 0
    best.Parent = leaderstats
end)