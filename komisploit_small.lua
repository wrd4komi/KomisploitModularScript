-- [[ Basic JJSploit-Compatible Script for BedWars ]] --

print("JJSploit-Compatible Script Loaded")

-- Check if in BedWars Game
if not game.PlaceId == 6872265039 then
    print("This script is designed for BedWars only!")
    return
end

-- Basic Kill Aura
local function activateKillAura()
    print("Kill Aura Activated")

    -- Connect a loop to damage nearby enemies
    while wait(0.5) do
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).magnitude
                    if distance < 15 then -- Attack range
                        local args = {
                            [1] = target.Character
                        }
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild("DamageEvent"):FireServer(unpack(args))
                    end
                end
            end
        end
    end
end

-- Basic Aim Assist
local function activateAimAssist()
    print("Aim Assist Activated")
    game:GetService("RunService").RenderStepped:Connect(function()
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).magnitude
                    if distance < 50 then -- Aim assist range
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end)
end

-- Activate Kill Aura and Aim Assist
spawn(activateKillAura)
spawn(activateAimAssist)

print("Script Running - Enjoy!")

