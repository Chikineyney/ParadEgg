--[[  ParadEgg.lua
      Robust UI + Settings + Version + Save (executor-friendly)
--]]

-- ===== Version =====
getgenv().ParadEgg_Version = "v1.3"

-- ===== Default Settings (will be overridden by saved file if present) =====
local DEFAULTS = {
    baldTeam = 1,
    koiTeam = 2,
    sealTeam = 3,
    eggPlace = {"Paradise Egg"},
    petSell  = {"Ostrich","Peacock","Scarlet Macaw","Capybara"},
    KG = 3,
    Age = 1,
    maxEgg = 8,
    autoPlaceEgg = true,
    farmEggs = true,
    notifDuration = 2,
    notifSound = true,
    debug = false,
}
local SAVE_FILE = "ParadEgg_Settings.json"

-- ===== Services / Safe Waits =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

if not game:IsLoaded() then pcall(function() game.Loaded:Wait() end) end
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- ===== Save/Load Helpers (only if executor supports it) =====
local CAN_FS = (typeof(isfile)=="function" and typeof(readfile)=="function" and typeof(writefile)=="function")
local function loadSettings()
    local data = {}
    for k,v in pairs(DEFAULTS) do data[k]=v end
    if CAN_FS and isfile(SAVE_FILE) then
        local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(SAVE_FILE)) end)
        if ok and typeof(decoded)=="table" then
            for k,v in pairs(decoded) do data[k]=v end
        end
    end
    for k,v in pairs(data) do getgenv()[k]=v end
end
local function saveSettings()
    if not CAN_FS then return end
    local snap = {}
    for k,_ in pairs(DEFAULTS) do snap[k]=getgenv()[k] end
    local ok, json = pcall(function() return HttpService:JSONEncode(snap) end)
    if ok then writefile(SAVE_FILE, json) end
end
loadSettings()

-- ===== Safe UI Parent (PlayerGui → CoreGui → gethui/syn.protect_gui) =====
local function getUiParent()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui then return pgui end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    if gethui then
        local ok2, ui = pcall(gethui)
        if ok2 and ui then return ui end
    end
    if syn and syn.protect_gui then
        local ok3, core2 = pcall(function() return game:GetService("CoreGui") end)
        if ok3 and core2 then
            local g = Instance.new("ScreenGui")
            g.Name="ParadEgg_Protected"
            syn.protect_gui(g)
            g.Parent = core2
            return g
        end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local UiParent = getUiParent()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ParadEggUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = (UiParent:IsA("ScreenGui") and UiParent) or UiParent

-- ===== Toasts (stacked, bottom-right, slide in/out) =====
local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.AnchorPoint = Vector2.new(1,1)
NotifHolder.Position = UDim2.new(1, -20, 1, -80)
NotifHolder.Size = UDim2.new(0.34, 0, 0.9, 0) -- responsive on mobile/pc
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent = ScreenGui

local List = Instance.new("UIListLayout")
List.Parent = NotifHolder
List.FillDirection = Enum.FillDirection.Vertical
List.VerticalAlignment = Enum.VerticalAlignment.Bottom
List.HorizontalAlignment = Enum.HorizontalAlignment.Right
List.Padding = UDim.new(0, 6)
List.SortOrder = Enum.SortOrder.LayoutOrder

local function createNotification(message)
    local Item = Instance.new("Frame")
    Item.Name = "Toast"
    Item.Size = UDim2.new(1, 0, 0, 44)
    Item.BackgroundTransparency = 1
    Item.Parent = NotifHolder

    local Card = Instance.new("Frame")
    Card.Name = "Card"
    Card.Parent = Item
    Card.AnchorPoint = Vector2.new(1,0.5)
    Card.Position = UDim2.new(1, 260, 0.5, 0) -- off-screen start
    Card.Size = UDim2.new(1, -10, 1, 0)
    Card.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Card.BackgroundTransparency = 0.1
    Card.BorderSizePixel = 0

    local Corner = Instance.new("UICorner", Card)
    Corner.CornerRadius = UDim.new(0, 8)

    -- UIStroke can be blocked by some executors; wrap in pcall
    pcall(function()
        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Thickness = 2
        Stroke.Color = Color3.fromRGB(200, 200, 0)
        Stroke.Transparency = 0.2
    end)

    local Label = Instance.new("TextLabel")
    Label.Parent = Card
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Font = Enum.Font.SourceSansSemibold
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = Color3.fromRGB(255, 230, 50)
    Label.Text = message

    -- optional sound
    if getgenv().notifSound then
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://5419097925"
            s.Volume = 1.4
            s.Parent = Card
            s:Play()
            game:GetService("Debris"):AddItem(s, 3)
        end)
    end

    TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Position = UDim2.new(1, 0, 0.5, 0) }
    ):Play()

    task.delay(tonumber(getgenv().notifDuration) or 2, function()
        TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            { Position = UDim2.new(1, 260, 0.5, 0), BackgroundTransparency = 1 }
        ):Play()
        task.wait(0.38)
        Item:Destroy()
    end)
