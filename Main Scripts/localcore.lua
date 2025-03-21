
--[[

	Me when ur mom
	Rescripted again by TheWildDeveloper
	Maintenance script that handles refueling & structural cracks

	Fixed by Phoenix (Ur welcome)
]]

Service = nil
CoRoutine = nil
Wrap = nil

RESET = function()
	local Global = {
		Debounce = false;
		DMROnline = true;
		FuelUnder20 = false;
		OutOfFuel = false;
		MaintenanceActive = false;
		IntegrityDepletion = false;
		
		Handles = {
			[1] = false, [2] = false, [3] = false
		};	
	
		Keys = {
			[1] = false, [2] = false
		};
		
		FuelCells = {
			[1] = true, [2] = true, [3] = true
		};
		
		PreviousCellType = {
			[1] = "Generic", [2] = "Generic", [3] = "Generic"
		};
		
		FuelCellsType = {
			[1] = "Generic", [2] = "Generic", [3] = "Generic"
		};
	}

	return Global
end

local SCRIPT = function()



--//Services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")

--//Objects
local Modules = script.Parent
local Audios = game:GetService("Workspace").Audios
local Controls = game:GetService("Workspace").ReactorControlInterfaces
local Monitors = Controls.Monitors
local Reactor = game:GetService("Workspace").ReactorCore
local Core = Reactor.Core

local ConsolePrintEvent = game:GetService("ReplicatedStorage").Game.Events.Misc.ConsolePrint
local NotificationEvent = game:GetService("ReplicatedStorage").Game.Events.UI.Notification

--//bindable setup
local Function = nil

local PLBindable = nil
local CoolBindable = nil
local MeltBindable = nil
local ThermalBindable = nil
local StartupBindable = nil

--//module requiring fun
local Global = require(Modules.Global)
local CellStorage = require(script.FuelCellStorage)

local Connections = {}

local Functions; Functions = {
    Start = function()
        Debounce = true
        for i = 1,3 do
            FuelCells[i] = "Need Replacement"
        end
        for _,v in pairs(Controls.Monitors:GetChildren()) do
            v.OfflineNotice.Enabled = true
            v.Screen.Enabled = false
        end
        Controls.ShutdownPanel.Shutdown.OfflineNotice.Enabled = false
        Controls.ShutdownPanel.Shutdown.Screen.Enabled = true
        for _,v in pairs(Controls.Monitors:GetChildren()) do
            v.OfflineNotice.TextLabel.Text = "DMR OFFLINE FOR MAINTENANCE..."
        end
        Controls.ShutdownPanel.Shutdown.OfflineNotice.TextLabel.Text = "DMR OFFLINE FOR MAINTENANCE..."
		Global.FindAudio("Main-tain-ence_mode"):Play()
		Global.FindAudio("Fuel_Cell_Depleted"):Stop()
        NotificationEvent:FireAllClients("Maintenance mode for the DMR has been engaged. Replace all three fuel cells to restart the DMR.", "none", 8)
        
        wait(Global.FindAudio("Main-tain-ence_mode").TimeLength + .5)
        Global.FindAudio("Fuel Capsule Replacement"):Play()
        
        --wait(Global.FindAudio("Fuel Capsule Replacement").TimeLength + .5)
        for i = 1,3 do
            Core.FuelCells["Console"..i].LowerConsole.Handle.ClickDetector.MaxActivationDistance = 12
        end
        
        NotificationEvent:FireAllClients("Reminder: Fuel cells can be made at the Hadron Collider in Sector A.", "none", 8)
        CellStorage.Toggle(true)
        
        wait(1)
        MaintenanceActive = true
        Debounce = false
    end,
    
    End = function()
        Debounce = true
        CellStorage.Toggle(false)
        for i = 1,3 do
            FuelCells[i] = true
            ThermalBindable:Invoke("RefuelFire", i, FuelCellsType[i])
		end
		ThermalBindable:Invoke("PostMaintenance")
        MaintenanceActive = false
        OutOfFuel = false
			FuelUnder20 = false
			for i = 1,3 do
				Handles[i] = false
			end
        for _,v in pairs(Controls.Monitors:GetChildren()) do
            v.OfflineNotice.TextLabel.Text = "DMR READY FOR RE-IGNITION..."
        end
        NotificationEvent:FireAllClients("Maintenance completed. Restart the DMR by turning the key on the main ignition panel.", "none", 10)
        for i = 1,2 do
            Controls.MaintenancePanel["Key"..i].Key.Center.Sound:Play()
            Global:TweenModel(Controls.MaintenancePanel["Key"..i].Key, Controls.MaintenancePanel["Key"..i].Org.CFrame, false, .5)
            Controls.MaintenancePanel["Stage"..i].BrickColor = BrickColor.new("Bright red")
            Keys[i] = false
        end
        
        StartupBindable:Invoke("Variable", "Key", false)
        StartupBindable:Invoke("Variable", "CanTurn", true)
        StartupBindable:Invoke("Variable", "BootDebounce", false)
        
        Controls.Start.Key.ClickDetector.MaxActivationDistance = 16
        Controls.Start.Key.Sound:Play()
        Global.TweenModel(Controls.Start.KeyM.KeyM, Controls.Start.KeyM.Org.CFrame, false, .5)
        TweenService:Create(Controls.Start.Lock_Ind, TweenInfo.new(.5), {Color = Color3.fromRGB(27, 42, 53)}):Play()
        
        wait(1)
        Debounce = false
    end,
    
    Check = function()
        if FuelCells[1] == true and FuelCells[2] == true and FuelCells[3] == true then
            NotificationEvent:FireAllClients("All Fuel Cells have been locked. Re-click the maintenance button to end maintenance restart the DMR.", "none", 15)
            Global.FindAudio("Fuel Capsule Replacement completed"):Play()
        end
    end,
    
    Out = function()
        OutOfFuel = true
        for i = 1,3 do
            FuelCells[i] = "Depleted"
        end
        Global.FindAudio("Fuel_Cell_Depleted"):Play()
        NotificationEvent:FireAllClients("Dark Matter Reactor fuel depleted. Refueling required.", "none", 10)
    end,
    
    Under20 = function()
        FuelUnder20 = true
        for i = 1,3 do
            FuelCells[i] = "Depleted"
        end
        Global.FindAudio("Fuel_Cell_Low"):Play()
        NotificationEvent:FireAllClients("Dark Matter Reactor average fuel level under 20%. Refueling required soon.", "none", 10)
    end
}

