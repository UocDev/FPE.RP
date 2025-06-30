--;If you think Yamiki is only system info, you can play as her

-- Define the character model (usually a player's character)
local character = script.Parent -- Assumes the script is inside the character model

-- Check if the character has a Humanoid (required for movement)
local humanoid = character:FindFirstChild("Humanoid")
if not humanoid then
    warn("No Humanoid found in the character!")
    return
end

-- Function to make the character jump
local function onCharacterClick()
    if humanoid and humanoid.Health > 0 then
        humanoid.Jump = true -- Makes the character jump
    end
end

-- Connect the function to the character's ClickDetector (if it exists)
local clickDetector = character:FindFirstChild("ClickDetector")
if clickDetector then
    clickDetector.MouseClick:Connect(onCharacterClick)
else
    warn("No ClickDetector found in the character!")
end
