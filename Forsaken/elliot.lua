local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local movementDirection = Vector3.new()
local moveSpeed = 16
local runSpeed = 24
local isRunning = false

RunService.RenderStepped:Connect(function()
	if humanoid and rootPart then
		local cam = workspace.CurrentCamera
		local moveVector = Vector3.new(movementDirection.X, 0, movementDirection.Z)
		moveVector = cam.CFrame:VectorToWorldSpace(moveVector)
		rootPart.Velocity = Vector3.new(moveVector.X, rootPart.Velocity.Y, moveVector.Z) * (isRunning and runSpeed or moveSpeed)
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.W then movementDirection = movementDirection + Vector3.new(0, 0, -1) end
	if input.KeyCode == Enum.KeyCode.S then movementDirection = movementDirection + Vector3.new(0, 0, 1) end
	if input.KeyCode == Enum.KeyCode.A then movementDirection = movementDirection + Vector3.new(-1, 0, 0) end
	if input.KeyCode == Enum.KeyCode.D then movementDirection = movementDirection + Vector3.new(1, 0, 0) end
	if input.KeyCode == Enum.KeyCode.LeftShift then isRunning = true end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then movementDirection = movementDirection - Vector3.new(0, 0, -1) end
	if input.KeyCode == Enum.KeyCode.S then movementDirection = movementDirection - Vector3.new(0, 0, 1) end
	if input.KeyCode == Enum.KeyCode.A then movementDirection = movementDirection - Vector3.new(-1, 0, 0) end
	if input.KeyCode == Enum.KeyCode.D then movementDirection = movementDirection - Vector3.new(1, 0, 0) end
	if input.KeyCode == Enum.KeyCode.LeftShift then isRunning = false end
end)
