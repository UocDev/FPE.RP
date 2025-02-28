local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Remote Events
local AttackEvent = Instance.new("RemoteEvent", ReplicatedStorage)
AttackEvent.Name = "WeaponAttack"

local SwitchEvent = Instance.new("RemoteEvent", ReplicatedStorage)
SwitchEvent.Name = "WeaponSwitch"

local RerollEvent = Instance.new("RemoteEvent", ReplicatedStorage)
RerollEvent.Name = "WeaponReroll"

-- Weapons List (Modify as needed)
local weaponList = {"Sword", "Gun", "Bow", "Axe"}

-- Weapon Attack Function
local function onWeaponAttack(player)
    local character = player.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            print(player.Name .. " attacked with " .. tool.Name)
            -- Add attack logic (damage, animation, etc.)
        else
            print("No weapon equipped")
        end
    end
end

-- Weapon Switch Function
local function onWeaponSwitch(player)
    local character = player.Character
    if character then
        local backpack = player.Backpack
        local tools = backpack:GetChildren()
        if #tools > 0 then
            local currentWeapon = character:FindFirstChildOfClass("Tool")
            if currentWeapon then
                currentWeapon.Parent = backpack
            end
            tools[1].Parent = character
            print(player.Name .. " switched to " .. tools[1].Name)
        else
            print("No weapons in backpack")
        end
    end
end

-- Weapon Reroll (Cutter Box) Function
local function onWeaponReroll(player)
    local character = player.Character
    if character then
        local backpack = player.Backpack
        local newWeaponName = weaponList[math.random(1, #weaponList)]

        -- Remove current weapons
        for _, tool in ipairs(backpack:GetChildren()) do
            tool:Destroy()
        end
        
        -- Give new weapon
        local newWeapon = Instance.new("Tool")
        newWeapon.Name = newWeaponName
        newWeapon.Parent = backpack
        print(player.Name .. " rerolled and got " .. newWeaponName)
    end
end

-- Event Listeners
AttackEvent.OnServerEvent:Connect(onWeaponAttack)
SwitchEvent.OnServerEvent:Connect(onWeaponSwitch)
RerollEvent.OnServerEvent:Connect(onWeaponReroll)