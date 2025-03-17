local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

plr = game.Players.LocalPlayer
cam = workspace.CurrentCamera
mouse = plr:GetMouse()
uis = game:GetService("UserInputService")
inv = workspace:WaitForChild(plr.Name.."SpawnedInToys")
rs = game:GetService("ReplicatedStorage")
rs2 = game:GetService("RunService")
deb = game:GetService("Debris")

flingT = nil
killGrabT = nil
infLineExtendT = nil
antiGrab1T = nil
antiGrab1AnchorT = true
antiBlob1T = nil
antiExplodeT = true
antiLagT = nil
antiStickyT = nil
blobLoopT = nil
walkSpeedT = nil
jumpPowerT = nil
infJumpT = nil
noClipT = nil
floatT = nil
masslessT = nil
blobLoopServerT = nil
blobLoopServerTwoHandT = nil
silentBlobServerT = nil
lagT = nil
pingT = nil
shurikenLagServerT = nil
slideTPT = nil
inspectT = false
inspectInfoT = false
inspectInfoOnT = false
ragdollSpamT = false
permRagdollT = nil
autoGucciT = nil
destroyAutoGucciT = nil
sitJumpT = false
floatUpT = false
floatDownT = false
zoomT = false
spychatT = nil
spySelfT = nil
publicSpyT = nil

strengthV = 1000
lineDistanceV = 0
increaseLineExtendV = 0
walkSpeedV = 16
jumpPowerV = 24
floatY = -3.1
zoomV = 20
linesV = 400
packetsV = 3000
playersInLoop1V = {}
playersInLoop2V = {}

currentHouseS = 0
blobmanInstanceS = nil
currentBlobS = nil
currentInspectS = 0
currentHouseInspectS = 0
currentInspectedAdorneeS = nil
currentInspectedPartS = nil
permRagdollRunningS = false
returnPosS = CFrame.new(0, 0, 0)
mouseTargetS = nil

infJumpD = false
inspectD = false
slideTPD = false
ragdollSpamD = false
ragdollLoopD = false

highlight = Instance.new("Highlight")
highlight.Name = "highlight"
highlight.Enabled = true
highlight.FillTransparency = 0.9
highlight.OutlineTransparency = 0

billboard = Instance.new("BillboardGui")
billboard.Name = "billboard"
billboard.Size = UDim2.new(0, 100, 0, 150)
billboard.StudsOffset = Vector3.new(0, 1, 0)
billboard.AlwaysOnTop = true

scrollframe = Instance.new("ScrollingFrame")
scrollframe.Name = "scrollframe"
scrollframe.ScrollingEnabled = false
scrollframe.BackgroundTransparency = 0.7

textlabel = Instance.new("TextLabel")
textlabel.Name = "textlabel"
textlabel.TextScaled = true
textlabel.BackgroundTransparency = 1

function updateCurrentBlobmanF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    for _, blobs in workspace:GetDescendants() do
        if blobs.Name ~= "CreatureBlobman" then continue end
        if not blobs:FindFirstChild("VehicleSeat") then continue end
        if not blobs.VehicleSeat:FindFirstChild("SeatWeld") then continue end
        if blobs.VehicleSeat.SeatWeld.Part1 == hrp then
            currentBlobS = blobs
        end
    end
end

function blobGrabF(blob, target, side)
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local args = {
        [1] = blob:FindFirstChild(side.."Detector"),
        [2] = target,
        [3] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        }
        blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args))
end

function blobDropF(blob, target, side)
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local args = {
        [1] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        [2] = target,
        }
        blob.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(unpack(args))
end

function silentBlobGrabF(blob, target, side)
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local args = {
        [1] = blob:FindFirstChild(side.."Detector"),
        [2] = target,
        [3] = blob:FindFirstChild(side.."Detector").AttachPlayer,
        }
        blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args))
end

function updateCurrentHouseF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if char.Parent == workspace then
        currentHouseS = 0
    elseif char.Parent.Name == "PlayersInPlots" then
        for i, e in workspace.Plots:GetChildren() do
            for i, e in e.PlotSign.ThisPlotsOwners:GetChildren() do
                if e.Value == plr.Name then
                    if e.Parent.Parent.Parent.Name == "Plot1" then
						currentHouseS = 1
					elseif e.Parent.Parent.Parent.Name == "Plot2" then
						currentHouseS = 2
					elseif e.Parent.Parent.Parent.Name == "Plot3" then
						currentHouseS = 3
					elseif e.Parent.Parent.Parent.Name == "Plot4" then
						currentHouseS = 4
					elseif e.Parent.Parent.Parent.Name == "Plot5" then
						currentHouseS = 5
					end
                end
            end
        end
	end
end

function mouseTargetInspectF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if mouse.Target then
        if mouse.Target.Parent:FindFirstChildOfClass("Humanoid") then
            currentInspectS = 1
            currentHouseInspectS = 0
        elseif mouse.Target.Parent:IsDescendantOf(workspace.Plots) then
                local current = mouse.Target
                repeat
                   current = current.Parent
                until string.match(current.Name, "Plot")
                for i = 1, 5 do
                    if current.Name == "Plot"..i then
                        currentHouseInspectS = i
                    end
                end
                currentInspectS = 2
        elseif mouse.Target.Parent:IsDescendantOf(workspace.PlotItems) or string.match(mouse.Target.Parent.Parent.Name, "SpawnedInToys") or mouse.Target.Parent.Parent:FindFirstChild("SpawningPlatform") then
            currentInspectS = 3
            currentHouseInspectS = 0
        else
            currentInspectS = 4
            currentHouseInspectS = 0
        end
    end
