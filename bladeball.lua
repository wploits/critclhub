local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Balls = workspace:WaitForChild("Balls", 9e9)

local ParryEnabled = true
local ParryThreshold = 10 

local function VerifyBall(Ball)
    return typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true
end

local function IsTarget()
    return Player.Character and Player.Character:FindFirstChild("Highlight")
end

local function Parry()
    if ParryEnabled then
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
