local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- Custom time settings
local timeScale = 60 -- 1 real second = X game seconds
local currentTime = 0 -- Start time in seconds (e.g., 0 = midnight)
local dayLength = 24 * 60 * 60 -- 24 hours in seconds

-- Lighting settings
local sunrise = 6 * 60 * 60 -- 6 AM in seconds
local sunset = 18 * 60 * 60 -- 6 PM in seconds

-- Function to update lighting based on time
local function updateLighting(time)
    if time < sunrise or time >= sunset then
        -- Night time
        Lighting.ClockTime = 0 -- Set to midnight for night effect
        Lighting.OutdoorAmbient = Color3.new(0.1, 0.1, 0.2) -- Dark blue ambient light
        Lighting.FogColor = Color3.new(0.1, 0.1, 0.2) -- Dark blue fog
        Lighting.FogEnd = 500 -- Adjust fog distance
    else
        -- Day time
        local hour = (time / 3600) % 24
        Lighting.ClockTime = hour -- Sync with custom time
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1) -- Bright white ambient light
        Lighting.FogColor = Color3.new(0.8, 0.8, 0.8) -- Light fog
        Lighting.FogEnd = 1000 -- Adjust fog distance
    end
end

-- Main loop to update time and lighting
RunService.Heartbeat:Connect(function(deltaTime)
    currentTime = (currentTime + deltaTime * timeScale) % dayLength
    updateLighting(currentTime)
end)