end

function flingF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    workspace.ChildAdded:Connect(function(model)
        if model.Name == "GrabParts" then
            local part_to_impulse = model["GrabPart"]["WeldConstraint"].Part1
            if part_to_impulse then
                model:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not model.Parent and flingT then
                        uis.InputBegan:Connect(function(inp, chat)
                            if inp.UserInputType == Enum.UserInputType.MouseButton2 then
                                local velocityObj = Instance.new("BodyVelocity", part_to_impulse)
                                velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                velocityObj.Velocity = cam.CFrame.lookVector * strengthV
                                deb:AddItem(velocityObj, 1)
                            end
                        end)
                    end
                end)
            end
        end
    end)
end

function killGrabF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    workspace.ChildAdded:Connect(function(e)
        if e.Name == "GrabParts" and killGrabT and e.GrabPart.WeldConstraint.Part1.Parent.Name ~= char.Name then
            e.GrabPart.WeldConstraint.Part1.Parent:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end)
end

function infLineExtendF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    uis.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if lineDistanceV < 11 then
                lineDistanceV = 11
            end
    
            if input.Position.Z > 0 then
                lineDistanceV = lineDistanceV + increaseLineExtendV
            elseif input.Position.Z < 0 then
                lineDistanceV = lineDistanceV - increaseLineExtendV
            end
        end
    end)
    
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "GrabParts" and child:IsA("Model") then
            if infLineExtendT and uis.MouseEnabled then
                local grabPartsModel = child

                grabPartsModel:WaitForChild("GrabPart")
                grabPartsModel:WaitForChild("DragPart")
                    
                local clonedDragPart = grabPartsModel.DragPart:Clone()
                clonedDragPart.Name = "DragPart1"
                clonedDragPart.AlignPosition.Attachment1 = clonedDragPart.DragAttach
                clonedDragPart.Parent = grabPartsModel
                
                lineDistanceV = (clonedDragPart.Position - cam.CFrame.Position).Magnitude
    
                clonedDragPart.AlignOrientation.Enabled = false
                grabPartsModel.DragPart.AlignPosition.Enabled = false
    
                task.spawn(function()
                    while grabPartsModel.Parent do
                        clonedDragPart.Position = cam.CFrame.Position + cam.CFrame.LookVector * lineDistanceV
                        task.wait()
                    end
            
                    lineDistanceV = 0
                end)
            end
        end
    end)
end

function antiGrab1F()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    while antiGrab1T and task.wait() do
        if plr.IsHeld.Value == true and antiGrab1T == true then
            if hrp ~= nil then
                if antiGrab1AnchorT then
                    hrp.Anchored = true
                    while plr.IsHeld.Value == true do rs.CharacterEvents.Struggle:FireServer(plr);wait(0.001) end
                    hrp.Anchored = false
                elseif not antiGrab1AnchorT then
                    while plr.IsHeld.Value == true do rs.CharacterEvents.Struggle:FireServer(plr);wait(0.001) end
                end
            end
        end
    end
end

function antiBlob1F()
    workspace.DescendantAdded:Connect(function(toy)
        if toy.Name == "CreatureBlobman" and toy.Parent ~= inv and antiBlob1T then
            wait()
            toy.LeftDetector:Destroy()
            toy.RightDetector:Destroy()
        end
    end)
end

function antiExplodeF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    workspace.ChildAdded:Connect(function(model)
        if model.Name == "Part" and char ~= nil and antiExplodeT then
            local mag = (model.Position - hrp.Position).Magnitude
            if mag <= 20 then
                hrp.Anchored = true
				wait(0.01)
                while char["Right Arm"].RagdollLimbPart.CanCollide == true do wait(0.001) end
                hrp.Anchored = false
            end
        end
    end)
end

function antiLagF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if antiLagT == true then
        plr.PlayerScripts.CharacterAndBeamMove.Disabled = true
    elseif antiLagT == false then
        plr.PlayerScripts.CharacterAndBeamMove.Enabled = true
    end
end

function antiStickyF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if antiStickyT == true then
        plr.PlayerScripts.StickyPartsTouchDetection.Disabled = true
    elseif antiStickyT == false then
        plr.PlayerScripts.StickyPartsTouchDetection.Enabled = true
    end
end

function getPlayerList()
    local playerList = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= plr then
            table.insert(playerList, p.Name .. " (" .. p.DisplayName .. ")")
        end
    end
    return playerList
end

function loopPlayerBlobF()
    updateCurrentBlobmanF()
    for i, e in ipairs(playersInLoop2V) do
        local player
        if game.Players:FindFirstChild(e) then
            player = game.Players:FindFirstChild(e)
        else
            continue
        end
        if blobLoopT then
            blobGrabF(currentBlobS, player.Character:WaitForChild("HumanoidRootPart"), "Left")
            wait(0.05)
            blobDropF(currentBlobS, player.Character:WaitForChild("HumanoidRootPart"), "Left")
            wait(0.05)
            silentBlobGrabF(currentBlobS, player.Character:WaitForChild("HumanoidRootPart"), "Left")
        end
    end
    while task.wait(6.25) and blobLoopT do
        for i, e in ipairs(playersInLoop2V) do
            local player
            if game.Players:FindFirstChild(e) then
                player = game.Players:FindFirstChild(e)
            else
                continue
            end
            blobGrabF(currentBlobS, player.Character:WaitForChild("HumanoidRootPart"), "Left")
            wait(0.05)
            blobDropF(currentBlobS, player.Character:WaitForChild("HumanoidRootPart"), "Left")
            wait(0.05)
            silentBlobGrabF(currentBlobS, player.Character:WaitForChild("HumanoidRootPart"), "Left")
        end
    end
