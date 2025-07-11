local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerDatabase") -- Database name

local function savePlayerData(player)
    local key = "Player_" .. player.UserId -- Unique key for each player
    local data = {
        JoinDate = player:GetAttribute("JoinDate"),
        PlayTime = player:GetAttribute("PlayTime")
    }
    playerDataStore:SetAsync(key, data)
end

local function loadPlayerData(player)
    local key = "Player_" .. player.UserId
    local data = playerDataStore:GetAsync(key)

    if data then
        player:SetAttribute("JoinDate", data.JoinDate)
        player:SetAttribute("PlayTime", data.PlayTime)
        player:SetAttribute("Coins", data.Coins)
    else
        -- Set default values if new player
        player:SetAttribute("JoinDate", os.date("%Y-%m-%d"))
        player:SetAttribute("PlayTime", 0)
        player:SetAttribute("Coins", 0)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    loadPlayerData(player)

    -- Track playtime
    while player do
        local playTime = player:GetAttribute("PlayTime") or 0
        player:SetAttribute("PlayTime", playTime + 1)
        task.wait(10) -- Update every minute
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
end)

game:BindToClose(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        savePlayerData(player)
    end
end)
