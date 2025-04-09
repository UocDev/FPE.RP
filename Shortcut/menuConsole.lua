local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shortcutGUI = playerGui:WaitForChild("ShortcutGUI")
local popupScreen = shortcutGUI:WaitForChild("PopupScreen")

local keysPressed = {
    [Enum.KeyCode.M] = false,
    [Enum.KeyCode.C] = false
}

local function handleInput(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.M or input.KeyCode == Enum.KeyCode.C then
        keysPressed[input.KeyCode] = true
       
        if keysPressed[Enum.KeyCode.M] and keysPressed[Enum.KeyCode.C] then
            popupScreen.Visible = not popupScreen.Visible
        end
    end
end

local function handleInputEnd(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.M or input.KeyCode == Enum.KeyCode.C then
        keysPressed[input.KeyCode] = false
    end
end

UserInputService.InputBegan:Connect(handleInput)
UserInputService.InputEnded:Connect(handleInputEnd)

popupScreen.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        popupScreen.Visible = false
    end
end)
