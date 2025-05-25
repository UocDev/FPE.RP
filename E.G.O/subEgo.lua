local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Get remote events
local events = {
    ActivateEGO = ReplicatedStorage:WaitForChild("ActivateEGO"),
    EGOReady = ReplicatedStorage:WaitForChild("EGOReady"),
    EGOCooldown = ReplicatedStorage:WaitForChild("EGOCooldown")
}

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EGOGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.2, 0, 0.1, 0)
frame.Position = UDim2.new(0.8, 0, 0.9, 0)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local skillName = Instance.new("TextLabel")
skillName.Size = UDim2.new(1, 0, 0.5, 0)
skillName.Text = "No E.G.O equipped"
skillName.TextColor3 = Color3.fromRGB(255, 255, 255)
skillName.BackgroundTransparency = 1
skillName.Parent = frame

local cooldownBar = Instance.new("Frame")
cooldownBar.Size = UDim2.new(1, 0, 0.5, 0)
cooldownBar.Position = UDim2.new(0, 0, 0.5, 0)
cooldownBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
cooldownBar.BorderSizePixel = 0
cooldownBar.Parent = frame

local cooldownProgress = Instance.new("Frame")
cooldownProgress.Size = UDim2.new(1, 0, 1, 0)
cooldownProgress.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
cooldownProgress.BorderSizePixel = 0
cooldownProgress.Parent = cooldownBar

local currentEGO = nil
local onCooldown = false

-- Input handling
local function activateEGO(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        if currentEGO and not onCooldown then
            events.ActivateEGO:FireServer(currentEGO)
        end
    end
end

ContextActionService:BindAction("ActivateEGO", activateEGO, false, Enum.KeyCode.E)

-- E.G.O ready handler
events.EGOReady.OnClientEvent:Connect(function(EGOName, ready)
    if ready then
        onCooldown = false
        cooldownProgress:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 0.2)
    else
        skillName.Text = EGOName
        currentEGO = EGOName
        onCooldown = true
    end
end)

-- Cooldown handler
events.EGOCooldown.OnClientEvent:Connect(function(EGOName, cooldownTime)
    cooldownProgress.Size = UDim2.new(0, 0, 1, 0)
    cooldownProgress:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", cooldownTime)
end)

-- Character setup
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    -- Reset E.G.O state on respawn
    currentEGO = nil
    onCooldown = false
    skillName.Text = "No E.G.O equipped"
    cooldownProgress.Size = UDim2.new(1, 0, 1, 0)
end)