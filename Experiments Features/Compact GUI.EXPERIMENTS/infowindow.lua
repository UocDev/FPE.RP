local TweenService = game:GetService("TweenService")
local gui = script.Parent

local windowOne = gui:WaitForChild("WindowOne")
local windowTwo = gui:WaitForChild("WindowTwo")

local zoomSize = UDim2.new(0.5, 0, 0.5, 0)
local zoomOutSize = UDim2.new(0.4, 0, 0.4, 0)

local infoOne = windowOne:WaitForChild("InfoBar")
local infoTwo = windowTwo:WaitForChild("InfoBar")

local function showInfo(infoFrame)
	infoFrame.Visible = true
	TweenService:Create(infoFrame, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0.85, 0)}):Play()
end

local function hideInfo(infoFrame)
	TweenService:Create(infoFrame, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 1.2, 0)}):Play()
	task.delay(0.3, function()
		infoFrame.Visible = false
	end)
end

local function zoomOne()
	TweenService:Create(windowOne, TweenInfo.new(0.3), {Size = zoomSize}):Play()
	TweenService:Create(windowTwo, TweenInfo.new(0.3), {Size = zoomOutSize}):Play()
	showInfo(infoOne)
	hideInfo(infoTwo)
end

local function zoomTwo()
	TweenService:Create(windowTwo, TweenInfo.new(0.3), {Size = zoomSize}):Play()
	TweenService:Create(windowOne, TweenInfo.new(0.3), {Size = zoomOutSize}):Play()
	showInfo(infoTwo)
	hideInfo(infoOne)
end

-- Click events
windowOne.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		zoomOne()
	end
end)

windowTwo.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		zoomTwo()
	end
end)
