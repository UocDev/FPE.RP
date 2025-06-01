local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")


local COOLDOWN = 30 -- seconds
local DURATION = 10 -- seconds
local ACTIVATION_KEY = Enum.KeyCode.F -- Change to your preferred key
local DAMAGE_MULTIPLIER = 1.5 -- Damage increase during overclock
local SPEED_MULTIPLIER = 1.3 -- Speed increase during overclock
local VISUAL_EFFECTS = true -- Whether to show visual effects

local isOverclocked = false
local canActivate = true
local cooldownEnd = 0

local overclockParticles = Instance.new("ParticleEmitter")
overclockParticles.Texture = "rbxassetid://242719788" -- Replace with your preferred texture
overclockParticles.LightEmission = 1
overclockParticles.Color = ColorSequence.new(Color3.fromRGB(255, 100, 100))
overclockParticles.Size = NumberSequence.new(0.5)
overclockParticles.Transparency = NumberSequence.new(0.5)
overclockParticles.Lifetime = NumberRange.new(0.5)
overclockParticles.Rate = 50
overclockParticles.Speed = NumberRange.new(2)
overclockParticles.EmissionDirection = Enum.NormalId.Top
overclockParticles.Enabled = false

if VISUAL_EFFECTS then
    overclockParticles.Parent = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
end

local function activateOverclock()
    if not canActivate or isOverclocked then return end
    
    isOverclocked = true
    canActivate = false
    
    local originalWalkSpeed = humanoid.WalkSpeed
    local originalJumpPower = humanoid.JumpPower
    
    humanoid.WalkSpeed = originalWalkSpeed * SPEED_MULTIPLIER
    humanoid.JumpPower = originalJumpPower * SPEED_MULTIPLIER
    
    if VISUAL_EFFECTS then
        overclockParticles.Enabled = true
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://138080933" -- Replace with your preferred sound
            sound.Volume = 0.5
            sound.Parent = root
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 3)
        end
    end
    
   
    local notification = Instance.new("ScreenGui")
    local textLabel = Instance.new("TextLabel")
    notification.Name = "OverclockNotification"
    notification.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
    textLabel.Size = UDim2.new(0, 200, 0, 50)
    textLabel.Position = UDim2.new(0.5, -100, 0.8, 0)
    textLabel.Text = "OVERCLOCK E.G.O ACTIVATED"
    textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    textLabel.TextScaled = true
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = notification
    
    task.delay(DURATION, function()
        isOverclocked = false
        
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.JumpPower = originalJumpPower
        
        if VISUAL_EFFECTS then
            overclockParticles.Enabled = false
        end
    
        notification:Destroy()
        
        cooldownEnd = os.time() + COOLDOWN
        local cooldownNotification = Instance.new("ScreenGui")
        local cooldownText = Instance.new("TextLabel")
        cooldownNotification.Name = "CooldownNotification"
        cooldownNotification.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
        cooldownText.Size = UDim2.new(0, 200, 0, 30)
        cooldownText.Position = UDim2.new(0.5, -100, 0.85, 0)
        cooldownText.Text = "E.G.O Cooldown: " .. COOLDOWN .. "s"
        cooldownText.TextColor3 = Color3.fromRGB(200, 200, 200)
        cooldownText.TextScaled = true
        cooldownText.BackgroundTransparency = 1
        cooldownText.Parent = cooldownNotification
        
        while os.time() < cooldownEnd do
            local remaining = cooldownEnd - os.time()
            cooldownText.Text = "E.G.O Cooldown: " .. math.floor(remaining) .. "s"
            task.wait(0.1)
        end
        
        canActivate = true
        cooldownNotification:Destroy()
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == ACTIVATION_KEY and canActivate then
        activateOverclock()
    end
end)
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    if VISUAL_EFFECTS then
        overclockParticles.Parent = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
    end
end)