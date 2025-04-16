-- Last Man Standing / Last Student Standing Game Script
-- Place this in ServerScriptService

local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Game configuration
local GameConfig = {
    MinPlayers = 2,                  -- Minimum players to start game
    LobbyWaitTime = 30,              -- Time to wait in lobby (seconds)
    RoundDuration = 300,             -- Round duration (seconds)
    RespawnTime = 5,                 -- Time before eliminated players spectate
    SafeZoneShrinkTime = 240,        -- When safe zone starts shrinking (seconds)
    SafeZoneShrinkDuration = 60,     -- How long it takes to shrink (seconds)
    SafeZoneFinalSize = 50,          -- Final safe zone size (studs)
    EnableFallDamage = true,         -- Whether fall damage is enabled
    FallDamageThreshold = 50,        -- Height threshold for fall damage
    EnableTeamDamage = false,        -- Whether players can damage teammates
    MapVotingEnabled = true,         -- Whether players can vote for next map
    MaxRounds = 5,                   -- Maximum rounds before game ends
    WinReward = 100,                 -- Currency reward for winning
    ParticipationReward = 25         -- Currency reward for participating
}

-- Game state
local GameState = {
    WaitingForPlayers = "WaitingForPlayers",
    Lobby = "Lobby",
    InProgress = "InProgress",
    Intermission = "Intermission",
    GameOver = "GameOver"
}

-- Current game variables
local currentState = GameState.WaitingForPlayers
local roundNumber = 0
local timeRemaining = 0
local alivePlayers = {}
local safeZone = nil
local originalSafeZoneSize = 0
local shrinkingSafeZone = false
local selectedMap = nil

-- Create remote events/functions
local events = {
    GameStateChanged = Instance.new("RemoteEvent"),
    PlayerEliminated = Instance.new("RemoteEvent"),
    UpdateTimer = Instance.new("RemoteEvent"),
    SafeZoneUpdate = Instance.new("RemoteEvent"),
    ShowWinner = Instance.new("RemoteEvent")
}

for name, event in pairs(events) do
    event.Name = name
    event.Parent = ReplicatedStorage
end

-- Helper functions
local function createSafeZone()
    if safeZone then safeZone:Destroy() end
    
    -- Find spawn locations in the map
    local spawns = Workspace:FindFirstChild("SpawnPoints")
    if not spawns or #spawns:GetChildren() == 0 then
        spawns = Workspace:FindFirstChild("Terrain") or Workspace
    end
    
    -- Calculate center and size of safe zone
    local center = spawns:GetBoundingBox()
    local size = math.max(center.Size.X, center.Size.Z) * 1.5
    originalSafeZoneSize = size
    
    -- Create safe zone part
    safeZone = Instance.new("Part")
    safeZone.Name = "SafeZone"
    safeZone.Size = Vector3.new(size, 10, size)
    safeZone.Position = center.Position - Vector3.new(0, center.Size.Y/2 - 5, 0)
    safeZone.Anchored = true
    safeZone.CanCollide = false
    safeZone.Transparency = 0.7
    safeZone.Color = Color3.fromRGB(0, 255, 0)
    safeZone.Material = Enum.Material.Neon
    safeZone.TopSurface = Enum.SurfaceType.Smooth
    safeZone.BottomSurface = Enum.SurfaceType.Smooth
    
    -- Add safe zone visual effects
    local ring = Instance.new("Part")
    ring.Size = Vector3.new(size + 20, 1, size + 20)
    ring.Position = safeZone.Position
    ring.Anchored = true
    ring.CanCollide = false
    ring.Transparency = 0.5
    ring.Color = Color3.fromRGB(0, 200, 0)
    ring.Material = Enum.Material.Neon
    ring.Name = "SafeZoneRing"
    
    -- Add to workspace
    safeZone.Parent = Workspace
    ring.Parent = Workspace
    
    return safeZone
end

