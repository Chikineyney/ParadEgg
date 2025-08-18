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

local Players = game:GetService("Players")
local StarterGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SettingsLabel = Instance.new("TextLabel")


ScreenGui.Parent = StarterGui
ScreenGui.ResetOnSpawn = false


Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 240, 0, 90)
Frame.Position = UDim2.new(1, -260, 0.8, 0) -- bottom-right
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- dark gray
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.2
Frame.ClipsDescendants = true


Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Text = "✅ Run Successfully"
Title.TextColor3 = Color3.fromRGB(255, 215, 0) -- yellow
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18


SettingsLabel.Parent = Frame
SettingsLabel.Position = UDim2.new(0, 0, 0.35, 0)
SettingsLabel.Size = UDim2.new(1, 0, 0.65, 0)
SettingsLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
SettingsLabel.BackgroundTransparency = 1
SettingsLabel.Font = Enum.Font.SourceSans
SettingsLabel.TextSize = 16
SettingsLabel.TextWrapped = true
SettingsLabel.Text = string.format(
    "MaxEgg: %s\nAutoPlaceEgg: %s\nFarmEggs: %s",
    tostring(getgenv().maxEgg),
    tostring(getgenv().autoPlaceEgg),
    tostring(getgenv().farmEggs)
)

task.spawn(function()
    wait(4)
    for i = 0, 1, 0.05 do
        Frame.BackgroundTransparency = i
        Title.TextTransparency = i
        SettingsLabel.TextTransparency = i
        wait(0.05)
    end
    ScreenGui:Destroy()
end)
