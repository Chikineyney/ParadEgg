-- ParadEgg.lua (fixed: robust player GUI + stacked notifs + working slide + settings panel)

-- ===== Default Settings =====
getgenv().baldTeam = 1
getgenv().koiTeam = 2
getgenv().sealTeam = 3
getgenv().eggPlace = {"Paradise Egg"}
getgenv().petSell  = {"Ostrich","Peacock","Scarlet Macaw","Capybara"}
getgenv().KG = 3
getgenv().Age = 1
getgenv().maxEgg = 8
getgenv().autoPlaceEgg = true
getgenv().farmEggs = true

-- Notif settings
getgenv().notifDuration = 2
getgenv().notifSound = true
getgenv().debug = false

-- ===== Services & Safe Waits =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if not game:IsLoaded() then
    pcall(function() game.Loaded:Wait() end)
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Choose a safe parent for UI (PlayerGui or CoreGui fallback)
local function getGuiParent()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui then return pgui end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:WaitForChild("PlayerGui") -- last resort
end

local UiParent = getGuiParent()

-- ===== ScreenGui =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ParadEggUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = UiParent

-- ===== Notification Holder (bottom-right, stacks upward) =====
local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.AnchorPoint = Vector2.new(1,1)
NotifHolder.Position = UDim2.new(1, -20, 1, -80)
NotifHolder.Size = UDim2.new(0.32, 0, 0.9, 0) -- ~32% width, fits mobile/pc
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent = ScreenGui

local List = Instance.new("UIListLayout")
List.Parent = NotifHolder
List.FillDirection = Enum.FillDirection.Vertical
List.VerticalAlignment = Enum.VerticalAlignment.Bottom
List.HorizontalAlignment = Enum.HorizontalAlignment.Right
List.Padding = UDim.new(0, 6)
List.SortOrder = Enum.SortOrder.LayoutOrder

-- ===== Notification Helper =====
local function createNotification(text)
    -- Outer item controlled by UIListLayout (don't tween this)
    local Item = Instance.new("Frame")
    Item.Name = "NotifItem"
    Item.Size = UDim2.new(1, 0, 0, 44)
    Item.BackgroundTransparency = 1
    Item.BorderSizePixel = 0
    Item.Parent = NotifHolder

    -- Inner content we tween (slide/fade)
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Item
    Content.AnchorPoint = Vector2.new(1, 0.5)
    Content.Position = UDim2.new(1, 320, 0.5, 0) -- start off-screen to the right
    Content.Size = UDim2.new(1, -10, 1, 0)
    Content.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Content.BackgroundTransparency = 0.1
    Content.BorderSizePixel = 0
    Content.ZIndex = 10

    local Corner = Instance.new("UICorner", Content)
    Corner.CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Content)
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(200, 200, 0)
    Stroke.Transparency = 0.2

    local Label = Instance.new("TextLabel")
    Label.Parent = Content
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Font = Enum.Font.SourceSansSemibold -- very safe font
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = Color3.fromRGB(255, 230, 50)
    Label.Text = text

    -- Optional sound
    if getgenv().notifSound then
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://5419097925"
        s.Volume = 1.6
        s.Parent = Content
        pcall(function() s:Play() end)
        game:GetService("Debris"):AddItem(s, 3)
    end

    -- Slide in
    TweenService:Create(
        Content,
        TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Position = UDim2.new(1, 0, 0.5, 0) }
    ):Play()

    -- Stay then slide/fade out
    task.delay(tonumber(getgenv().notifDuration) or 2, function()
        local t1 = TweenService:Create(
            Content,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            { Position = UDim2.new(1, 320, 0.5, 0), BackgroundTransparency = 1 }
        )
        t1:Play()
        task.wait(0.38)
        Item:Destroy()
    end)
end

-- ===== Settings Panel (with simple toggles) =====
local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "ParadEggSettingsBtn"
SettingsButton.Parent = ScreenGui
SettingsButton.Size = UDim2.new(0, 42, 0, 42)
SettingsButton.Position = UDim2.new(1, -54, 1, -54)
SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsButton.Text = "⚙"
SettingsButton.TextScaled = true
SettingsButton.TextColor3 = Color3.fromRGB(255, 230, 50)
SettingsButton.AutoButtonColor = true
local BtnCorner = Instance.new("UICorner", SettingsButton)
BtnCorner.CornerRadius = UDim.new(0, 8)

local Panel = Instance.new("Frame")
Panel.Name = "ParadEggPanel"
Panel.Parent = ScreenGui
Panel.Size = UDim2.new(0, 220, 0, 220)
Panel.Position = UDim2.new(1, -240, 1, -280)
Panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Panel.Visible = false
Panel.Active = true
Panel.Draggable = true
local PanelCorner = Instance.new("UICorner", Panel)
PanelCorner.CornerRadius = UDim.new(0, 12)

local Padding = Instance.new("UIPadding", Panel)
Padding.PaddingTop = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 8)
Padding.PaddingRight = UDim.new(0, 8)
Padding.PaddingBottom = UDim.new(0, 8)

local List2 = Instance.new("UIListLayout", Panel)
List2.Padding = UDim.new(0, 6)
List2.FillDirection = Enum.FillDirection.Vertical
List2.SortOrder = Enum.SortOrder.LayoutOrder

local Title = Instance.new("TextLabel")
Title.Parent = Panel
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255, 230, 50)
Title.Text = "ParadEgg Settings"

local function makeToggle(display, key)
    local b = Instance.new("TextButton")
    b.Parent = Panel
    b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.AutoButtonColor = true
    b.Text = display..": "..tostring(getgenv()[key])
    b.TextScaled = true
    b.TextColor3 = Color3.fromRGB(255, 230, 50)
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)

    b.MouseButton1Click:Connect(function()
        getgenv()[key] = not getgenv()[key]
        b.Text = display..": "..tostring(getgenv()[key])
        createNotification(display.." = "..tostring(getgenv()[key]))
    end)
end

makeToggle("Auto Place Egg", "autoPlaceEgg")
makeToggle("Farm Eggs",     "farmEggs")
makeToggle("Debug Mode",    "debug")
makeToggle("Notif Sound",   "notifSound")

SettingsButton.MouseButton1Click:Connect(function()
    Panel.Visible = not Panel.Visible
end)

-- ===== Initial Notification =====
createNotification("✅ Script loaded successfully!")

-- ===== Optional demo events (debug) =====
if getgenv().debug then
    task.delay(1, function() createNotification("🟦 Switched to Bald Team") end)
    task.delay(2, function() createNotification("🥚 Placed "..(getgenv().eggPlace[1] or "Egg")) end)
    task.delay(3, function() createNotification("❌ Sold Peacock") end)
end
