local RunService = game:GetService("RunService")

local start = tick()
local updaterate = 0.5

local average_amount = 5 --Higher the average, the more accurate the fps will be!

local fps_table = {}

RunService.RenderStepped:Connect(function(frametime)
	if tick() >= start+((updaterate)/average_amount) then
		local fps = 1/frametime
		table.insert(fps_table,fps)
	end
	if tick() >= start+updaterate then
		start = tick()
		local current = 0
		local maxn = table.maxn(fps_table)
		for i=1,maxn do
			current = current+fps_table[i]
		end
		local fps = math.floor(current/maxn)
		script.Parent.Text = fps
		fps_table = {}
	end
end)
