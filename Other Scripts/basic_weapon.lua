-- Define the player and tools
local player = game.Players.LocalPlayer
local backpack = player.Backpack
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- List of available weapons
local weapons = {
    "Cutter Box",
    "Sword",
    "Axe",
    "Hammer"
}

-- Function to equip a weapon
local function equipWeapon(weaponName)
    for _, tool in pairs(backpack:GetChildren()) do
        if tool.Name == weaponName then
            humanoid:EquipTool(tool)
            break
        end
    end
end

-- Function to attack with the equipped weapon
local function attack()
    local equippedTool = character:FindFirstChildOfClass("Tool")
    if equippedTool then
        -- Trigger the attack animation or logic here
        print("Attacking with: " .. equippedTool.Name)
    else
        warn("No weapon equipped!")
    end
end

-- Function to switch weapons
local function switchWeapon(weaponIndex)
    if weaponIndex > 0 and weaponIndex <= #weapons then
        local weaponName = weapons[weaponIndex]
        equipWeapon(weaponName)
        print("Switched to: " .. weaponName)
    else
        warn("Invalid weapon index!")
    end
end

-- Function to reroll the current weapon
local function rerollWeapon()
    local randomIndex = math.random(1, #weapons)
    local newWeapon = weapons[randomIndex]
    equipWeapon(newWeapon)
    print("Rerolled to: " .. newWeapon)
end

-- Input bindings for weapon switch and reroll
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Switch weapons using number keys (1, 2, 3, etc.)
    if input.KeyCode == Enum.KeyCode.One then
        switchWeapon(1)
    elseif input.KeyCode == Enum.KeyCode.Two then
        switchWeapon(2)
    elseif input.KeyCode == Enum.KeyCode.Three then
        switchWeapon(3)
    end

    -- Reroll weapon using the "R" key
    if input.KeyCode == Enum.KeyCode.R then
        rerollWeapon()
    end
end)

-- Attack on mouse click
local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    attack()
end)

-- Equip the first weapon by default
equipWeapon(weapons[1])