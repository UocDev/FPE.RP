local model = script.Parent
local playerPart = model:WaitForChild("PlayerIndicator")
local vectorPart = model:WaitForChild("VectorIndicator")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

playerPart.Anchored = false
playerPart.CanCollide = false
local weld = Instance.new("WeldConstraint")
weld.Part0 = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
weld.Part1 = playerPart
weld.Parent = playerPart

game:GetService("RunService").Heartbeat:Connect(function()
    if humanoid.MoveDirection.Magnitude > 0 then
        vectorPart.Visible = true
        vectorPart.CFrame = CFrame.lookAt(
            playerPart.Position + Vector3.new(0, 3, 0),
            playerPart.Position + Vector3.new(0, 3, 0) + humanoid.MoveDirection * 5
        )
    else
        vectorPart.Visible = false
    end
end)
