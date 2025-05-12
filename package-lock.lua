return {
    lockfileVersion = 1,
    name = "FPE:RP LOCK PACKAGES",
    description = "You just need package not package-lock"
    version = "3.0-alpha",
    dependencies = {
        ["API/R3"] = {
            version = "2.1.3-alpha",
            resolved = "rbxassetid://1313131313",
            integrity = "sha256-a1b2c3...",
            dependencies = {
                ["Promise"] = {
                    version = "3.0.0",
                    resolved = "rbxassetid://456456456"
                },
                ["NetworkSerializer"] = {
                    version = "1.2.0",
                    resolved = "rbxassetid://789789789"
                }
            }
        },
        ["Client/R6"] = {
            version = "1.2.0-alpha",
            resolved = "rbxassetid://2626262626",
            integrity = "sha256-d4e5f6...",
            dependencies = {
                ["Roact"] = {
                    version = "1.4.2",
                    resolved = "rbxassetid://1212121212"
                },
                ["UIBlox"] = {
                    version = "2.0.1",
                    resolved = "rbxassetid://3434343434"
                }
            }
        },
        ["UserRPC"] = {
            version = "1.3.1-alpha",
            resolved = "rbxassetid://3939393939",
            integrity = "sha256-g7h8i9...",
            dependencies = {
                ["Signal"] = {
                    version = "2.0.0",
                    resolved = "rbxassetid://5656565656"
                }
            }
        }
    },
    
    scripts = {
        deploy = {
            version = "1.0.0",
            resolved = "rbxassetid://1818181818",
            integrity = "sha256-j1k2l3..."
        },
        git = {
            version = "1.2.0",
            resolved = "rbxassetid://2929292929"
        },
        run = {
            version = "2.1.0",
            resolved = "rbxassetid://3838383838"
        },
        ["API status"] = {
            version = "0.9.1",
            resolved = "rbxassetid://4848484848"
        },
        ["API v"] = {
            version = "1.0.3",
            resolved = "rbxassetid://5858585858"
        },
        UPD = {
            version = "3.0.0-alpha",
            resolved = "rbxassetid://6868686868"
        }
    },
    
    metadata = {
        generatedAt = "2023-11-15T15:30:00Z",
        generatedBy = "FPE-PackageManager/1.0.0",
        environment = {
            robloxVersion = "version-581",
            studioVersion = "0.581.0.5810332",
            lockReason = "Production deployment"
        },
        notes = "Locked for stable release candidate"
    }
}
