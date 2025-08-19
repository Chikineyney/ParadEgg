-- ✅ Config
getgenv().koiTeam = 2
getgenv().sealTeam = 3
getgenv().baldTeam = 1
getgenv().eggPlace = {"Paradise Egg"}
getgenv().petSell = {"Ostrich", "Peacock", "Scarlet Macaw", "Capybara"}
getgenv().KG = 3
getgenv().Age = 1
getgenv().maxEgg = 8
getgenv().autoPlaceEgg = true
getgenv().farmEggs = true

-- ✅ Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ✅ UI Setup
local NotifGui = Instance.new("ScreenGui")
NotifGui.Parent = PlayerGui
NotifGui.IgnoreGuiInset = true
NotifGui.ResetOnSpawn = false
NotifGui.Name = "ParadEggNotifGui"

local NotifContainer = Instance.new("Frame")
NotifContainer.Parent = NotifGui
NotifContainer.AnchorPoint = Vector2.new(1, 1)
NotifContainer.Position = UDim2.new(1, -20, 1, -20) -- bottom-right
NotifContainer.Size = UDim2.new(0.3, 0, 1, -40)
NotifContainer.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = NotifContainer
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.Padding = UDim.new(0, 5)

-- ✅ Notification Function
local function createNotification(message)
    local Frame = Instance.new("Frame")
    Frame.Parent = NotifContainer
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 0
    Frame.BackgroundTransparency = 0.2
    Frame.AutomaticSize = Enum.AutomaticSize.Y

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 6)

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Frame
    TextLabel.Size = UDim2.new(1, -10, 1, 0)
    TextLabel.Position = UDim2.new(0, 5, 0, 0)
    TextLabel.Text = message
    TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextScaled = true
    TextLabel.TextWrapped = true

    -- Fade in
    TextLabel.TextTransparency = 1
    Frame.BackgroundTransparency = 1
    for i = 1, 0, -0.1 do
        TextLabel.TextTransparency = i
        Frame.BackgroundTransparency = 0.5 * i
        task.wait(0.05)
    end

    -- Auto fade out
    task.delay(3, function()
        for i = 0, 1, 0.1 do
            TextLabel.TextTransparency = i
            Frame.BackgroundTransparency = 0.2 + i * 0.8
            task.wait(0.05)
        end
        Frame:Destroy()
    end)
end

-- ✅ Sell Notification
local function SellPet(petName)
    createNotification("🐾 Sold " .. petName .. " (" .. tostring(getgenv().KG) .. " KG)")
end

-- ✅ Team Switch Notification
local function SwitchTeam(teamName, teamId)
    -- 🔹 Replace with actual Remote when you know it
    -- game.ReplicatedStorage.Remotes.SwitchTeam:FireServer(teamId)
    createNotification("🔄 Switched to " .. teamName .. " Team")
end

-- ✅ Egg Placement Notification
local function PlaceEgg(eggName)
    -- 🔹 Replace with actual Remote when you know it
    -- game.ReplicatedStorage.Remotes.PlaceEgg:FireServer(eggName)
    createNotification("🥚 Placed " .. eggName)
end

-- ✅ Farm Eggs Loop
task.spawn(function()
    while getgenv().farmEggs do
        task.wait(2) -- adjust speed if needed

        -- Auto sell pets
        for _, pet in ipairs(getgenv().petSell) do
            SellPet(pet)
        end

        -- Auto place eggs
        if getgenv().autoPlaceEgg then
            for _, egg in ipairs(getgenv().eggPlace) do
                PlaceEgg(egg)
            end
        end
    end
end)

-- ✅ Example Team Switching (test only)
task.delay(5, function() SwitchTeam("Bald", getgenv().baldTeam) end)
task.delay(8, function() SwitchTeam("Koi", getgenv().koiTeam) end)
task.delay(11, function() SwitchTeam("Seal", getgenv().sealTeam) end)

-- ✅ First Run Notify
createNotification("✅ Script Loaded | MaxEgg: " .. tostring(getgenv().maxEgg))
