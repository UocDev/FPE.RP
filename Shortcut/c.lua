local closeButton = popupLayer:WaitForChild("CloseButton")
closeButton.MouseButton1Click:Connect(function()
    togglePopup(false)
end)
