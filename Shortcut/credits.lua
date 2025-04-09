local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shortcutGUI = playerGui:WaitForChild("AltShortcutGUI")
local popupLayer = shortcutGUI:WaitForChild("PopupLayer")

local altPressed = false
local cPressed = false

local TweenService = game:GetService("TweenService")
local function togglePopup(show)
    if show then
        popupLayer.Visible = true
        popupLayer.Size = UDim2.new(0, 0, 0, 0)
        local sizeTween = TweenService:Create(popupLayer, TweenInfo.new(0.3), {
            Size = UDim2.new(0.8, 0, 0.8, 0)
        })
        sizeTween:Play()
    else
        local sizeTween = TweenService:Create(popupLayer, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        sizeTween:Play()
        sizeTween.Completed:Wait()
        popupLayer.Visible = false
    end
end

local function handleInput(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        altPressed = true
    elseif input.KeyCode == Enum.KeyCode.C then
        cPressed = true
    end
    
    if altPressed and cPressed then
        togglePopup(not popupLayer.Visible)
        altPressed = false
        cPressed = false
    end
end

local function handleInputEnd(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        altPressed = false
    elseif input.KeyCode == Enum.KeyCode.C then
        cPressed = false
    end
end

UserInputService.InputBegan:Connect(handleInput)
UserInputService.InputEnded:Connect(handleInputEnd)

popupLayer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = input.Position
        local absPos = popupLayer.AbsolutePosition
        local absSize = popupLayer.AbsoluteSize
        
        if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
           mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
            togglePopup(false)
        end
    end
end)
