local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shortcutGUI = playerGui:WaitForChild("ShortcutGUI")
local popupScreen = shortcutGUI:WaitForChild("PopupScreen")

local keysDown = {
    R = false,
    C = false
}

local function togglePopup(show)
    local tweenTime = 0.25
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad)
    
    if show then
        popupScreen.Visible = true
        popupScreen.Size = UDim2.new(0, 0, 0, 0)
        
        local sizeTween = TweenService:Create(popupScreen, tweenInfo, {
            Size = UDim2.new(0.7, 0, 0.7, 0),
            BackgroundTransparency = 0.1
        })
        sizeTween:Play()
    else
        local sizeTween = TweenService:Create(popupScreen, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        sizeTween:Play()
        
        sizeTween.Completed:Connect(function()
            popupScreen.Visible = false
            popupScreen.BackgroundTransparency = 0.1
        })
    end
end

local function inputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        keysDown.R = true
    elseif input.KeyCode == Enum.KeyCode.C then
        keysDown.C = true
    end
    
    if keysDown.R and keysDown.C then
        togglePopup(not popupScreen.Visible)
        -- Reset keys to prevent rapid toggling
        keysDown.R = false
        keysDown.C = false
    end
end

local function inputEnded(input)
    if input.KeyCode == Enum.KeyCode.R then
        keysDown.R = false
    elseif input.KeyCode == Enum.KeyCode.C then
        keysDown.C = false
    end
end

UserInputService.InputBegan:Connect(inputBegan)
UserInputService.InputEnded:Connect(inputEnded)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and popupScreen.Visible then
        local mousePos = input.Position
        local absPos = popupScreen.AbsolutePosition
        local absSize = popupScreen.AbsoluteSize
        
        if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
           mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
            togglePopup(false)
        end
    end
end)