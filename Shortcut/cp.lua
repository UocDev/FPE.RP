-- Config file from CommandsPanel.lua

local tweenService = game:GetService("TweenService")

local function togglePopup(visible)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    local goal = {}
    
    if visible then
        goal.BackgroundTransparency = 0
        popupLayer.Visible = true
    else
        goal.BackgroundTransparency = 1
    end
    
    local tween = tweenService:Create(popupLayer, tweenInfo, goal)
    tween:Play()
    
    if not visible then
        tween.Completed:Connect(function()
            popupLayer.Visible = false
        end)
    end
end
