local TweenService = game:GetService("TweenService")
local gui = script.Parent

local windowOne = gui:WaitForChild("WindowOne")
local windowTwo = gui:WaitForChild("WindowTwo")

local zoomSize = UDim2.new(0.5, 0, 0.5, 0)
local zoomOutSize = UDim2.new(0.4, 0, 0.4, 0)

local zoomOne = function()
	TweenService:Create(windowOne, TweenInfo.new(0.3), {Size = zoomSize}):Play()
	TweenService:Create(windowTwo, TweenInfo.new(0.3), {Size = zoomOutSize}):Play()
end

local zoomTwo = function()
	TweenService:Create(windowTwo, TweenInfo.new(0.3), {Size = zoomSize}):Play()
	TweenService:Create(windowOne, TweenInfo.new(0.3), {Size = zoomOutSize}):Play()
end

-- Detect clicks
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