end

-- ===== Settings Panel (draggable, with toggles) =====
local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging, startPos, startInputPos

    local function begin(input)
        dragging = true
        startPos = frame.Position
        startInputPos = input.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end

    local function update(input)
        if not dragging then return end
        local delta = input.Position - startInputPos
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            begin(input)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            update(input)
        end
    end)
end

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Name = "ParadEggSettingsBtn"
SettingsBtn.Parent = ScreenGui
SettingsBtn.Size = UDim2.new(0, 42, 0, 42)
SettingsBtn.Position = UDim2.new(1, -54, 1, -54)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsBtn.Text = "⚙"
SettingsBtn.TextScaled = true
SettingsBtn.TextColor3 = Color3.fromRGB(255, 230, 50)
SettingsBtn.AutoButtonColor = true
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 8)

local Panel = Instance.new("Frame")
Panel.Name = "ParadEggPanel"
Panel.Parent = ScreenGui
Panel.Size = UDim2.new(0, 230, 0, 240)
Panel.Position = UDim2.new(1, -250, 1, -300)
Panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Panel.Visible = false
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 12)
makeDraggable(Panel)

local Pad = Instance.new("UIPadding", Panel)
Pad.PaddingTop = UDim.new(0, 8); Pad.PaddingLeft = UDim.new(0, 8)
Pad.PaddingRight = UDim.new(0, 8); Pad.PaddingBottom = UDim.new(0, 8)

local Stack = Instance.new("UIListLayout", Panel)
Stack.Padding = UDim.new(0, 6)
Stack.FillDirection = Enum.FillDirection.Vertical
Stack.SortOrder = Enum.SortOrder.LayoutOrder

local Title = Instance.new("TextLabel")
Title.Parent = Panel
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255, 230, 50)
Title.Text = "ParadEgg "..tostring(getgenv().ParadEgg_Version)

local function makeToggle(label, key)
    local b = Instance.new("TextButton")
    b.Parent = Panel
    b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.AutoButtonColor = true
    b.TextScaled = true
    b.Font = Enum.Font.SourceSansSemibold
    b.TextColor3 = Color3.fromRGB(255, 230, 50)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    local function refresh() b.Text = string.format("%s: %s", label, tostring(getgenv()[key])) end
    refresh()

    b.MouseButton1Click:Connect(function()
        getgenv()[key] = not getgenv()[key]
        saveSettings()
        refresh()
        createNotification(label.." = "..tostring(getgenv()[key]))
    end)
end

makeToggle("Auto Place Egg", "autoPlaceEgg")
makeToggle("Farm Eggs",     "farmEggs")
makeToggle("Debug Mode",    "debug")
makeToggle("Notif Sound",   "notifSound")

SettingsBtn.MouseButton1Click:Connect(function()
    Panel.Visible = not Panel.Visible
end)

-- ===== Initial Toast =====
createNotification("✅ ParadEgg "..tostring(getgenv().ParadEgg_Version).." loaded!")

-- ===== Optional demo notifs so you can confirm it runs =====
if getgenv().debug then
    task.delay(1, function() createNotification("🟦 Switched to Bald Team") end)
    task.delay(2, function() createNotification("🥚 Placed "..(getgenv().eggPlace[1] or "Egg")) end)
    task.delay(3, function() createNotification("❌ Sold Peacock") end)
end
