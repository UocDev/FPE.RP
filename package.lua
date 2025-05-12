return {
    name = "",
    version = "3.0-alpha",
    description = "The package lua files for developer FPE:RP",
    author = "Uocdev",
    license = "MIT"
    
    dependencies = {
        ["API/R3"] = "^2.0-alpha",
        ["Client/R6"] = "^1.0-alpha",
        ["UserRPC"] = "^1.0-alpha",
        
    },
    
    scripts = {
        deploy = "RunTests.lua",
        git = "PushCommit.lua",
        run = "RunScript.lua",
        API status = "CheckAPIStatus.lua
        API v = "CheckAPIVersion.lua"
        UPD = "UpdateVersionPackage.lua"
    }