end

function updateWalkSpeedF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if walkSpeedT then
        hum.WalkSpeed = walkSpeedV
    elseif not walkSpeedT then
        hum.WalkSpeed = 16
    end
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if walkSpeedT then
            hum.WalkSpeed = walkSpeedV
        elseif not walkSpeedT then
            hum.WalkSpeed = 16
        end
    end)
end

function updateJumpPowerF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if jumpPowerT then
        hum.JumpPower = jumpPowerV
    elseif not jumpPowerT then
        hum.JumpPower = 24
    end
end

function updateNoClipF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    while noClipT and task.wait(0.1) do
        char.Head.CanCollide = false
        char.Torso.CanCollide = false
    end
    if not noClipT then
        char.Head.CanCollide = true
        char.Torso.CanCollide = true
    end
end

function updateInfJumpF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    uis.JumpRequest:Connect(function()
        if infJumpT and not infJumpD then
            infJumpD = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            wait()
            infJumpD = false
        end
    end)
end

function updateFloatF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if floatT then
    local float = Instance.new('Part')
    float.Name = "floatPart"
    float.Parent = char
    float.Transparency = 1
    float.Size = Vector3.new(2,0.2,1.5)
    float.Anchored = true
    float.CFrame = hrp.CFrame * CFrame.new(0, floatY, 0)
    local function floatLoop()
        if char:FindFirstChild("floatPart") and hrp then
            float.CFrame = hrp.CFrame * CFrame.new(0, floatY, 0)
        end
    end			
    floatFunc = rs2.Heartbeat:Connect(floatLoop)
    elseif not floatT then
        if char:FindFirstChild("floatPart") then
            char:FindFirstChild("floatPart"):Destroy()
        end
    end
end

function masslessF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    for i, e in char:GetChildren() do
        if e:IsA("BasePart") and masslessT then
            e.Massless = true
        elseif e:IsA("BasePart") and not masslessT then
            e.Massless = false
        end
    end
end

function updateBlobLoopServerF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    updateCurrentBlobmanF()
    for i, e in game.Players:GetPlayers() do
        if e.Character:FindFirstChild("HumanoidRootPart") == nil then continue end
        if e.Character:FindFirstChild("HumanoidRootPart") and hum then
            if currentBlobS ~= nil and blobLoopServerT then
                blobGrabF(currentBlobS, e.Character:WaitForChild("HumanoidRootPart"), "Left")
                wait(0.05)
                blobDropF(currentBlobS, e.Character:WaitForChild("HumanoidRootPart"), "Left")
                wait(0.05)
                silentBlobGrabF(currentBlobS, e.Character:WaitForChild("HumanoidRootPart"), "Left")
            end
        end
    end
    while blobLoopServerT and task.wait(6.25) do
        for i, e in game.Players:GetPlayers() do
            if e.Character:FindFirstChild("HumanoidRootPart") == nil then continue end
            if e.Character:FindFirstChild("HumanoidRootPart") and hum then
                if currentBlobS ~= nil and blobLoopServerT then
                    blobGrabF(currentBlobS, e.Character:WaitForChild("HumanoidRootPart"), "Left")
                    wait(0.05)
                    blobDropF(currentBlobS, e.Character:WaitForChild("HumanoidRootPart"), "Left")
                    wait(0.05)
                    silentBlobGrabF(currentBlobS, e.Character:WaitForChild("HumanoidRootPart"), "Left")
                end
            end
        end
    end
end

function lagF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    while wait(1) and lagT do
        for a = 0, linesV do
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character.Torso ~= nil then
                    rs.GrabEvents.CreateGrabLine:FireServer(player.Character.Torso, player.Character.Torso.CFrame)
                end
            end
        end
    end
end

function pingF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    while task.wait() and pingT do
        rs.GrabEvents.ExtendGrabLine:FireServer(string.rep("Balls Balls Balls Balls", packetsV))
    end
end

