local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- E.G.O Skill Definitions
local EGOSkills = {
    ["Compas"] = {
        Cooldown = 15,
        Damage = 35,
        Range = 25,
        Effect = "Unknown",
        Animation = "rbxassetid://1234567890",
        Description = "Deals pale damage in a wide arc"
    },
    ["Books"] = {
        Cooldown = 10,
        Damage = 25,
        Range = 15,
        Effect = "Bleed",
        Animation = "rbxassetid://2345678901",
        Description = "Inflicts bleeding damage over time"
    },
    -- Add more E.G.O weapons here
}

-- Create RemoteEvents
local events = {
    ActivateEGO = Instance.new("RemoteEvent"),
    EGOReady = Instance.new("RemoteEvent"),
    EGOCooldown = Instance.new("RemoteEvent")
}

for name, event in pairs(events) do
    event.Name = name
    event.Parent = ReplicatedStorage
end

-- Player data tracking
local playerData = {}

local function setupPlayer(player)
    playerData[player] = {
        CurrentEGO = nil,
        Cooldowns = {},
        EquippedSkills = {}
    }
    
    -- Give default E.G.O (optional)
    playerData[player].EquippedSkills["Pale Sword"] = true
end

local function cleanupPlayer(player)
    playerData[player] = nil
end

-- E.G.O activation handler
events.ActivateEGO.OnServerEvent:Connect(function(player, EGOName)
    if not playerData[player] then return end
    if not playerData[player].EquippedSkills[EGOName] then return end
    
    local data = EGOSkills[EGOName]
    if not data then return end
    
    -- Check cooldown
    if playerData[player].Cooldowns[EGOName] and 
       os.time() - playerData[player].Cooldowns[EGOName] < data.Cooldown then
        return
    end
    
    -- Set cooldown
    playerData[player].Cooldowns[EGOName] = os.time()
    events.EGOCooldown:FireClient(player, EGOName, data.Cooldown)
    
    -- Get character
    local character = player.Character
    if not character then return end
    
    -- Apply skill effects
    if EGOName == "Pale Sword" then
        -- Pale damage effect
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Create hitbox
            local hitbox = Instance.new("Part")
            hitbox.Size = Vector3.new(5, 5, data.Range)
            hitbox.CFrame = character:GetPivot() * CFrame.new(0, 0, -data.Range/2)
            hitbox.Anchored = true
            hitbox.CanCollide = false
            hitbox.Transparency = 1
            hitbox.Parent = workspace
            
            -- Damage enemies in hitbox
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        local root = otherChar:FindFirstChild("HumanoidRootPart")
                        if root and (root.Position - hitbox.Position).Magnitude <= data.Range then
                            local otherHumanoid = otherChar:FindFirstChildOfClass("Humanoid")
                            if otherHumanoid then
                                otherHumanoid:TakeDamage(data.Damage)
                                
                                -- Apply pale effect (slow)
                                local slow = Instance.new("BoolValue")
                                slow.Name = "PaleSlow"
                                slow.Parent = otherHumanoid
                                
                                -- Reduce speed
                                otherHumanoid.WalkSpeed = otherHumanoid.WalkSpeed * 0.5
                                
                                -- Remove after duration
                                game:GetService("Debris"):AddItem(slow, 5)
                                delay(5, function()
                                    if otherHumanoid and otherHumanoid.Parent then
                                        otherHumanoid.WalkSpeed = otherHumanoid.WalkSpeed / 0.5
                                    end
                                end)
                            end
                        end
                    end
                end
            end
            
            game:GetService("Debris"):AddItem(hitbox, 0.5)
        end
        
    elseif EGOName == "Red Shoes" then
        -- Bleed effect
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Create hitbox
            local hitbox = Instance.new("Part")
            hitbox.Size = Vector3.new(3, 3, data.Range)
            hitbox.CFrame = character:GetPivot() * CFrame.new(0, 0, -data.Range/2)
            hitbox.Anchored = true
            hitbox.CanCollide = false
            hitbox.Transparency = 1
            hitbox.Parent = workspace
            
            -- Damage enemies in hitbox
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        local root = otherChar:FindFirstChild("HumanoidRootPart")
                        if root and (root.Position - hitbox.Position).Magnitude <= data.Range then
                            local otherHumanoid = otherChar:FindFirstChildOfClass("Humanoid")
                            if otherHumanoid then
                                otherHumanoid:TakeDamage(data.Damage * 0.5) -- Initial damage
                                
                                -- Apply bleed effect (DoT)
                                local bleed = Instance.new("IntValue")
                                bleed.Name = "Bleed"
                                bleed.Value = data.Damage * 0.1 -- Damage per tick
                                bleed.Parent = otherHumanoid
                                
                                -- Damage over time
                                for i = 1, 5 do
                                    wait(1)
                                    if otherHumanoid and otherHumanoid.Parent then
                                        otherHumanoid:TakeDamage(bleed.Value)
                                    else
                                        break
                                    end
                                end
                                
                                game:GetService("Debris"):AddItem(bleed, 5)
                            end
                        end
                    end
                end
            end
            
            game:GetService("Debris"):AddItem(hitbox, 0.5)
        end
    end
    
    -- Notify client activation was successful
    events.EGOReady:FireClient(player, EGOName, false)
    
    -- Set cooldown complete
    delay(data.Cooldown, function()
        if player and player.Parent then
            events.EGOReady:FireClient(player, EGOName, true)
        end
    end)
end)

-- Player connection handlers
Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(cleanupPlayer)

-- Cleanup on server shutdown
game:BindToClose(function()
    for _, player in pairs(Players:GetPlayers()) do
        cleanupPlayer(player)
    end
end)