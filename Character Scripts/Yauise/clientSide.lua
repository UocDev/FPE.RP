local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local vectorPart = Instance.new("Part")
vectorPart.Size = Vector3.new(0.2, 0.2, 1)
vectorPart.Anchored = true
vectorPart.CanCollide = false
vectorPart.Color = Color3.fromRGB(255, 0, 0)
vectorPart.Parent = workspace

game:GetService("RunService").Heartbeat:Connect(function()
    if humanoid.MoveDirection.Magnitude > 0 then
        vectorPart.Visible = true
        vectorPart.Position = character:GetPivot().Position + Vector3.new(0, 2, 0)
        vectorPart.CFrame = CFrame.lookAt(
            vectorPart.Position,
            vectorPart.Position + humanoid.MoveDirection * 5
        )
    else
        vectorPart.Visible = false
    end
end)
