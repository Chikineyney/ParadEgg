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

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Text = "✅ ParadEgg Script Loaded!"
TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 20
