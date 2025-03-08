
-- Password Generator
local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
math.randomseed(os.time())

print("Enter the length of the password:")
local length = tonumber(io.read())

local password = ""
for i = 1, length do
    local randIndex = math.random(1, #chars)
    password = password .. chars:sub(randIndex, randIndex)
end

print("Generated Password: " .. password)