function shurikenLagServerF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if shurikenLagServerT then
        local ToyFolder
        for _, v in pairs(workspace.Plots:GetChildren()) do
            for _, b in pairs(v.PlotSign.ThisPlotsOwners:GetChildren()) do
                if b.Value == plr.Name then
                    ToyFolder = workspace.PlotItems[v.Name]
                end
            end
        end
        local decoys = {}
        local shurikens = {}

        for _, obj in pairs(ToyFolder:GetChildren()) do
            if obj:IsA("Model") then
                if obj.Name == "NpcRobloxianMascot" then
                    table.insert(decoys, obj)
                elseif obj.Name == "NinjaShuriken" then
                    table.insert(shurikens, obj)
                end
            end
        end

        local maxshurikensperdecoy = 8

        for decoyindex, decoy in ipairs(decoys) do
            local decoyHRP = decoy:FindFirstChild("HumanoidRootPart")
            if decoyHRP and shurikenLagServerT then
                local startindex = (decoyindex - 1) * maxshurikensperdecoy + 1
                local endindex = startindex + maxshurikensperdecoy - 1
                for shurikenindex = startindex, endindex do
                    local shuriken = shurikens[shurikenindex]
                    if not shuriken then
                        break
                    end
                    local StickyPart = shuriken:FindFirstChild("StickyPart")
                    if StickyPart then
                        StickyPart.CanTouch = true
                        for _, part in pairs(decoy:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                        local BodyPosition = Instance.new("BodyPosition")
                        BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        BodyPosition.P = 10000
                        BodyPosition.D = 500
                        BodyPosition.Parent = StickyPart
                        for _, part in pairs(shuriken:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                        for _, child in pairs(StickyPart:GetChildren()) do
                            if child.Name == "TouchInterest" then
                                child:Destroy()
                            end
                        end
                        task.defer(function()
                            repeat
                                StickyPart.AssemblyAngularVelocity = Vector3.new(
                                    math.random(-100, 100) * 50,
                                    math.random(-100, 100) * 50,
                                    math.random(-100, 100) * 50
                                )
                                BodyPosition.Position = Vector3.new(
                                    decoyHRP.Position.X,
                                    decoyHRP.Position.Y - 4,
                                    decoyHRP.Position.Z
                                )
                                wait(0.0001)
                                BodyPosition.Position = Vector3.new(
                                    decoyHRP.Position.X,
                                    decoyHRP.Position.Y + 3,
                                    decoyHRP.Position.Z
                                )
                                wait(0.0001)
                            until not shurikenLagServerT or not shuriken.Parent or not decoy.Parent
                        end)
                    end
                    wait()
                end
            end
            wait()
        end
    end
end

function tpF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if not slideTPT then
        if char and hrp and mouse.Target and not slideTPT then hrp.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z) end
    elseif slideTPT then
        if not slideTPD and slideTPT and mouse.Target then
            slideTPD = true
            local info = TweenInfo.new(
                0.5, 
                Enum.EasingStyle.Sine, 
                Enum.EasingDirection.In,
                0,
                false,
                0
            )
            local info2 = TweenInfo.new(
                0.5, 
                Enum.EasingStyle.Sine, 
                Enum.EasingDirection.In,
                0,
                true,
                0
            )
            local e = {["CFrame"] = CFrame.new(mouse.Hit.x, mouse.Hit.y + 3, mouse.Hit.z)}
            local e2 = {FieldOfView = 100}
            char.Head.CanCollide = false
            char.Torso.CanCollide = false
            game:GetService("TweenService"):Create(hrp, info, e):Play()
            game:GetService("TweenService"):Create(cam, info2, e2):Play()
            wait(0.55)
            char.Head.CanCollide = true
            char.Torso.CanCollide = true
            cam.FieldOfView = 70
            slideTPD = false
        end
    end
end

function floatUpF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if floatUpT and not floatDownT then
        floatY = -1.6
    elseif not floatUpT then
        floatY = -3.1
    end
end

function floatDownF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if floatDownT and not floatUpT then
        floatY = -3.6
    elseif not floatDownT then
        floatY = -3.1
    end
end

function inspectF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    mouseTargetInspectF()
    inspectInfoF()
    if not inspectD then
        inspectD = true
        if inspectT then
            if currentInspectS == 1 then
                currentInspectedAdorneeS = mouse.Target.Parent
                currentInspectedPartS = mouse.Target
                highlightC = highlight:Clone()
                highlightC.Adornee = mouse.Target.Parent
                highlightC.Parent = mouse.Target
                highlightC.FillColor = Color3.fromRGB(255, 255, 255)
                highlightC.OutlineColor = Color3.fromRGB(160, 11, 11)
            elseif currentInspectS == 2 then
                currentInspectedAdorneeS = workspace.Plots:FindFirstChild("Plot"..currentHouseInspectS)
                currentInspectedPartS = mouse.Target
                highlightC = highlight:Clone()
                highlightC.Adornee = workspace.Plots:FindFirstChild("Plot"..currentHouseInspectS)
                highlightC.Parent = mouse.Target
                highlightC.FillColor = Color3.fromRGB(255, 255, 255)
                highlightC.OutlineColor = Color3.fromRGB(0, 60, 180)
            elseif currentInspectS == 3 then
                currentInspectedAdorneeS = mouse.Target.Parent
                currentInspectedPartS = mouse.Target
                highlightC = highlight:Clone()
                highlightC.Adornee = mouse.Target.Parent
                highlightC.Parent = mouse.Target
                highlightC.FillColor = Color3.fromRGB(255, 255, 255)
                highlightC.OutlineColor = Color3.fromRGB(20, 170, 20)
            elseif currentInspectS == 4 then
                currentInspectedAdorneeS = mouse.Target.Parent
                currentInspectedPartS = mouse.Target
                highlightC = highlight:Clone()
                highlightC.Adornee = mouse.Target.Parent
                highlightC.Parent = mouse.Target
                highlightC.FillColor = Color3.fromRGB(255, 255, 255)
                highlightC.OutlineColor = Color3.fromRGB(180, 20, 180)
            end
        elseif not inspectT then
            currentInspectS = 0
            currentHouseInspectS = 0
            currentInspectedPartS = nil
            currentInspectedAdorneeS = nil
            highlightC:Destroy()
        end
        wait(0.1)
        inspectD = false
    end
end

function inspectInfoF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if not inspectInfoOnT and inspectInfoT and inspectT and currentInspectS ~= 0 and currentInspectedPartS ~= nil and currentInspectedAdorneeS ~= nil then
        inspectInfoOnT = true
        billboardC = billboard:Clone()
        billboardC.Adornee = currentInspectedAdorneeS
        billboardC.Parent = currentInspectedPartS

        scrollframeC = scrollframe:Clone()
        scrollframeC.Parent = billboardC
        scrollframeC.Size = UDim2.new(0, 160, 0, 40)
        scrollframeC.ScrollBarImageTransparency = 1 

        textlabelC1 = textlabel:Clone()
        textlabelC1.Parent = scrollframeC
        textlabelC1.Size = UDim2.new(0, 140, 0, 40)
        if currentInspectS == 1 then
            textlabelC1.Text = currentInspectedAdorneeS.Name.." ("..game.Players:FindFirstChild(currentInspectedAdorneeS.Name).DisplayName..")"
        else
            textlabelC1.Text = currentInspectedAdorneeS.Name
        end
    elseif not inspectInfoT and inspectInfoOnT or not inspectT and inspectInfoOnT then
        inspectInfoOnT = false
        inspectInfoT = false
        billboardC:Destroy()
    end
end

function inspectBringF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if inspectT and currentInspectS ~= 2 and currentInspectS ~= 4 then
        returnPosS = hrp.CFrame
        hrp.CFrame = currentInspectedAdorneeS.PrimaryPart.CFrame + Vector3.new(7, 3, 0)
        wait(0.15)
        if currentInspectS == 1 then
            rs.GrabEvents.SetNetworkOwner:FireServer(currentInspectedAdorneeS:WaitForChild("HumanoidRootPart"), currentInspectedAdorneeS:WaitForChild("HumanoidRootPart").CFrame)
            wait(0.1)
            currentInspectedAdorneeS:WaitForChild("HumanoidRootPart").CFrame = returnPosS
        else
            rs.GrabEvents.SetNetworkOwner:FireServer(currentInspectedAdorneeS.PrimaryPart, currentInspectedAdorneeS.PrimaryPart.CFrame)
            wait(0.1)
            currentInspectedAdorneeS.PrimaryPart.CFrame = returnPosS
        end
        hrp.CFrame = returnPosS
    elseif not inspectT then
        if mouse.Target.Parent:IsDescendantOf(workspace.PlotItems) or string.match(mouse.Target.Parent.Parent.Name, "SpawnedInToys") or mouse.Target.Parent.Parent:FindFirstChild("SpawningPlatform") or mouse.Target.Parent:FindFirstChildOfClass("Humanoid") then
            returnPosS = hrp.CFrame
            mouseTargetS = mouse.Target
            hrp.CFrame = mouseTargetS.Parent.PrimaryPart.CFrame + Vector3.new(10, 3, 0)
            wait(0.15)
            if mouseTargetS.Parent:FindFirstChildOfClass("Humanoid") then
                rs.GrabEvents.SetNetworkOwner:FireServer(mouseTargetS.Parent:WaitForChild("HumanoidRootPart"), mouseTargetS.Parent:WaitForChild("HumanoidRootPart").CFrame)
                wait(0.1)
                mouseTargetS.Parent:WaitForChild("HumanoidRootPart").CFrame = returnPosS
            else
                rs.GrabEvents.SetNetworkOwner:FireServer(mouseTargetS.Parent.PrimaryPart, mouseTargetS.Parent.PrimaryPart.CFrame)
                wait(0.1)
                mouseTargetS.Parent.PrimaryPart.CFrame = returnPosS
            end
            hrp.CFrame = returnPosS
            mouseTargetS = nil
        end
    end
end

function ragdollSpamF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    while ragdollSpamT and not ragdollSpamD and not permRagdollT do
        ragdollSpamD = true
            local args = {
                [1] = hrp,
                [2] = 0
            }
            rs:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote"):FireServer(unpack(args))
        task.wait(0.02)
        ragdollSpamD = false
    end
end

function setRagdollF(state)
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if char and char:FindFirstChild("HumanoidRootPart") then
        rs:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote"):FireServer(hrp, state and 1 or 0)
        if hum then hum.PlatformStand = state end
    end
end

function permRagdollLoopF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if permRagdollRunningS then return end
    permRagdollRunningS = true
    while permRagdollT do
        setRagdollF(true)
        task.wait(0.5)
    end
    permRagdollRunningS = false
    setRagdollF(false)
end

function getBlobmanF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    updateCurrentHouseF()
    if currentHouseS == 0 then
        if inv then return inv:FindFirstChild("CreatureBlobman") end
        return nil
    else
        return workspace.PlotItems:FindFirstChild("Plot"..currentHouseS):FindFirstChild("CreatureBlobman")
    end
end

function spawnBlobmanF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local spawnRemote = rs:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
    if spawnRemote then
        pcall(function()spawnRemote:InvokeServer("CreatureBlobman", hrp.CFrame*CFrame.new(0,0,-5),Vector3.new(0, -15.716, 0))end)
        task.wait(1)
        blobmanInstanceS = getBlobmanF()
    end
end

function destroyBlobmanF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if blobmanInstanceS and destroyAutoGucciT then
        if currentHouseS == 0 then
            local args = {[1] = blobmanInstanceS}
            local destroyRemote = rs:FindFirstChild("MenuToys") and rs.MenuToys:FindFirstChild("DestroyToy")
            if destroyRemote then pcall(function()destroyRemote:FireServer(unpack(args))end)end
            blobmanInstanceS = nil
        else
            blobmanInstanceS.HumanoidRootPart.CFrame = workspace.Plots:FindFirstChild("Plot"..currentHouseS).TeslaCoil.ZapPart.CFrame
            blobmanInstanceS = nil
        end
    end
end

function ragdollLoopF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if ragdollLoopD then return end
    ragdollLoopD = true
    while sitJumpT do
        if char and hrp then
            local args={[1] = hrp, [2] = 0}
            rs:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote"):FireServer(unpack(args))
        end
        task.wait()
    end
    ragdollLoopD = false
end

function sitJumpF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if not char or not hum then return end
    local startTime = tick()
    while autoGucciT and tick()-startTime<6 do
        if blobmanInstanceS then
            local seat = blobmanInstanceS:FindFirstChildWhichIsA("VehicleSeat")
            if seat and seat.Occupant ~= hum then seat:Sit(hum) end
        end
        task.wait(0.1)
        if char and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping)end
        task.wait(0.1)
    end
    if blobmanInstanceS then destroyBlobmanF() end
    autoGucciT = false
    sitJumpT = false
