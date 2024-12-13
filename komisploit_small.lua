-- [[ Universal Script Loader - Fully Compatible with JJSploit ]] --
print("Script Loading Started")

-- Compatibility Layer for Basic Executors
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

-- Function to Check HTTP Support
if not httpRequest then
    error("Your executor does not support HTTP requests. Please use an executor like Synapse X, KRNL, or Fluxus.")
end

-- Function to Display Errors for Advanced Executors
local function displayErrorPopup(text)
    if not getrenv or not getrenv().require then
        print("[ERROR] " .. text) -- Fallback for basic executors like JJSploit
        return
    end

    local oldidentity = getidentity()
    setidentity(8) -- Set thread identity for GUI creation
    local ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
    local prompt = ErrorPrompt.new("Default")
    prompt._hideErrorCode = true
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    prompt:setErrorTitle("Script Error")
    prompt:updateButtons({
        {
            Text = "OK",
            Callback = function()
                prompt:_close()
            end,
            Primary = true
        }
    }, 'Default')
    prompt:setParent(gui)
    prompt:_open(text)
    setidentity(oldidentity) -- Restore thread identity
end

-- Function to Fetch Scripts
local function fetchScript(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return result
    else
        displayErrorPopup("Failed to fetch script from: " .. url)
        return "return -- Failed to fetch script"
    end
end

-- Load Dynamic Modules
local function loadModule(url)
    local scriptContent = fetchScript(url)
    local success, err = pcall(function()
        loadstring(scriptContent)()
    end)
    if not success then
        displayErrorPopup("Error executing module from: " .. url .. " | Error: " .. err)
    end
end

-- Module URLs
local modules = {
    AimAssist = "https://example.com/aim_assist.lua", -- Replace with the actual URLs
    KillAura = "https://example.com/kill_aura.lua",
    MainLogic = "https://example.com/main_logic.lua"
}

-- Load Each Module
for name, url in pairs(modules) do
    print("Loading Module: " .. name)
    loadModule(url)
end

-- Example Modular Functionality (Aim Assist)
local function initializeAimAssist()
    print("Initializing Aim Assist...")
    -- Add your aim assist logic here
    game:GetService("RunService").RenderStepped:Connect(function()
        -- Dummy logic for aim assist
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            print("Aim Assist Active for: " .. player.Name)
        end
    end)
end

-- Example Modular Functionality (Kill Aura)
local function initializeKillAura()
    print("Initializing Kill Aura...")
    -- Add your kill aura logic here
    game:GetService("RunService").RenderStepped:Connect(function()
        -- Dummy logic for kill aura
        for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") then
                enemy.Humanoid:TakeDamage(10)
            end
        end
    end)
end

-- Initialize Modules Dynamically
initializeAimAssist()
initializeKillAura()

-- Final Script Message
print("Script Loaded Successfully!")
