-- Config Values
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


local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleLoaderUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 280, 0, 150)
Frame.Position = UDim2.new(0.5, -140, 0.2, 0) 
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.1

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "✅ Script Loaded"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.BackgroundTransparency = 1

local Info = Instance.new("TextLabel")
Info.Parent = Frame
Info.Size = UDim2.new(1, -20, 1, -50)
Info.Position = UDim2.new(0, 10, 0, 45)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Text = 
    "• Max Egg: " .. tostring(getgenv().maxEgg) ..
    "\n• Auto Place: " .. tostring(getgenv().autoPlaceEgg) ..
    "\n• Farm Eggs: " .. tostring(getgenv().farmEggs) ..
    "\n• Sell Pets: " .. table.concat(getgenv().petSell, ", ")
Info.TextColor3 = Color3.fromRGB(255, 255, 255)
Info.Font = Enum.Font.SourceSans
Info.TextSize = 18
Info.BackgroundTransparency = 1
Info.TextWrapped = true


task.spawn(function()
    wait(3)
    Frame:TweenPosition(UDim2.new(0.5, -140, -0.5, 0), "Out", "Quad", 1, true)
    wait(1)
    ScreenGui:Destroy()
end)