--//local functions
--//core damage
--//rescript later

--//button codeâ„¢
local MaintKeys = function(plr, i)
    if Keys[i] == false and not Debounce then
        Debounce = true
        Keys[i] = true
        ConsolePrintEvent:FireAllClients("Maintenance panel key #" ..i.. " turned by " ..plr.Name)
        Controls.MaintenancePanel["Stage"..i].BrickColor = BrickColor.new("Shamrock")
        Controls.MaintenancePanel["Key"..i].Key.Center.Sound:Play()
        Global.TweenModel(Controls.MaintenancePanel["Key"..i].Key, Controls.MaintenancePanel["Key"..i].ToGo.CFrame, true, .5)
        Debounce = false
        
        wait(3)
        if (Keys[1] == true and Keys[2] == false) or (Keys[1] == false and Keys[2] == true) then
            Debounce = true
            Controls.MaintenancePanel["Stage"..i].BrickColor = BrickColor.new("Bright red")
            ConsolePrintEvent:FireAllClients("Maintenance priming sequence aborted- both keys not turned in time.")
            Global.TweenModel(Controls.MaintenancePanel["Key"..i].Key, Controls.MaintenancePanel["Key"..i].Org.CFrame, true, .5)
            Keys[i] = false
            Debounce = false
        end
    end
end

