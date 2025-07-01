-- StarterGui -> DesktopUI -> LocalScript: MainMenuHandler

local player = game.Players.LocalPlayer
local gui = script.Parent

local panel = gui:WaitForChild("Panel")
local startMenu = gui:WaitForChild("StartMenu")
local startButton = panel:WaitForChild("StartButton")

-- Toggle Start Menu
startButton.MouseButton1Click:Connect(function()
	startMenu.Visible = not startMenu.Visible
end)

-- Open a fake App Window
local openAppButton = startMenu:WaitForChild("OpenAppButton")
local windowTemplate = gui:WaitForChild("WindowTemplate")

openAppButton.MouseButton1Click:Connect(function()
	local newWindow = windowTemplate:Clone()
	newWindow.Parent = gui
	newWindow.Position = UDim2.new(0.3, 0, 0.3, 0)
	newWindow.Visible = true
end)