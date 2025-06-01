local RateLimiter = require(script.Parent.Parent:WaitForChild("RateLimiter"))
local HTTPService = game:GetService("HttpService")

local HTTPAPI = {}
HTTPAPI.__index = HTTPAPI
HTTPAPI.Version = "1.0-alpha.5"

local DEFAULT_CONFIG = {
    MaxRetries = 3,
    Timeout = 30,
    BaseUrl = "https://fperp.xyz/api/v1"
}

function HTTPAPI.new(config)
    local self = setmetatable({}, HTTPAPI)
    
    self.Config = setmetatable(config or {}, { __index = DEFAULT_CONFIG })
    self._limiter = RateLimiter.new(10) -- 10 requests per second
    self._cache = {}
    
    return self
end

function HTTPAPI:Request(method, endpoint, data)
    return self._limiter:Call(function()
        local url = self.Config.BaseUrl .. endpoint
        local options = {
            Method = method,
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-API-Version"] = "3.0-alpha"
            }
        }
        
        if data then
            options.Body = HTTPService:JSONEncode(data)
        end
        
        local attempts = 0
        local lastError
        
        while attempts < self.Config.MaxRetries do
            attempts += 1
            
            local success, response = pcall(function()
                return HTTPService:RequestAsync({
                    Url = url,
                    Method = method,
                    Headers = options.Headers,
                    Body = options.Body
                })
            end)
            
            if success then
                if response.Success then
                    return HTTPService:JSONDecode(response.Body)
                else
                    lastError = {
                        Status = response.StatusCode,
                        Message = response.Body
                    }
                end
            else
                lastError = {
                    Status = 0,
                    Message = response
                }
            end
            
            task.wait(math.pow(2, attempts)) -- Exponential backoff
        end
        
        error(string.format("HTTP Request failed after %d attempts: %s", 
              self.Config.MaxRetries, lastError.Message))
    end)
end

function HTTPAPI:Get(endpoint, query)
    return self:Request("GET", endpoint, query)
end

function HTTPAPI:Post(endpoint, data)
    return self:Request("POST", endpoint, data)
end

function HTTPAPI:Put(endpoint, data)
    return self:Request("PUT", endpoint, data)
end

function HTTPAPI:Delete(endpoint)
    return self:Request("DELETE", endpoint)
end

function HTTPAPI:GetCached(endpoint, ttl)
    if self._cache[endpoint] and os.time() < self._cache[endpoint].expires then
        return Promise.resolve(self._cache[endpoint].data)
    end
    
    return self:Get(endpoint):andThen(function(data)
        self._cache[endpoint] = {
            data = data,
            expires = os.time() + (ttl or 60)
        }
        return data
    end)
end

return HTTPAPI