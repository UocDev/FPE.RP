return {
    lockfileVersion = 2,
    name = "FPE:RP",
    version = "3.0-alpha",
    dependencies = {
        ["API/R3"] = {
            version = "2.0-alpha.7"
            resolved = "rbxassetid://1313131313",
            integrity = "sha256-a1b2c3d4...",
            dependencies = {
                ["Promise"] = {
                    version = "3.1.0",
                    resolved = "rbxassetid://456456456"
                },
                ["NetworkSerializer"] = {
                    version = "1.3.0",
                    resolved = "rbxassetid://789789789"
                }
            }
        },
        ["Client/R6"] = {
            version = "1.0-alpha.12",
            resolved = "rbxassetid://2626262626",
            integrity = "sha256-e5f6g7h8...",
            dependencies = {
                ["Roact"] = {
                    version = "1.5.1",
                    resolved = "rbxassetid://1212121212"
                },
                ["UIBlox"] = {
                    version = "2.1.0",
                    resolved = "rbxassetid://3434343434"
                }
            }
        },
        ["UserRPC"] = {
            version = "1.0-alpha.4",
            resolved = "rbxassetid://3939393939",
            integrity = "sha256-i9j0k1l2...",
            dependencies = {
                ["Signal"] = {
                    version = "2.1.0",
                    resolved = "rbxassetid://5656565656"
                }
            }
        },
        ["REST API"] = {
            version = "1.0-alpha.3",
            resolved = "rbxassetid://9191919191",
            integrity = "sha256-m3n4o5p6...",
            dependencies = {
                ["HttpService"] = {
                    version = "2.0.0",
                    resolved = "rbxassetid://8282828282"
                }
            }
        },
        ["ClientAPP"] = {
            version = "2.0-alpha.9",
            resolved = "rbxassetid://7373737373",
            integrity = "sha256-q7r8s9t0...",
            dependencies = {
                ["Rodux"] = {
                    version = "0.3.1",
                    resolved = "rbxassetid://6464646464"
                }
            }
        },
        ["App Metadata"] = {
            version = "1.0-alpha.2",
            resolved = "rbxassetid://5555555555",
            integrity = "sha256-u1v2w3x4..."
        },
        ["HTTP API"] = {
            version = "1.0-alpha.5",
            resolved = "rbxassetid://4444444444",
            integrity = "sha256-y5z6a7b8...",
            dependencies = {
                ["RateLimiter"] = {
                    version = "1.2.0",
                    resolved = "rbxassetid://3333333333"
                }
            }
        }
    },
    
    scripts = {
        deploy = {
            version = "1.1.0",
            resolved = "rbxassetid://1818181818",
            integrity = "sha256-c1d2e3f4..."
        },
        git = {
            version = "1.3.0",
            resolved = "rbxassetid://2929292929"
        },
        run = {
            version = "2.2.0",
            resolved = "rbxassetid://3838383838"
        },
        ["API status"] = {
            version = "0.9.5",
            resolved = "rbxassetid://4848484848"
        },
        ["API v"] = {
            version = "1.1.0",
            resolved = "rbxassetid://5858585858"
        },
        UPD = {
            version = "3.0.0-alpha.2",
            resolved = "rbxassetid://6868686868"
        }
    },
    
    metadata = {
        generatedAt = "2023-11-20T09:45:00Z",
        generatedBy = "FPE-PackageManager/1.1.0",
        environment = {
            robloxVersion = "version-582",
            studioVersion = "0.582.0.5820421",
            lockReason = "Production deployment"
        },
        notes = "Locked all new HTTP-related packages for API stability"
    }
}