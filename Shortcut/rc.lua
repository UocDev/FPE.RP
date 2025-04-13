local closeButton = Instance.new("TextButton")
   closeButton.Name = "CloseButton"
   closeButton.Text = "X"
   closeButton.Size = UDim2.new(0, 30, 0, 30)
   closeButton.Position = UDim2.new(1, -35, 0, 5)
   closeButton.TextScaled = true
   closeButton.Parent = popupScreen
   
   closeButton.MouseButton1Click:Connect(function()
       togglePopup(false)
   end)