end

function stopVelocityF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    hrp.AssemblyLinearVelocity = Vector3.zero
end

function zoomF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if zoomT then
        cam.FieldOfView = zoomV
    elseif not zoomT then
        cam.FieldOfView = 70
    end
end

function addToysF()
end

function spychatF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    publicItalics = true
    privateProperties = {
        Color = Color3.fromRGB(245, 245, 40); 
        Font = Enum.Font.SourceSansBold;
        TextSize = 18;
    }
    local StarterGui = game:GetService("StarterGui")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
    local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
    local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
    local instance = (_G.chatSpyInstance or 0) + 1
    _G.chatSpyInstance = instance
    local function onChatted(p, msg)
        if _G.chatSpyInstance == instance then
            if spychatT and (spySelfT or p~=player) then
                msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
                local hidden = true
                local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
                    if packet.SpeakerUserId==p.UserId and packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All" or (channel=="Team" and not publicSpyT and Players[packet.FromSpeaker].Team==player.Team)) then
                        hidden = false
                    end
                end)
                wait(1)
                conn:Disconnect()
                if hidden and spychatT then
                    if publicSpyT then
                        saymsg:FireServer((publicItalics and '').."{SPY} [".. p.Name .. "(" .. p.DisplayName .. ")" .."]: "..msg,"All")
                    else
                        privateProperties.Text = "{SPY} [".. p.Name .. "(" .. p.DisplayName .. ")" .."]: "..msg
                        StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
                    end
                end
            end
        end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        p.Chatted:Connect(function(msg) onChatted(p,msg) end)
    end
    Players.PlayerAdded:Connect(function(p)
        p.Chatted:Connect(function(msg) onChatted(p,msg) end)
    end)
    privateProperties.Text = "{SPY "..(spychatT and "EN" or "DIS").."ABLED}"
    StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
    if not player.PlayerGui:FindFirstChild("Chat") then wait(3) end
    local chatFrame = player.PlayerGui.Chat.Frame
    chatFrame.ChatChannelParentFrame.Visible = true
    chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
