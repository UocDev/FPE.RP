local TextLabel = script.Parent -- Assuming you have a TextLabel in the GUI

local function formatTime(time)
    local hours = math.floor(time / 3600) % 24
    local minutes = math.floor((time % 3600) / 60)
    return string.format("%02d:%02d", hours, minutes)
end

RunService.Heartbeat:Connect(function(deltaTime)
    currentTime = (currentTime + deltaTime * timeScale) % dayLength
    updateLighting(currentTime)
    TextLabel.Text = formatTime(currentTime) -- Update the GUI clock
end)
