local Promise = require(script.Parent.Parent:WaitForChild("Promise")) -- From dependencies
local NetworkSerializer = require(script.Parent.Parent:WaitForChild("NetworkSerializer"))

local API_R3 = {}
API_R3.__index = API_R3
API_R3.Version = "2.0-alpha.7"

local function validateEndpoint(endpoint)
    return typeof(endpoint) == "string" and endpoint:match("^[%w_%/%-%.]+$")
end

function API_R3.new(serviceName)
    local self = setmetatable({}, API_R3)
    
    self.ServiceName = serviceName or "DefaultService"
    self._middlewares = {}
    self._rateLimits = {}
    
    return self
end

function API_R3:Get(endpoint, queryParams)
    if not validateEndpoint(endpoint) then
        return Promise.reject("Invalid endpoint format")
    end
    
    return Promise.new(function(resolve, reject)
        local serializedParams = NetworkSerializer.Encode(queryParams or {})
        local requestUrl = string.format("%s/%s?%s", self.ServiceName, endpoint, serializedParams)
        
        resolve({
            Status = 200,
            Body = "GET response for "..requestUrl
        })
    end)
end

function API_R3:Post(endpoint, body)
    if not validateEndpoint(endpoint) then
        return Promise.reject("Invalid endpoint format")
    end
    
    return Promise.new(function(resolve, reject)
        local serializedBody = NetworkSerializer.Encode(body or {})
        
        resolve({
            Status = 201,
            Body = "POST response for "..endpoint
        })
    end)
end

function API_R3:Use(middleware)
    table.insert(self._middlewares, middleware)
    return self -- Allow chaining
end

return API_R3