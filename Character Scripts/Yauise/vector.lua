local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
            local moveDirection = humanoid.MoveDirection
            print(player.Name .. " is moving with vector: " .. tostring(moveDirection))
            
            -- Unfinished
        end)
    end)
end)
