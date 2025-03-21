local textLabel = script.Parent  -- Reference to the TextLabel

local daysOfWeek = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

local currentTime = os.time() -- Get current time
local dateTable = os.date("*t", currentTime) -- Convert to date table

local dayName = daysOfWeek[dateTable.wday] -- Get the day name

textLabel.Text = "Today is: " .. dayName -- Display the day
