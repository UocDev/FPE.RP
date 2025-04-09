local TweenService = game:GetService("TweenService")

local function togglePopup(show)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    
    if show then
        popupScreen.BackgroundTransparency = 1
        popupScreen.Visible = true
        TweenService:Create(popupScreen, tweenInfo, {BackgroundTransparency = 0.5}):Play()
    else
        TweenService:Create(popupScreen, tweenInfo, {BackgroundTransparency = 1}):Play()
        task.delay(0.3, function()
            popupScreen.Visible = false
        end)
    end
end
