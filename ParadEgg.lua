

-- Config Values
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

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Notification container (bottom-right corner)
local NotifGui = Instance.new("ScreenGui")
NotifGui.Parent = PlayerGui
NotifGui.IgnoreGuiInset = true
NotifGui.ResetOnSpawn = false
NotifGui.Name = "ParadEggNotifGui"

local NotifContainer = Instance.new("Frame")
NotifContainer.Parent = NotifGui
NotifContainer.AnchorPoint = Vector2.new(1, 1)
NotifContainer.Position = UDim2.new(1, -20, 1, -20) -- bottom-right corner
NotifContainer.Size = UDim2.new(0.3, 0, 1, -40)
NotifContainer.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = NotifContainer
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.Padding = UDim.new(0, 5)

-- ✅ Notification function
local function createNotification(message, color)
    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")

    Frame.Parent = NotifContainer
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderSizePixel = 0
    Frame.BackgroundTransparency = 0.2
    Frame.ZIndex = 10
    Frame.AutomaticSize = Enum.AutomaticSize.Y

    -- Rounded corners
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 8)

    -- Text
    TextLabel.Parent = Frame
    TextLabel.Size = UDim2.new(1, -10, 1, 0)
    TextLabel.Position = UDim2.new(0, 5, 0, 0)
    TextLabel.Text = message
    TextLabel.TextColor3 = color or Color3.fromRGB(255, 215, 0) -- default yellow
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextScaled = true
    TextLabel.ZIndex = 11
    TextLabel.TextWrapped = true

    -- ✅ Play sound
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://5631260170" -- notification ping
    Sound.Volume = 0.5
    Sound.Parent = Frame
    Sound:Play()

    -- Remove sound after playing
    Sound.Ended:Connect(function()
        Sound:Destroy()
    end)

    -- Show then fade out
    task.spawn(function()
        wait(2)
        for i = 0, 1, 0.05 do
            Frame.BackgroundTransparency = 0.2 + i
            TextLabel.TextTransparency = i
            wait(0.05)
        end
        Frame:Destroy()
    end)
end

-- ✅ Run notification
createNotification("✅ Run Successfully\nMaxEgg: " .. tostring(getgenv().maxEgg) ..
                   " | Auto: " .. tostring(getgenv().autoPlaceEgg) ..
                   " | Farm: " .. tostring(getgenv().farmEggs),
                   Color3.fromRGB(255, 215, 0))

-- ✅ Example usage:
-- createNotification("Switched to Bald Team", Color3.fromRGB(0, 170, 255))
-- createNotification("Equipped Ostrich", Color3.fromRGB(0, 255, 127))
-- createNotification("Sold Peacock", Color3.fromRGB(255, 99, 71))
