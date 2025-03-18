local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Balls = workspace:WaitForChild("Balls", 9e9)

local ParryEnabled = true  
local ParryThreshold = 10  
local ParryDelay = 0  
local ParryPingCalculate = false  
local VisualizeDistance = false  
local PingMultiplier = 0.001  

local DistanceCircle = Instance.new("Part")
DistanceCircle.Shape = Enum.PartType.Cylinder
DistanceCircle.Anchored = true
DistanceCircle.CanCollide = false
DistanceCircle.Orientation = Vector3.new(0, 0, 90)
DistanceCircle.Size = Vector3.new(0.01, ParryThreshold * 2, ParryThreshold * 2)
DistanceCircle.Color = Color3.fromRGB(0, 255, 0)
DistanceCircle.Material = Enum.Material.ForceField
DistanceCircle.Transparency = VisualizeDistance and 0 or 1
DistanceCircle.Parent = workspace

local PingText = Drawing.new("Text")
PingText.Visible = false
PingText.Size = 20
PingText.Color = Color3.fromRGB(255, 255, 255)
PingText.Center = true
PingText.Outline = true

local function VerifyBall(Ball)
    return typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true
end

local function IsTarget()
    return Player.Character and Player.Character:FindFirstChild("Highlight")
end

local function Parry()
    if ParryEnabled then
        if ParryPingCalculate then
            local ping = Players.LocalPlayer:GetNetworkPing() * PingMultiplier
            task.wait(ping)  
        end
        task.wait(ParryDelay)  

        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

local Window = Rayfield:CreateWindow({
    Name = "critcl",
    Icon = 0,
    LoadingTitle = "critcl bladeball",
    LoadingSubtitle = "by wploits lol",
    Theme = "Amethyst",
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "critclbladeball"
    },
 
    Discord = {
       Enabled = true,
       Invite = "hackserver",
       RememberJoins = true
    },
 
    KeySystem = false,
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"Hello"}
	}
})

local parryTab = Window:CreateTab("parry", 0)
local apToggle = parryTab:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = false,
    Flag = "apToggleFlag",
    Callback = function(Value)
        ParryEnabled = Value
    end
})
local Slider = parryTab:CreateSlider({
   Name = "Distance",
   Range = {1, 50},
   Increment = 1,
   Suffix = "",
   CurrentValue = 10,
   Flag = "distanceSlider",
   Callback = function(Value)
        ParryThreshold = Value
   end,
})
local ParryDelaySlider = parryTab:CreateSlider({
    Name = "ParryDelay",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0,
    Flag = "ParryDelaySlider",
    Callback = function(Value)
        ParryDelay = Value
    end,
 })
local ppcToggle = parryTab:CreateToggle({
    Name = "Parry Ping Calculate",
    CurrentValue = false,
    Flag = "ppcToggleFlag",
    Callback = function(Value)
        ParryPingCalculate = Value
    end
})
local vdToggle = parryTab:CreateToggle({
    Name = "Visualize Distance",
    CurrentValue = false,
    Flag = "vdToggleFlag",
    Callback = function(Value)
        VisualizeDistance = Value
    end
})

RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local RootPart = Player.Character.HumanoidRootPart
        local TargetPosition = RootPart.Position - Vector3.new(0, RootPart.Size.Y / 2 + 0.1, 0)

        DistanceCircle.Position = DistanceCircle.Position:Lerp(TargetPosition, 0.5)
        DistanceCircle.Orientation = Vector3.new(0, 0, 90)
        DistanceCircle.Size = Vector3.new(0.01, ParryThreshold * 2, ParryThreshold * 2)
        DistanceCircle.Transparency = VisualizeDistance and 0 or 1
    end
    if ParryPingCalculate and game.Players.LocalPlayer.Character then
        local RootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if RootPart then
            local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 3, 0)) -- 頭上に表示
            if OnScreen then
                PingText.Position = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
                PingText.Text = "Ping: " .. math.floor(Players.LocalPlayer:GetNetworkPing() * 1000) .. "ms"
                PingText.Visible = true
            else
                PingText.Visible = false
            end
        end
    else
        PingText.Visible = false
    end
end)

Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) then return end

    local OldPosition = Ball.Position
    local OldTick = tick()

    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsTarget() then
            local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude

            if (Distance / Velocity) <= ParryThreshold then
                Parry()
            end
        end

        if (tick() - OldTick >= 1/60) then
            OldTick = tick()
            OldPosition = Ball.Position
        end
    end)
end)


Players.LocalPlayer.CharacterRemoving:Connect(function()
    DistanceCircle.Transparency = 1
end)
