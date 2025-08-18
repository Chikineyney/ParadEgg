-- ParadEgg.lua (Enhanced with Notifications + Settings Panel + Version System)

-- ==============================
-- Script Version
-- ==============================
getgenv().ParadEgg_Version = "v1.2" -- ⬅️ Update this each time you push to GitHub

-- ==============================
-- Default Settings
-- ==============================
getgenv().baldTeam = 1
getgenv().koiTeam = 2
getgenv().sealTeam = 3
getgenv().eggPlace = {"Paradise Egg"} 
getgenv().petSell = {"Ostrich", "Peacock", "Scarlet Macaw", "Capybara"}
getgenv().KG = 3
getgenv().Age = 1
getgenv().maxEgg = 8
getgenv().autoPlaceEgg = true
getgenv().farmEggs = true

-- Notification Settings
getgenv().notifDuration = 2
getgenv().notifSound = true
getgenv().debug = false

-- ==============================
-- Roblox Services
-- ==============================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==============================
-- ScreenGui
-- ==============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- ==============================
-- Notification Holder
-- ==============================
local NotifHolder = Instance.new("Frame")
NotifHolder.Parent = ScreenGui
NotifHolder.Size = UDim2.new(0.3, 0, 1, 0)
NotifHolder.Position = UDim2.new(0.7, 0, 0, 0)
NotifHolder.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = NotifHolder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- ==============================
-- Notification Function
-- ==============================
local function createNotification(msg)
    local Notif = Instance.new("Frame")
    Notif.Parent = NotifHolder
    Notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Notif.Size = UDim2.new(1, -10, 0, 40)
    Notif.BackgroundTransparency = 0.1
    Notif.ClipsDescendants = true
    Notif.BorderSizePixel = 0

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Notif

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(200, 200, 0)
    Stroke.Parent = Notif

    local Label = Instance.new("TextLabel")
    Label.Parent = Notif
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 5, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = msg
    Label.Font = Enum.Font.GothamSemibold
    Label.TextColor3 = Color3.fromRGB(255, 230, 50)
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left

    -- Tween In
    Notif.Position = UDim2.new(1, 0, 0, 0)
    TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    -- Play sound
    if getgenv().notifSound then
        local s = Instance.new("Sound", workspace)
        s.SoundId = "rbxassetid://5419097925"
        s.Volume = 2
        s:Play()
        game:GetService("Debris"):AddItem(s, 3)
    end

    -- Auto remove
    task.delay(getgenv().notifDuration, function()
        TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.5)
        Notif:Destroy()
    end)
end

-- ==============================
-- Settings Panel UI
-- ==============================
local SettingsButton = Instance.new("TextButton")
SettingsButton.Parent = ScreenGui
SettingsButton.Size = UDim2.new(0, 40, 0, 40)
SettingsButton.Position = UDim2.new(1, -50, 1, -50)
SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsButton.Text = "⚙️"
SettingsButton.TextScaled = true
SettingsButton.TextColor3 = Color3.fromRGB(255, 230, 50)

local CornerBtn = Instance.new("UICorner")
CornerBtn.CornerRadius = UDim.new(0, 8)
CornerBtn.Parent = SettingsButton

local Panel = Instance.new("Frame")
Panel.Parent = ScreenGui
Panel.Size = UDim2.new(0, 200, 0, 250)
Panel.Position = UDim2.new(1, -220, 1, -310)
Panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Panel.Visible = false

local CornerPanel = Instance.new("UICorner")
CornerPanel.CornerRadius = UDim.new(0, 12)
CornerPanel.Parent = Panel

local UIList = Instance.new("UIListLayout")
UIList.Parent = Panel
UIList.Padding = UDim.new(0, 6)

local function makeToggle(name, var)
    local Toggle = Instance.new("TextButton")
    Toggle.Parent = Panel
    Toggle.Size = UDim2.new(1, -10, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Toggle.Text = name..": "..tostring(getgenv()[var])
    Toggle.TextScaled = true
    Toggle.TextColor3 = Color3.fromRGB(255, 230, 50)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Toggle

    Toggle.MouseButton1Click:Connect(function()
        getgenv()[var] = not getgenv()[var]
        Toggle.Text = name..": "..tostring(getgenv()[var])
        createNotification(name.." set to "..tostring(getgenv()[var]))
    end)
end

-- Create toggles
makeToggle("Auto Place Egg", "autoPlaceEgg")
makeToggle("Farm Eggs", "farmEggs")
makeToggle("Debug Mode", "debug")
makeToggle("Notification Sound", "notifSound")

-- Button toggle
SettingsButton.MouseButton1Click:Connect(function()
    Panel.Visible = not Panel.Visible
end)

-- ==============================
-- Initial Run
-- ==============================
createNotification("✅ ParadEgg " .. getgenv().ParadEgg_Version .. " loaded successfully!")
