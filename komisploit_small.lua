-- [[ Komi Sploit - Universal Script Loader with Integrated Aimbot (No External Scripts) ]] --

print("Komi Sploit Loading...")

-- Compatibility Layer
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local isfile = isfile or function() return false end
local readfile = readfile or function() return "" end
local writefile = writefile or function() end
local makefolder = makefolder or function() end
local delfile = delfile or function() end
local setidentity = setidentity or function() end
local getidentity = getidentity or function() return 8 end
local httpRequest = syn and syn.request or http_request or (fluxus and fluxus.request) or function(req)
    return {Success = true, Body = game:HttpGet(req.Url)}
end

if not httpRequest then
    error("Your executor does not support HTTP requests. Use a more advanced executor.")
end

-- Error Popup (Advanced Executors)
local function displayErrorPopup(text)
    if not getrenv or not getrenv().require then
        print("[ERROR] " .. text)
        return
    end
    local oldidentity = getidentity()
    setidentity(8)
    local ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
    local prompt = ErrorPrompt.new("Default")
    prompt._hideErrorCode = true
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    prompt:setErrorTitle("Komi Sploit Error")
    prompt:updateButtons({
        {
            Text = "OK",
            Callback = function() prompt:_close() end,
            Primary = true
        }
    }, 'Default')
    prompt:setParent(gui)
    prompt:_open(text)
    setidentity(oldidentity)
end

-- Feature Toggles
local AimAssistEnabled = false
local KillAuraEnabled = false

-- Aimbot/Aim Assist Settings
local aimSmoothness = 0.5  -- How smoothly the camera transitions to the target

-- Kill Aura Settings
local killAuraRange = 5

-- GUI Setup (Komi Sploit UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KomiSploitUI"
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
end
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.Size = UDim2.new(0, 300, 0, 220)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.2

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "Komi Sploit"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)

local currentYOffset = 40
local function createToggleButton(name, defaultValue, callback)
    local ButtonFrame = Instance.new("Frame", MainFrame)
    ButtonFrame.Size = UDim2.new(0, 280, 0, 30)
    ButtonFrame.Position = UDim2.new(0,10,0,currentYOffset)
    ButtonFrame.BackgroundTransparency = 1
    currentYOffset = currentYOffset + 40

    local Label = Instance.new("TextLabel", ButtonFrame)
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(200,200,200)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0,200,1,0)
    Label.Position = UDim2.new(0,0,0,0)

    local ToggleFrame = Instance.new("Frame", ButtonFrame)
    ToggleFrame.Size = UDim2.new(0,50,0,20)
    ToggleFrame.Position = UDim2.new(1,-60,0.5,-10)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    ToggleFrame.BorderSizePixel = 0

    local ToggleCorner = Instance.new("UICorner", ToggleFrame)
    ToggleCorner.CornerRadius = UDim.new(0,10)

    local ToggleButton = Instance.new("Frame", ToggleFrame)
    ToggleButton.Size = UDim2.new(0,18,0,18)
    ToggleButton.Position = defaultValue and UDim2.new(1,-19,0.5,-9) or UDim2.new(0,1,0.5,-9)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
    ToggleButton.BorderSizePixel = 0

    local ButtonCorner = Instance.new("UICorner", ToggleButton)
    ButtonCorner.CornerRadius = UDim.new(0,9)

    local state = defaultValue
    local function updateToggle(newState)
        state = newState
        if state then
            ToggleButton:TweenPosition(UDim2.new(1,-19,0.5,-9), "Out", "Sine", 0.2, true)
        else
            ToggleButton:TweenPosition(UDim2.new(0,1,0.5,-9), "Out", "Sine", 0.2, true)
        end
        callback(state)
    end

    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle(not state)
        end
    end)

    return updateToggle
end

-- Create Toggles
createToggleButton("Aim Assist", false, function(enabled)
    AimAssistEnabled = enabled
end)

createToggleButton("Kill Aura", false, function(enabled)
    KillAuraEnabled = enabled
end)

-- GUI Visibility Toggle (RightShift)
local guiVisible = true
local function toggleGui()
    guiVisible = not guiVisible
    ScreenGui.Enabled = guiVisible
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

-- Aimbot (Integrated into Aim Assist)
local function getClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge
    local myPosition = Camera.CFrame.Position
    local myTeam = LocalPlayer.Team

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if not myTeam or player.Team ~= myTeam then
                    local torso = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")
                    if torso then
                        local distance = (myPosition - torso.Position).magnitude
                        if distance < shortestDistance and distance <= 32 then
                            closestEnemy = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end

    return closestEnemy
end

local function aimAtClosestEnemy()
    local target = getClosestEnemy()
    if target and target.Character then
        local torso = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("HumanoidRootPart")
        if torso then
            local targetPosition = torso.Position
            local currentPosition = Camera.CFrame.Position

            if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
                -- First-person aiming
                Camera.CFrame = CFrame.new(currentPosition, targetPosition)
            else
                -- Third-person aiming with smoothness
                local smoothPosition = currentPosition:Lerp(targetPosition, aimSmoothness)
                Camera.CFrame = CFrame.new(smoothPosition, targetPosition)
            end
        end
    end
end

-- Kill Aura Function
local function performKillAura()
    local playerChar = LocalPlayer.Character
    if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
        local playerPos = playerChar.HumanoidRootPart.Position
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") and enemy.Character:FindFirstChild("Humanoid") then
                local dist = (playerPos - enemy.Character.HumanoidRootPart.Position).magnitude
                if dist <= killAuraRange then
                    enemy.Character.Humanoid:TakeDamage(10)
                end
            end
        end
    end
end

-- Main Loop (Run every frame)
RunService.RenderStepped:Connect(function()
    if AimAssistEnabled then
        aimAtClosestEnemy()
    end
    if KillAuraEnabled then
        performKillAura()
    end
end)

print("Komi Sploit Loaded Successfully!")