end

local Window = Rayfield:CreateWindow({
    Name = "critcl",
    Icon = 0,
    LoadingTitle = "critcl ftap",
    LoadingSubtitle = "by wploits lol",
    Theme = "Amethyst",
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "critclftap"
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

local grabTab = Window:CreateTab("grab", 0)
local antiTab = Window:CreateTab("protect", 0)
local loopTab = Window:CreateTab("loop", 0)
local playerTab = Window:CreateTab("player", 0)
local serverTab = Window:CreateTab("server", 0)
local keybindTab = Window:CreateTab("keybinds", 0)
local chatTab = Window:CreateTab("chat", 0)

local flingSection = grabTab:CreateSection("Fling")

local flingToggle = grabTab:CreateToggle({
    Name = "Strong Throw",
    CurrentValue = false,
    Flag = "flingToggleFlag",
    Callback = function(Value)
        flingT = Value
        flingF()
    end
})

local strengthInput = grabTab:CreateInput({
    Name = "Strength",
    CurrentValue = 1000,
    PlaceholderText = "Strength",
    RemoveTextAfterFocusLost = false,
    Flag = "strengthInputFlag",
    Callback = function(Value)
        strengthV = Value
    end
})

local grabSection = grabTab:CreateSection("Grab")

local killGrabToggle = grabTab:CreateToggle({
    Name = "KillGrab",
    CurrentValue = false,
    Flag = "killGrabToggleFlag",
    Callback = function(Value)
        killGrabT = Value
        killGrabF()
    end
})

local lineSection = grabTab:CreateSection("Line")

local extendLineToggle = grabTab:CreateToggle({
    Name = "ExtendLine",
    CurrentValue = false,
    Flag = "extendLineToggleFlag",
    Callback = function(Value)
        infLineExtendT = Value
        infLineExtendF()
    end
})

local extendLineInput = grabTab:CreateInput({
    Name = "ExtendLineAmount",
    CurrentValue = 0,
    PlaceholderText = "Amount",
    RemoveTextAfterFocusLost = false,
    Flag = "extendLineInputFlag",
    Callback = function(Value)
        increaseLineExtendV = Value
    end
})
extendLineInput:Set(7)

local antiGrab1Toggle = antiTab:CreateToggle({
    Name = "AntiGrab",
    CurrentValue = false,
    Flag = "antiGrab1ToggleFlag",
    Callback = function(Value)
        antiGrab1T = Value
        antiGrab1F()
    end
})

local antiGrab1AnchorToggle = antiTab:CreateToggle({
    Name = "AntiGrabAnchor",
    CurrentValue = false,
    Flag = "antiGrab1AnchorToggleFlag",
    Callback = function(Value)
        antiGrab1AnchorT = Value
    end
})

local antiExplodeToggle = antiTab:CreateToggle({
    Name = "AntiExplode",
    CurrentValue = false,
    Flag = "antiExplodeToggleFlag",
    Callback = function(Value)
        antiExplodeT = Value
        antiExplodeF()
    end
})

local antiLagToggle = antiTab:CreateToggle({
    Name = "AntiLag",
    CurrentValue = false,
    Flag = "antiLagToggleFlag",
    Callback = function(Value)
        antiLagT = Value
        antiLagF()
    end
})

local antiStickyToggle = antiTab:CreateToggle({
    Name = "AntiSticky",
    CurrentValue = false,
    Flag = "antiStickyToggleFlag",
    Callback = function(Value)
        antiStickyT = Value
        antiStickyF()
    end
})

local antiBlob1Toggle = antiTab:CreateToggle({
    Name = "AntiBlob",
    CurrentValue = false,
    Flag = "antiBlob1ToggleFlag",
    Callback = function(Value)
        antiBlob1T = Value
        antiBlob1F()
    end
})

local loopPlayerDropdown = loopTab:CreateDropdown({
	Name = "PlayerLoop",
	Options = getPlayerList(),
	CurrentOption = {},
	MultipleOptions = true,
	Flag = "playerLoopDropdownFlag", 
	Callback = function(Options)
		playersInLoop1V = Options
	end
})

game.Players.PlayerAdded:Connect(function(player)
    if loopPlayerDropdown then 
        loopPlayerDropdown:Refresh(getPlayerList(), true)  
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    if loopPlayerDropdown then 
        loopPlayerDropdown:Refresh(getPlayerList(), true)  
    end
end)

local blobLoopToggle = loopTab:CreateToggle({
    Name = "BlobLoop",
    CurrentValue = false,
    Flag = "blobLoopToggleFlag",
    Callback = function(Value)
        blobLoopT = Value
        if blobLoopT then
            for i, e in ipairs(playersInLoop1V) do
                table.insert(playersInLoop2V, e:match("^(.-) %("))
            end
            loopPlayerBlobF()
        elseif not blobLoopT then
            table.clear(playersInLoop2V)
            loopPlayerBlobF()
        end
    end
})

local humanoidSection = playerTab:CreateSection("Humanoid")

local walkSpeedToggle = playerTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Flag = "walkSpeedToggleFlag",
    Callback = function(Value)
        walkSpeedT = Value 
        updateWalkSpeedF()
    end
})