local function shrinkSafeZone()
    if not safeZone or shrinkingSafeZone then return end
    shrinkingSafeZone = true
    
    local startTime = time()
    local endTime = startTime + GameConfig.SafeZoneShrinkDuration
    local startSize = safeZone.Size
    local endSize = Vector3.new(GameConfig.SafeZoneFinalSize, 10, GameConfig.SafeZoneFinalSize)
    
    while time() < endTime do
        local progress = (time() - startTime) / GameConfig.SafeZoneShrinkDuration
        local newSize = startSize:Lerp(endSize, progress)
        safeZone.Size = newSize
        
        -- Update ring size
        local ring = Workspace:FindFirstChild("SafeZoneRing")
        if ring then
            ring.Size = Vector3.new(newSize.X + 20, 1, newSize.Z + 20)
        end
        
        events.SafeZoneUpdate:FireAllClients(safeZone.Position, newSize)
        wait(0.1)
    end
    
    safeZone.Size = endSize
    shrinkingSafeZone = false
end

local function eliminatePlayer(player, eliminator)
    if not alivePlayers[player] then return end
    
    alivePlayers[player] = nil
    
    -- Handle elimination
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
    
    -- Send elimination event
    events.PlayerEliminated:FireAllClients(player, eliminator)
    
    -- Check if game should end
    if #alivePlayers == 1 then
        endRound(next(alivePlayers))
    elseif #alivePlayers == 0 then
        endRound(nil) -- Draw
    end
end

