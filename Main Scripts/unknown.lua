local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerDatabase") -- Database name

local function savePlayerData(player)
    local key = "Player_" .. player.UserId -- Unique key for each player
    local data = {
        JoinDate = player:GetAttribute("JoinDate"),
        PlayTime = player:GetAttribute("PlayTime"),
        Coins = player:GetAttribute("Coins")
    }
    playerDataStore:SetAsync(key, data)
end