local walkSpeedInput = playerTab:CreateInput({
    Name = "WalkSpeed",
    CurrentValue = 16,
    PlaceholderText = "WalkSpeed",
    RemoveTextAfterFocusLost = false,
    Flag = "walkSpeedInputFlag",
    Callback = function(Value)
        walkSpeedV = Value
        updateWalkSpeedF()
    end
})

local jumpPowerToggle = playerTab:CreateToggle({
    Name = "JumpPower",
    CurrentValue = false,
    Flag = "jumpPowerToggleFlag",
    Callback = function(Value)
        jumpPowerT = Value
        updateJumpPowerF()
    end
})

local jumpPowerInput = playerTab:CreateInput({
    Name = "JumpPower",
    CurrentValue = 24,
    PlaceholderText = "JumpPower",
    RemoveTextAfterFocusLost = false,
    Flag = "jumpPowerInputFlag",
    Callback = function(Value)
        jumpPowerV = Value
        updateJumpPowerF()
    end
})

local otherSection = playerTab:CreateSection("Other")

local infJumpToggle = playerTab:CreateToggle({
    Name = "infJump",
    CurrentValue = false,
    Flag = "infJumpToggleFlag",
    Callback = function(Value)
        infJumpT = Value
        updateInfJumpF()
    end
})

local noClipToggle = playerTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "noClipToggleFlag",
    Callback = function(Value)
        noClipT = Value
        updateNoClipF()
    end
})

local floatToggle = playerTab:CreateToggle({
    Name = "Float",
    CurrentValue = false,
    Flag = "floatToggleFlag",
    Callback = function(Value)
        floatT = Value
        updateFloatF()
    end
})

local masslessToggle = playerTab:CreateToggle({
    Name = "Massless",
    CurrentValue = false,
    Flag = "masslessToggleFlag",
    Callback = function(Value)
        masslessT = Value
        masslessF()
    end
})

local blobSection = serverTab:CreateSection("Blob")

local blobLoopServerToggle = serverTab:CreateToggle({
    Name = "Destroy Server",
    CurrentValue = false,
    Flag = "blobLoopServerToggleFlag",
    Callback = function(Value)
        blobLoopServerT = Value
        updateBlobLoopServerF()
    end
})

local lagSection = serverTab:CreateSection("Lag")

local lagToggle = serverTab:CreateToggle({
    Name = "Lag",
    CurrentValue = false,
    Flag = "lagToggleFlag",
    Callback = function(Value)
        lagT = Value
        lagF()
    end
})

local linesInput = serverTab:CreateInput({
    Name = "Lines",
    CurrentValue = 400,
    PlaceholderText = "Lines",
    RemoveTextAfterFocusLost = false,
    Flag = "linesInputFlag",
    Callback = function(Value)
        linesV = Value
    end
})

local pingToggle = serverTab:CreateToggle({
    Name = "Ping",
    CurrentValue = false,
    Flag = "pingToggleFlag",
    Callback = function(Value)
        pingT = Value
        pingF()
    end
})

local packetsInput = serverTab:CreateInput({
    Name = "Packets",
    CurrentValue = 3000,
    PlaceholderText = "Packets",
    RemoveTextAfterFocusLost = false,
    Flag = "packetsInputFlag",
    Callback = function(Value)
        packetsV = Value
    end
})

local shurikenLagServerToggle = serverTab:CreateToggle({
    Name = "ShurikenLagServer",
    CurrentValue = false,
    Flag = "shurikenLagServerToggleFlag",
    Callback = function(Value)
        shurikenLagServerT = Value
        shurikenLagServerF()
    end
})

local tpSection = keybindTab:CreateSection("TP")

local tpKeybind = keybindTab:CreateKeybind({
    Name = "TP",
    CurrentKeybind = "Z",
    HoldToInteract = false,
    Flag = "tpKeybindFlag",
    Callback = function(Keybind)
        tpF()
    end
})

