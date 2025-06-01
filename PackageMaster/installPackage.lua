local Packages = script.Parent
local PackageLock = require(Packages:WaitForChild("package-lock"))

local FPERP = {
    _version = PackageLock.version,
    _components = {}
}

function FPERP:LoadDependencies()
    for packageName, data in pairs(PackageLock.dependencies) do
        local packagePath = string.gsub(packageName, "%.", "/")
        local success, component = pcall(function()
            return require(Packages:WaitForChild(packagePath))
        end)
        
        if success then
            self._components[packageName] = component
            component._version = data.version -- Inject version info
        else
            warn(string.format("[FPERP] Failed to load %s: %s", packageName, component))
        end
    end
end
function FPERP:Get(packageName)
    return self._components[packageName] or error("Package not found: "..packageName)
end

FPERP:LoadDependencies()

getgenv().FPERP = FPERP

return FPERP