local MaintButton = function(plr)
    if not Debounce then
        if MaintenanceActive then
            if FuelCells[1] == true and FuelCells[2] == true and FuelCells[3] == true then
                Debounce = true
                Controls.MaintenancePanel.Button.Bloop:Play()
                ConsolePrintEvent:FireAllClients("Maintenance Mode disengaged by " ..plr.Name)
                Global.FindAudio("Fuel Capsule Replacement completed"):Stop()
                Global.FindAudio("Main-ten-ance_Completed"):Play()
                
				wait(Global.FindAudio("Main-ten-ance_Completed").TimeLength - 2)
				
                StartupBindable:Invoke("Variable", "StartupType", "Maintenance")
                Functions.End()
            else
                Debounce = true
                Monitors.Maintenance.ErrorSFX:Play()
                Monitors.Maintenance.OfflineNotice.Enabled = false
                Monitors.Maintenance.Error.Enabled = true
                Monitors.Maintenance.Error.Reason.Text = "Maintenance access denied; all fuel cells pending insertion"
                NotificationEvent:FireClient(plr, "Insert all the fuel cells to end maintenance.", "error", 5)
                
                wait(4)
                Monitors.Maintenance.OfflineNotice.Enabled = true
                Monitors.Maintenance.Error.Enabled = false
                
                wait(4)
                Debounce = false
            end
        else
            if Keys[1] == true and Keys[2] == true then
                if (FuelUnder20 and OutOfFuel) or (FuelUnder20 and not OutOfFuel) then
                    Debounce = true
                    PLBindable:Invoke("DisableControls")
                    Controls.PLModeSwitch.Buttons.Left.Part.ClickDetector.MaxActivationDistance = 0
                    Controls.PLModeSwitch.Buttons.Right.Part.ClickDetector.MaxActivationDistance = 0
                    ThermalBindable:Invoke("DisableControls")
                    CoolBindable:Invoke("DisableControls")
                    ThermalBindable:Invoke("EndThermalLoop")
                    ConsolePrintEvent:FireAllClients("Maintenance Mode engaged by " ..plr.Name)
                    TweenService:Create(Modules.Thermals:WaitForChild("Radiation"), TweenInfo.new(7), {Value = 0}):Play()
                        
                    for i = 1,6 do
                        TweenService:Create(Monitors.PowerBoard["PowerLaser"..i], TweenInfo.new(7), {Color = Color3.fromRGB(213, 115, 61)}):Play()
                        TweenService:Create(Reactor.MainStabalizer["Blue"..i], TweenInfo.new(7), {Transparency = 1}):Play()
					end
                    
                    if FuelUnder20 and OutOfFuel then --//If the DMR completely runs out of fuel 
						CoRoutine.Wrap(Functions.Start, true)
                    elseif FuelUnder20 and not OutOfFuel then --//If the DMR has some fuel left
                        TweenService:Create(Core.Core.Sound, TweenInfo.new(10), {PlaybackSpeed = 0}):Play()
                        
						wait(10)
						
                        CoRoutine.Wrap(Functions.Start, true)
					end
					
					local Players = Service.Players:GetChildren()
					for I = 1, #Players do
						game:GetService("ServerScriptService").Server.Scripts.UserInterface.Events.CompleteChallenge:Fire(Players[I], "DMRMAINTENANCE")
					end
                else
                    Debounce = true
                    Monitors.Maintenance.ErrorSFX:Play()
                    Monitors.Maintenance.Screen.Enabled = false
                    Monitors.Maintenance.Error.Enabled = true
                    Monitors.Maintenance.Error.Reason.Text = "Maintenance access denied; prerequisites not met (Avg. Fuel Level < 20%)"
                    NotificationEvent:FireClient(plr, "The average fuel level must be under 20% to activate maintenance.", "error", 6)
                    
                    wait(4)
                    Monitors.Maintenance.Screen.Enabled = true
                    Monitors.Maintenance.Error.Enabled = false
                    
                    wait(4)
                    Debounce = false
                end
            elseif Keys[1] == false and Keys[2] == false then
                Debounce = true
                Monitors.Maintenance.ErrorSFX:Play()
                Monitors.Maintenance.Screen.Enabled = false
                Monitors.Maintenance.Error.Enabled = true
                Monitors.Maintenance.Error.Reason.Text = "Maintenance access denied; keys not turned"
                NotificationEvent:FireClient(plr, "Turn the maintenance panel keys to be able to use this button.", "error", 5)
                
                wait(4)
                Monitors.Maintenance.Screen.Enabled = true
                Monitors.Maintenance.Error.Enabled = false
                
                wait(4)
                Debounce = false
            end
        end
    end
end