local slideTPToggle = keybindTab:CreateToggle({
    Name = "SlideTP",
    CurrentValue = false,
    Flag = "slideTPToggleFlag",
    Callback = function(Value)
        slideTPT = Value
    end
})

local inspectSection = keybindTab:CreateSection("Inspect")

local inspectKeybind = keybindTab:CreateKeybind({
    Name = "Inspect",
    CurrentKeybind = "Y",
    HoldToInteract = false,
    Flag = "inspectKeybindFlag",
    Callback = function(Keybind)
        if not inspectT then
            inspectT = true
        elseif inspectT then
            inspectT = false
        end
        inspectF()
    end
})

local inspectInfoKeybind = keybindTab:CreateKeybind({
    Name = "InspectInfo",
    CurrentKeybind = "U",
    HoldToInteract = false,
    Flag = "inspectInfoKeybindFlag",
    Callback = function(Keybind)
        if not inspectInfoT then
            inspectInfoT = true
        elseif inspectInfoT then
            inspectInfoT = false
        end
        inspectInfoF()
    end
})

local inspectBringKeybind = keybindTab:CreateKeybind({
    Name = "InspectBring",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "inspectBringKeybindFlag",
    Callback = function(Keybind)
        inspectBringF()
    end
})

local floatSection = keybindTab:CreateSection("Float")

local floatUpKeybind = keybindTab:CreateKeybind({
    Name = "floatUp",
    CurrentKeybind = "X",
    HoldToInteract = true,
    Flag = "floatUpKeybindFlag",
    Callback = function(Keybind)
        floatUpT = Keybind
        floatUpF()
    end
})

local floatDownKeybind = keybindTab:CreateKeybind({
    Name = "floatDown",
    CurrentKeybind = "C",
    HoldToInteract = true,
    Flag = "floatDownKeybindFlag",
    Callback = function(Keybind)
        floatDownT = Keybind
        floatDownF()
    end
})

local ragdollSection = keybindTab:CreateSection("Ragdoll")

local ragdollSpamKeybind = keybindTab:CreateKeybind({
    Name = "RagdollSpam",
    CurrentKeybind = "T",
    HoldToInteract = false,
    Flag = "ragdollSpamKeybindFlag",
    Callback = function(Keybind)
        if not ragdollSpamT then
            ragdollSpamT = true
        elseif ragdollSpamT then
            ragdollSpamT = false
        end
        ragdollSpamF()
    end
})

local permRagdollToggle = keybindTab:CreateToggle({
    Name = "PermRagdoll",
    CurrentValue = false,
    Flag = "permRagdollToggleFlag",
    Callback = function(Value)
        permRagdollT = Value
        if permRagdollT and not permRagdollRunningS then
            coroutine.wrap(permRagdollLoopF)()
        elseif not permRagdollT then
            permRagdollRunningS = false
        end
    end
})

local ragdollMoveButton = keybindTab:CreateButton({
    Name = "RagdollMove",
    Callback = function()
        local char = plr.Character
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        hum.Sit = false
        hum.Ragdolled.Value = false
    end
})

local autoGucciToggle = keybindTab:CreateToggle({
    Name = "AutoGucci",
    CurrentValue = false,
    Flag = "autoGucciToggleFlag",
    Callback = function(Value)
        autoGucciT = Value
        if autoGucciT then
            spawnBlobmanF()
            task.wait(1.1)
            if not sitJumpT then
                coroutine.wrap(sitJumpF)()
                sitJumpT = true
            end
            coroutine.wrap(ragdollLoopF)()
        else
            sitJumpT = false
        end
    end
})

local destroyAutoGucciToggle = keybindTab:CreateToggle({
    Name = "DestroyAutoGucci",
    CurrentValue = false,
    Flag = "destroyAutoGucciToggleFlag",
    Callback = function(Value)
        destroyAutoGucciT = Value
    end
})

local randomSection = keybindTab:CreateSection("Random")

local zoomKeybind = keybindTab:CreateKeybind({
    Name = "CameraZoom",
    CurrentKeybind = "V",
    HoldToInteract = false,
    Flag = "zoomKeybindFlag",
    Callback = function(Keybind)
        if not zoomT then
            zoomT = true
        elseif zoomT then
            zoomT = false
        end
        zoomF()
    end
})

local zoomSlider = keybindTab:CreateSlider({
    Name = "Zoom",
    Range = {0, 120},
    Increment = 1,
    Suffix = "Zoom",
    CurrentValue = 10,
    Flag = "zoomSliderFlag",
    Callback = function(Value)
        zoomV = Value
        zoomF()
    end
})

local stopVelocityKeybind = keybindTab:CreateKeybind({
    Name = "StopVelocity",
    CurrentKeybind = "G",
    HoldToInteract = false,
    Flag = "stopVelocityKeybindFlag",
    Callback = function(Keybind)
        stopVelocityF()
    end
})

local spychatToggle = chatTab:CreateToggle({
    Name = "Spychat",
    CurrentValue = false,
    Flag = "spychatToggleFlag",
    Callback = function(Value)
        spychatT = Value
        spychatF()
    end
})
local spySelfToggle = chatTab:CreateToggle({
    Name = "SpySelf",
    CurrentValue = false,
    Flag = "spySelfToggleFlag",
    Callback = function(Value)
        spySelfT = Value
    end
})

local publicSpyToggle = chatTab:CreateToggle({
    Name = "PublicSpy",
    CurrentValue = false,
    Flag = "publicSpyToggleFlag",
    Callback = function(Value)
        publicSpyT = Value
    end
})
