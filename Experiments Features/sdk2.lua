-- Simple Calculator
print("Enter the first number:")
local num1 = tonumber(io.read())

print("Enter the second number:")
local num2 = tonumber(io.read())

print("Enter the operation (+, -, *, /):")
local op = io.read()

local result
if op == "+" then
    result = num1 + num2
elseif op == "-" then
    result = num1 - num2
elseif op == "*" then
    result = num1 * num2
elseif op == "/" then
    result = num1 / num2
else
    print("Invalid operation!")
    return
end

print("Result: " .. result)
