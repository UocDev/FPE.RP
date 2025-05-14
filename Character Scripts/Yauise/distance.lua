local Players = game:GetService("Players")

local function updateDistances()
    local playerList = Players:GetPlayers()
    
    for i = 1, #playerList do
        for j = i + 1, #playerList do
            local player1 = playerList[i]
            local player2 = playerList[j]
            
            if player1.Character and player2.Character then
                local pos1 = player1.Character:GetPivot().Position
                local pos2 = player2.Character:GetPivot().Position
                local distance = (pos1 - pos2).Magnitude
                
                print(string.format("Distance between %s and %s: %.2f studs", 
                    player1.Name, player2.Name, distance))
            end
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(updateDistances)
