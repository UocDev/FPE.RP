local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)

local moveDirection = Vector3.new(0, 0, 0)
local moveSpeed = 16

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.W then
        moveDirection = Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.S then
        moveDirection = Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.A then
        moveDirection = Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        moveDirection = Vector3.new(1, 0, 0)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
       input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
        moveDirection = Vector3.new(0, 0, 0)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if moveDirection.Magnitude > 0 then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local moveVector = rootPart.CFrame:VectorToWorldSpace(moveDirection * moveSpeed)
            rootPart.Velocity = Vector3.new(moveVector.X, rootPart.Velocity.Y, moveVector.Z)
        end
    end
end)
