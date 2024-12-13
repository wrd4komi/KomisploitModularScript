-- Complex Script for BedWars in JJSploit

-- Debug Information
print("Complex Script Loaded - BedWars Only")

-- Ensure we're in BedWars
if game.PlaceId ~= 6872265039 then
    print("Not in BedWars! Exiting...")
    return
end

-- Basic helper functions to check for the player and parts
local function getPlayer()
    return game.Players.LocalPlayer
end

local function isPlayerValid(player)
    return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function getDistanceBetween(player1, player2)
    return (player1.HumanoidRootPart.Position - player2.HumanoidRootPart.Position).magnitude
end

-- Modular Aim Assist
local function aimAssist(target)
    local player = getPlayer()
    if isPlayerValid(player) and isPlayerValid(target) then
        local distance = getDistanceBetween(player.Character, target.Character)
        if distance < 15 then -- Adjust the range for aim assist
            print("Aiming at:", target.Name)
            -- You can add your aiming logic here, for example:
            -- Aim at the enemy's head (not implemented for JJSploit)
        end
    end
end

-- Modular Kill Aura
local function activateKillAura()
    print("Kill Aura Activated")
    local player = getPlayer()
    while wait(0.5) do
        if isPlayerValid(player) then
            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= player and isPlayerValid(target) then
                    local distance = getDistanceBetween(player.Character, target.Character)
                    if distance < 15 then
                        print("Attacking:", target.Name)

                        -- Try to Fire Damage Event (in case it works)
                        local args = { target.Character }
                        local eventPath = game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts")
                            and game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild("DamageEvent")
                        
                        if eventPath then
                            eventPath:FireServer(unpack(args))
                        else
                            print("Damage Event Path not found")
                        end
                    end
                end
            end
        end
    end
end

-- Main Function to control the script
local function startScript()
    -- Initialize
    print("Starting Complex Script...")

    -- Ensure Kill Aura is activated
    spawn(activateKillAura)
    
    -- Other Complex Features (e.g., Auto-Equip, Teleport, etc.)
    -- You can add additional features here for more complexity if desired

end

-- Start the script
startScript()

print("Complex Script Running")
