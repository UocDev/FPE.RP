local tool = script.Parent
local handle = tool:WaitForChild("Handle")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local events = {
    EGOReady = ReplicatedStorage:WaitForChild("EGOReady")
}

local EGOName = tool.Name
local equipped = false

-- Tool equipped/unequipped
tool.Equipped:Connect(function()
    equipped = true
    events.EGOReady:FireServer(EGOName, true)
end)

tool.Unequipped:Connect(function()
    equipped = false
end)

-- Animation setup
local animationTrack

tool.Equipped:Connect(function()
    local animator = humanoid:WaitForChild("Animator")
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://YOUR_ANIMATION_ID_HERE" -- Replace with actual animation ID
    animationTrack = animator:LoadAnimation(animation)
end)

-- Activation logic
local function onActivated()
    if equipped then
        if animationTrack then
            animationTrack:Play()
        end
        -- Additional visual effects can be added here
    end
end

tool.Activated:Connect(onActivated)