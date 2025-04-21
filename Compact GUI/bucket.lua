local toggle = script.Parent
local mainFrame = script.Parent.Parent:WaitForChild("MainFrame")

local open = true
toggle.Text = "Close"

toggle.MouseButton1Click:Connect(function()
	open = not open
	mainFrame.Visible = open
	toggle.Text = open and "Close" or "Open"
end)
-- ANIMATION
local TweenService = game:GetService("TweenService")

local goal = {}
goal.Position = open and UDim2.new(0.8, 0, 0.05, 0) or UDim2.new(1.5, 0, 0.05, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), goal):Play()