local ConsoleHandle = function(plr, i)
    if not Debounce then
        if MaintenanceActive then
            local console = Core.FuelCells["Console"..i].LowerConsole
            if Handles[i] == false then --//Cell ejection
                Debounce = true
                FuelCells[i] = false
                console.Handle.ClickDetector.MaxActivationDistance = 0
                console.Handle.Main.Sound:Play()
                Global.FindAudio("Fuel_Cell"):Play()
                
                ConsolePrintEvent:FireAllClients("Fuel Cell " ..i.. " removed by " ..plr.Name)
                NotificationEvent:FireAllClients("Fuel Cell " ..i.. " removed.", "none", 3)
                
                Global.TweenModel(console.Handle, console.ToGoParts.Down.CFrame, false, 1)
                
                wait(1)
                Global.FindAudio("Cell" ..i):Play()
                
                wait(1)
                Global.FindAudio("Unlocked"):Play()
                console.green.Material = Enum.Material.SmoothPlastic
                console.red.Material = Enum.Material.Neon
                Core.FuelCells["Console"..i][FuelCellsType[i].."Cell"].PRIMARY.SoundUnlock:Play()
                Global.TweenModel(Core.FuelCells["Console"..i][FuelCellsType[i].."Cell"], Core.FuelCells["Console"..i].TGP["pre-insert"].CFrame, true, 1)
                Global.TweenModel(Core.FuelCells["Console"..i][FuelCellsType[i].."Cell"], Core.FuelCells["Console"..i].TGP.eject.CFrame, true, 1.3)
                
                if Core.FuelCells["Console"..i][FuelCellsType[i].. "Cell"].Name == "GenericCell" then
                    PreviousCellType[i] = "Generic"
                elseif Core.FuelCells["Console"..i][FuelCellsType[i].. "Cell"].Name == "ReactiveCell" then
                    PreviousCellType[i] = "Reactive"
                elseif Core.FuelCells["Console"..i][FuelCellsType[i].. "Cell"].Name == "SuperCell" then
                    PreviousCellType[i] = "Super"
                elseif Core.FuelCells["Console"..i][FuelCellsType[i].. "Cell"].Name == "EfficientCell" then
                    PreviousCellType[i] = "Efficient"
                end
                
                ServerStorage.HadronCollider.DMRFuel[FuelCellsType[i]]["Depleted " .. FuelCellsType[i] .. " Cell"]:Clone().Parent = plr.Backpack
                
                for _,v in pairs(Core.FuelCells["Console"..i][FuelCellsType[i].."Cell"]:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("Decal") then
                        v.Transparency = 1
                    elseif v:IsA("PointLight") then
                        v.Enabled = false
                    end
                end
                
                wait(1)
                console.Handle.ClickDetector.MaxActivationDistance = 32
                Handles[i] = true
                Debounce = false
            elseif Handles[i] == true then --//Cell insertion
                if FuelCells[i] == "Ready" then
                    Debounce = true
                    console.Handle.ClickDetector.MaxActivationDistance = 0
                    console.Handle.Main.Sound:Play()
                    Global.FindAudio("Fuel_Cell"):Play()
                    
                    ConsolePrintEvent:FireAllClients("Fuel Cell " ..i.. " inserted by " ..plr.Name)
                    NotificationEvent:FireAllClients("" .. tostring(FuelCellsType[i]) .. " type cell inserted in fuel chamber slot " .. i , "none", 3)
                    
                    Global.TweenModel(console.Handle, console.ToGoParts.Up.CFrame, false, 1)
                    
					wait(1)
					
                    Global.FindAudio("Cell"..i):Play()
                    
					wait(1)
					
					game:GetService("ServerScriptService").Server.Scripts.UserInterface.Events.CompleteChallenge:Fire(plr, "FUELDMR")
					
                    Global.FindAudio("Locked"):Play()
                    console.green.Material = Enum.Material.Neon
                    console.red.Material = Enum.Material.SmoothPlastic
                    Core.FuelCells["Console"..i][FuelCellsType[i].."Cell"].PRIMARY.SoundLock:Play()
                    Global.TweenModel(Core.FuelCells["Console"..i][FuelCellsType[i].."Cell"], Core.FuelCells["Console"..i].TGP.insert.CFrame, true, 1)
                    
                    wait(1)
                    Handles[i] = true
                    FuelCells[i] = true
                    
                    Functions.Check()
                    
                    Debounce = false
                else
                    NotificationEvent:FireClient(plr, "Insert a fuel cell to do this!", "error", 3)
                end
            end
        else
            NotificationEvent:FireClient(plr, "Engage maintenance first!", "error", 3)
        end
    else
        NotificationEvent:FireClient(plr, "Please wait...", "error", 3)
    end
end

local CellTouch = function(hit, i)
    if MaintenanceActive and FuelCells[i] == false and Debounce == false then
        Debounce = true
        
        local found = false
        if hit.Parent:IsA("Tool") then
            for _,v in pairs(hit.Parent:GetChildren()) do
                if v.Parent.Name == "Generic Cell" then
                    found = true
                    FuelCellsType[i] = "Generic"
                    break
                elseif v.Parent.Name == "Super Cell" then
                    found = true
                    FuelCellsType[i] = "Super"
                    break
                elseif v.Parent.Name == "Reactive Cell" then
                    found = true
                    FuelCellsType[i] = "Reactive"
                    break
                elseif v.Parent.Name == "Efficient Cell" then
                    found = true
                    FuelCellsType[i] = "Efficient"
                    break
                end
            end
        end
        
        if found == true then
            hit.Parent:Destroy()
            
            for _,v in pairs(Core.FuelCells["Console"..i][PreviousCellType[i].."Cell"]:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "Color" then
                    v.Color = ServerStorage.HadronCollider.DMRFuel[FuelCellsType[i]][FuelCellsType[i].." Cell"].Color.Color
                    v.Transparency = 0
                elseif v:IsA("BasePart") or v:IsA("Decal") then
                    v.Transparency = 0
                elseif v:IsA("PointLight") then
                    v.Enabled = true
                end
            end
            
            Core.FuelCells["Console"..i][PreviousCellType[i].."Cell"].Name = FuelCellsType[i].."Cell"
            Global.TweenModel(Core.FuelCells["Console"..i][FuelCellsType[i].."Cell"], Core.FuelCells["Console"..i].TGP["pre-insert"].CFrame, true, 1)
            FuelCells[i] = "Ready"
        end
        
        Debounce = false
    end
end

local Disconnect = function(...)
    local DisconnectFunction = function(What)
        if type(What) == "table" then
            for Index, Signal in pairs(What) do
                Signal:Disconnect()
            end
        else
            What:Disconnect()
        end
    end

    for Index, Value in pairs({...}) do
        DisconnectFunction(Value)
    end
end

local Compile = function()
    --// Begin Script Reset
        Disconnect(Connections)
        
        if Function then
            Function:Destroy()
        end
        
        Function = Instance.new("BindableFunction")
        Function.Name = "MaintenanceFunctions"
        Function.Parent = ServerStorage:WaitForChild("Bindables")
    
        PLBindable = ServerStorage.Bindables:WaitForChild("PowerLaserFunctions")
        CoolBindable = ServerStorage.Bindables:WaitForChild("CoolantFunctions")
        MeltBindable = ServerStorage.Bindables:WaitForChild("MeltdownFunctions")
        ThermalBindable = ServerStorage.Bindables:WaitForChild("ThermalFunctions")
        StartupBindable = ServerStorage.Bindables:WaitForChild("StartupFunctions")
        
        RESETSCRIPTENV(RESET)
        
    --// End Script Reset

    for i = 1,3 do
        Connections["CHandle"..i] = Core.FuelCells["Console"..i].LowerConsole.Handle.ClickDetector.MouseClick:Connect(Wrap(function(Player)
                ConsoleHandle(Player, i)
        end))
        Connections["CTouch"..i] = Core.FuelCells["Console"..i].Touch.Touched:Connect(function(What)
            CellTouch(What, i)
        end)
    end
    
    for i = 1,2 do
        Connections["Keys"..i] = Controls.MaintenancePanel["Key"..i].Key.Center.ClickDetector.MouseClick:Connect(Wrap(function(Player) 
                MaintKeys(Player, i)
        end))
    end
    
    Connections.MButton = Controls.MaintenancePanel.Button.ClickDetector.MouseClick:Connect(Wrap(MaintButton))

    Function.OnInvoke = function(Function, ...)
        local Args = {...}
        if Functions[Function] then 
            return Functions[Function](unpack(Args)) 
        end
    end
end

script.Compile.Event:Connect(Compile)
script.Ready:Fire()



end

game:GetService("ServerStorage"):WaitForChild("Format_Env"):Invoke(SCRIPT, true, nil, true)

SCRIPT()
