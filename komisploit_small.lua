-- KomiExploit - Optimized BedWars Combat & Aim Assist (Compact Version)
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 350)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Text = "Komisploit"
titleLabel.TextSize = 28
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Keybinding defaults
local keyBindings = { killAura = "K", toggleUI = "U" }

-- Function to create buttons
local function createButton(name, pos, action)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0, 320, 0, 40)
    button.Position = pos
    button.Text = name
    button.TextSize = 20
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    button.MouseButton1Click:Connect(action)
end

-- Keybinding function
local function listenForKeyPress(button, keyAction)
    local function onKeyPress(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keyBindings[keyAction] = input.KeyCode.Name
            button.Text = name .. ": " .. keyBindings[keyAction]
        end
    end
    game:GetService("UserInputService").InputBegan:Connect(onKeyPress)
end

createButton("Kill Aura Key", UDim2.new(0, 15, 0, 60), function() listenForKeyPress() end)
createButton("Toggle UI Key", UDim2.new(0, 15, 0, 110), function() listenForKeyPress() end)

-- Kill Aura Combat Automation
local killAuraEnabled = false
local function findAndAttackEnemy()
    for _, enemy in pairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character then
            local dist = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
            if dist < 5 then
                local sword = player.Backpack:FindFirstChildOfClass("Tool")
                if sword then
                    sword.Activated:Fire()
                end
            end
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode.Name == keyBindings.killAura then
        killAuraEnabled = not killAuraEnabled
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if killAuraEnabled then
        findAndAttackEnemy()
    end
end)

-- Toggle UI visibility
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode.Name == keyBindings.toggleUI then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