local function respawnPlayer(player)
    player:LoadCharacter()
    local character = player.Character
    if character then
        -- Move to random spawn point
        local spawnPoints = Workspace:FindFirstChild("SpawnPoints")
        if spawnPoints and #spawnPoints:GetChildren() > 0 then
            local randomSpawn = spawnPoints:GetChildren()[math.random(1, #spawnPoints:GetChildren())]
            character:SetPrimaryPartCFrame(randomSpawn.CFrame + Vector3.new(0, 5, 0))
        end
    end
end

local function startRound()
    roundNumber += 1
    currentState = GameState.InProgress
    timeRemaining = GameConfig.RoundDuration
    
    -- Reset alive players
    alivePlayers = {}
    for _, player in pairs(Players:GetPlayers()) do
        alivePlayers[player] = true
        respawnPlayer(player)
    end
    
    -- Create safe zone
    createSafeZone()
    shrinkingSafeZone = false
    
    -- Notify clients
    events.GameStateChanged:FireAllClients(currentState, roundNumber)
    
    -- Start round timer
    while timeRemaining > 0 and currentState == GameState.InProgress do
        wait(1)
        timeRemaining -= 1
        events.UpdateTimer:FireAllClients(timeRemaining)
        
        -- Start shrinking safe zone
        if timeRemaining <= GameConfig.RoundDuration - GameConfig.SafeZoneShrinkTime and not shrinkingSafeZone then
            shrinkSafeZone()
        end
        
        -- Check for players outside safe zone
        for player, _ in pairs(alivePlayers) do
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local distance = (rootPart.Position - safeZone.Position).Magnitude
                if distance > safeZone.Size.X / 2 then
                    -- Player is outside safe zone - damage them
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:TakeDamage(5) -- Damage per second outside zone
                        
                        -- Eliminate if health reaches 0
                        if humanoid.Health <= 0 then
                            eliminatePlayer(player, nil) -- Eliminated by zone
                        end
                    end
                end
            end
        end
    end
    
    -- If time ran out with multiple players alive
    if currentState == GameState.InProgress and #alivePlayers > 1 then
        -- Eliminate all but one random player
        local playersLeft = {}
        for player, _ in pairs(alivePlayers) do
            table.insert(playersLeft, player)
        end
        
        -- Randomly eliminate until one remains
        while #playersLeft > 1 do
            local randomIndex = math.random(1, #playersLeft)
            eliminatePlayer(playersLeft[randomIndex], nil)
            table.remove(playersLeft, randomIndex)
        end
        
        -- Last player wins
        if #playersLeft == 1 then
            endRound(playersLeft[1])
        else
            endRound(nil) -- Shouldn't happen but just in case
        end
    end
end

local function endRound(winner)
    currentState = GameState.Intermission
    events.GameStateChanged:FireAllClients(currentState, roundNumber)
    
    -- Announce winner
    if winner then
        events.ShowWinner:FireAllClients(winner)
        
        -- Give rewards
        local leaderstats = winner:FindFirstChild("leaderstats")
        if leaderstats then
            local wins = leaderstats:FindFirstChild("Wins")
            if wins then
                wins.Value += 1
            end
        end
    end
    
    -- Wait before next round or end game
    wait(5)
    
    if roundNumber >= GameConfig.MaxRounds then
        -- Game over
        currentState = GameState.GameOver
        events.GameStateChanged:FireAllClients(currentState, roundNumber)
        wait(10)
        
        -- Reset for new game
        currentState = GameState.WaitingForPlayers
        roundNumber = 0
        events.GameStateChanged:FireAllClients(currentState, roundNumber)
    else
        -- Start next round
        startLobby()
    end
end

local function startLobby()
    currentState = GameState.Lobby
    timeRemaining = GameConfig.LobbyWaitTime
    events.GameStateChanged:FireAllClients(currentState, roundNumber)
    
    -- Reset all players
    for _, player in pairs(Players:GetPlayers()) do
        respawnPlayer(player)
    end
    
    -- Lobby countdown
    while timeRemaining > 0 and #Players:GetPlayers() >= GameConfig.MinPlayers do
        wait(1)
        timeRemaining -= 1
        events.UpdateTimer:FireAllClients(timeRemaining)
    end
    
    -- Check if we have enough players to start
    if #Players:GetPlayers() >= GameConfig.MinPlayers then
        startRound()
    else
        -- Not enough players, back to waiting
        currentState = GameState.WaitingForPlayers
        events.GameStateChanged:FireAllClients(currentState, roundNumber)
    end
end

-- Player connections
Players.PlayerAdded:Connect(function(player)
    -- Create leaderstats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    
    local wins = Instance.new("IntValue")
    wins.Name = "Wins"
    wins.Value = 0
    wins.Parent = leaderstats
    
    local kills = Instance.new("IntValue")
    kills.Name = "Kills"
    kills.Value = 0
    kills.Parent = leaderstats
    
    leaderstats.Parent = player
    
    -- Handle character added
    player.CharacterAdded:Connect(function(character)
        if currentState == GameState.InProgress then
            -- If joining mid-game, add to alive players
            alivePlayers[player] = true
        end
        
        -- Set up humanoid
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            wait(GameConfig.RespawnTime)
            if currentState == GameState.InProgress and alivePlayers[player] then
                respawnPlayer(player)
            end
        end)
    end)
    
    -- Start game if we have enough players
    if currentState == GameState.WaitingForPlayers and #Players:GetPlayers() >= GameConfig.MinPlayers then
        startLobby()
    end
end)

Players.PlayerRemoved:Connect(function(player)
    -- Remove from alive players
    alivePlayers[player] = nil
    
    -- Check if round should end
    if currentState == GameState.InProgress then
        if #alivePlayers == 1 then
            endRound(next(alivePlayers))
        elseif #alivePlayers == 0 then
            endRound(nil) -- Draw
        end
    end
end)

-- Damage handling
local function onCharacterTakeDamage(character, damage, attacker)
    if currentState ~= GameState.InProgress then return end
    
    local player = Players:GetPlayerFromCharacter(character)
    if not player or not alivePlayers[player] then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Check if attacker is a player
    local attackingPlayer = nil
    if attacker and attacker:IsA("Player") then
        attackingPlayer = attacker
    elseif attacker and attacker:IsA("Model") then
        attackingPlayer = Players:GetPlayerFromCharacter(attacker)
    end
    
    -- Handle team damage
    if attackingPlayer and attackingPlayer ~= player then
        if not GameConfig.EnableTeamDamage then
            -- Cancel damage if team damage is disabled
            humanoid.Health += damage
            return
        end
        
        -- Track kills
        if humanoid.Health <= 0 then
            local leaderstats = attackingPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                local kills = leaderstats:FindFirstChild("Kills")
                if kills then
                    kills.Value += 1
                end
            end
        end
    end
    
    -- Eliminate if health reaches 0
    if humanoid.Health <= 0 then
        eliminatePlayer(player, attackingPlayer)
    end
end

-- Connect damage events
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then
                onCharacterTakeDamage(character, 0, nil)
            end
        end)
    end)
end)

-- Fall damage
if GameConfig.EnableFallDamage then
    game:GetService("Workspace").FallenPartsDestroyHeight = 0
    
    local function handleFallDamage(character)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if
