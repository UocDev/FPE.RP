-- Place this script inside the button/part in Workspace
local button = script.Parent

-- Configuration
local CHARACTER_ASSET_ID = "rbxassetid://YOUR_CHARACTER_ASSET_ID"  -- Replace with your asset ID

-- Create humanoid description for the new character
local humanoidDescription = Instance.new("HumanoidDescription")
humanoidDescription.Head = CHARACTER_ASSET_ID  -- Set main body part
-- Add more asset IDs for other body parts if needed:
-- humanoidDescription.LeftArm = "rbxassetid://123"
-- humanoidDescription.RightLeg = "rbxassetid://456"

button.Touched:Connect(function(hit)
    local character = hit.Parent
    local player = game.Players:GetPlayerFromCharacter(character)
    
    if player then
        -- Load new character
        player:LoadCharacterWithDescription(humanoidDescription)
        
        -- Optional: Move new character to button position
        local newCharacter = player.Character
        if newCharacter then
            newCharacter:MoveTo(button.Position + Vector3.new(0, 5, 0))
        end
    end
end)