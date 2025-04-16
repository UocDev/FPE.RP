-- Movement Configuration Script
-- Place this in StarterCharacterScripts or a LocalScript in the player's character

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Movement Configuration Settings
local movementConfig = {
    WalkSpeed = 16,                -- Default walking speed
    RunSpeed = 24,                 -- Speed when sprinting
    JumpPower = 50,                -- Jump height
    SprintEnabled = true,          -- Whether sprinting is allowed
    CrouchEnabled = true,          -- Whether crouching is allowed
    CrouchSpeed = 8,               -- Speed when crouching
    AirControl = 0.5,              -- How much control you have in air (0-1)
    Acceleration = 0.15,           -- How quickly you reach max speed
    Deceleration = 0.25,           -- How quickly you stop when not moving
    AutoJumpEnabled = false,       -- Whether auto-jump over small obstacles is enabled
    SwimSpeed = 12,                -- Speed when swimming
    ClimbSpeed = 10                -- Speed when climbing
}

-- Apply initial movement settings
humanoid.WalkSpeed = movementConfig.WalkSpeed
humanoid.JumpPower = movementConfig.JumpPower

-- Sprinting variables
local isSprinting = false
local sprintKey = Enum.KeyCode.LeftShift

-- Crouching variables
local isCrouching = false
local crouchKey = Enum.KeyCode.LeftControl
local originalHeight = humanoid.HipHeight

-- Input handling
local function handleInput(input, gameProcessed)
    if gameProcessed then return end
    
    -- Sprinting
    if movementConfig.SprintEnabled and input.KeyCode == sprintKey then
        if input.UserInputState == Enum.UserInputState.Begin then
            isSprinting = true
            humanoid.WalkSpeed = movementConfig.RunSpeed
        elseif input.UserInputState == Enum.UserInputState.End then
            isSprinting = false
            humanoid.WalkSpeed = isCrouching and movementConfig.CrouchSpeed or movementConfig.WalkSpeed
        end
    end
    
    -- Crouching
    if movementConfig.CrouchEnabled and input.KeyCode == crouchKey then
        if input.UserInputState == Enum.UserInputState.Begin then
            isCrouching = true
            humanoid.HipHeight = originalHeight - 1  -- Lower the character
            humanoid.WalkSpeed = movementConfig.CrouchSpeed
        elseif input.UserInputState == Enum.UserInputState.End then
            isCrouching = false
            humanoid.HipHeight = originalHeight     -- Return to normal height
            humanoid.WalkSpeed = isSprinting and movementConfig.RunSpeed or movementConfig.WalkSpeed
        end
    end
end

UserInputService.InputBegan:Connect(handleInput)
UserInputService.InputEnded:Connect(handleInput)

-- Air control implementation
local function updateAirControl()
    if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local moveDirection = humanoid.MoveDirection
            local currentVelocity = rootPart.Velocity
            
            -- Only apply air control if the player is trying to move
            if moveDirection.Magnitude > 0 then
                local desiredVelocity = moveDirection * (isSprinting and movementConfig.RunSpeed or movementConfig.WalkSpeed)
                local newVelocity = currentVelocity:Lerp(Vector3.new(desiredVelocity.X, currentVelocity.Y, desiredVelocity.Z), movementConfig.AirControl)
                rootPart.Velocity = newVelocity
            end
        end
    end
end

-- Movement state changes
humanoid.StateChanged:Connect(function(oldState, newState)
    -- Reset movement speed when landing
    if newState == Enum.HumanoidStateType.Landed then
        if isCrouching then
            humanoid.WalkSpeed = movementConfig.CrouchSpeed
        elseif isSprinting then
            humanoid.WalkSpeed = movementConfig.RunSpeed
        else
            humanoid.WalkSpeed = movementConfig.WalkSpeed
        end
    end
    
    -- Auto jump when walking into small obstacles
    if movementConfig.AutoJumpEnabled and newState == Enum.HumanoidStateType.Running then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local origin = rootPart.Position
            local direction = rootPart.CFrame.LookVector * 3  -- Check 3 studs ahead
            local raycastResult = workspace:Raycast(origin, direction, raycastParams)
            
            if raycastResult and raycastResult.Instance.CanCollide then
                local normal = raycastResult.Normal
                local angle = math.deg(math.acos(normal.Y))
                
                -- If obstacle is low enough to jump over
                if angle > 30 and angle < 60 and raycastResult.Distance < 2 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end
end)

-- Update loop for air control
RunService.Heartbeat:Connect(function()
    updateAirControl()
end)

-- Handle character respawns
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    originalHeight = humanoid.HipHeight
    
    -- Reapply settings
    humanoid.WalkSpeed = isCrouching and movementConfig.CrouchSpeed or (isSprinting and movementConfig.RunSpeed or movementConfig.WalkSpeed)
    humanoid.JumpPower = movementConfig.JumpPower
    
    -- Reconnect events
    humanoid.StateChanged:Connect(function(oldState, newState)
        -- Same state change logic as above
    end)
end)
