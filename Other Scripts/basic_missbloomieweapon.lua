-- Server Script (place in ServerScriptService)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuration
local TARGET_NAME = "Miss Bloomie"
local REQUIRED_PLAYTIME = 7200 -- 2 hours in seconds

-- Track playtime for each player
local playtimeTracker = {}

-- Function to update player name if conditions are met
local function updatePlayerName(player)
    local playtime = playtimeTracker[player.UserId]
    if playtime and playtime >= REQUIRED_PLAYTIME then
        -- Change the player's display name
        player.DisplayName = TARGET_NAME
        print(player.Name .. "'s display name has been updated to: " .. TARGET_NAME)
    end
end

-- Track playtime for players
Players.PlayerAdded:Connect(function(player)
    -- Initialize playtime for the player
    playtimeTracker[player.UserId] = 0

    -- Update playtime every second
    local connection
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        playtimeTracker[player.UserId] = playtimeTracker[player.UserId] + deltaTime
        updatePlayerName(player)
    end)

    -- Clean up when the player leaves
    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) then
            connection:Disconnect()
            playtimeTracker[player.UserId] = nil
        end
    end)
end)
