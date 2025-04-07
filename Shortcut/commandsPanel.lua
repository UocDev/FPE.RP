local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shortcutGUI = playerGui:WaitForChild("ShortcutGUI")
local popupLayer = shortcutGUI:WaitForChild("PopupLayer")

popupLayer.Visible = false

local mPressed = false
local cPressed = false

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.M then
        mPressed = true
    elseif input.KeyCode == Enum.KeyCode.C then
        cPressed = true
    end
    
    if mPressed and cPressed then
        popupLayer.Visible = not popupLayer.Visible -- Toggle visibility
    end
end

local function onInputEnded(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.M then
        mPressed = false
    elseif input.KeyCode == Enum.KeyCode.C then
        cPressed = false
    end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
