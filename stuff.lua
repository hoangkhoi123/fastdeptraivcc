-- Load
if not game:IsLoaded() then
    repeat game.Loaded:Wait() until game:IsLoaded()
end
-- Join Team
if getgenv().Team ~= "Pirates" and getgenv().Team ~= "Marines" then
    getgenv().Team = "Marines"
end
if game:GetService("Players").LocalPlayer.Team == nil then
    local Button = game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container[getgenv().Team].Frame.TextButton
    for i,v in pairs(getconnections(Button.Activated)) do
        v.Function()
    end
end
--Variables
local Request_Places = {}
local Stop_Tween = false
local Tween = nil
-- Functions
local function BuyRandomFruit()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
end
local function CanStoreFruit(fruit)
    local Max_Fruit_Cap = game:GetService("Players").LocalPlayer.Data.FruitCap.Value
    local Fruit_Storage = 0
    for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryFruits")) do
        if v.Name == fruit then
            Fruit_Storage = Fruit_Storage + 1
        end
    end
    if Fruit_Storage < Max_Fruit_Cap then
        return true
    end
    return false
end
local function StoreFruit()
    for a, b in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if string.match(b.Name, "Fruit$") then
            local name = b.Name:match("(%S+)")
            local fruit = name.. "-" ..name
            if CanStoreFruit(fruit) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruit, game:GetService("Players").LocalPlayer.Character:FindFirstChild(b.Name) or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(b.Name))
            end
        end
    end
    for a, b in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if string.match(b.Name, "Fruit$") then
            local name = b.Name:match("(%S+)")
            local fruit = name.. "-" ..name
            if CanStoreFruit(fruit) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruit, game:GetService("Players").LocalPlayer.Character:FindFirstChild(b.Name) or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(b.Name))
            end
        end
    end
end
local function CheckFruit()
    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v:FindFirstChild("Fruit") then
            return true
        end
    end
    return false
end
local function AddVelocity()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Xero") then
        local body = Instance.new("BodyVelocity")
        body.Name = "Xero"
        body.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        body.MaxForce=Vector3.new(1000000000,1000000000,1000000000)
        body.Velocity=Vector3.new(0,0,0)
    end
end
local function RemoveVelocity()
    for _,v in pairs(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):GetChildren()) do
        if v.Name == "Xero" then
            v:Destroy()
        end
    end
end
local function CheckNearestRequestIsland(place)
    local min_distance = math.huge
    local player = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for request_place, cframe in pairs(Request_Places) do
        min_distance = math.min(min_distance, math.abs((place.Position - cframe.Position).Magnitude))
    end
    min_distance = math.min(min_distance, math.abs((place.Position - player.Position).Magnitude))
    for request_place, cframe in pairs(Request_Places) do
        if math.abs((place.Position - cframe.Position).Magnitude) == min_distance then
            return request_place
        end
    end
    return nil
end
local function HopServer(page)
    local placeid = game.PlaceId
    local next_page = ""
    local servers = nil
    if next_page == "" then
        servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeid .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeid .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. next_page))
    end
    next_page = servers.nextPageCursor
    local check = false
    for _, value in pairs(servers.data) do
        if value.maxPlayers > value.playing then
            check = true
            game:GetService("TeleportService"):TeleportToPlaceInstance(placeid, value.id, game:GetService("Players").LocalPlayer)
            task.wait(1)
        end
    end
    if not check and next_page and next_page ~= "" and next_page ~= nil then
        HopServer(next_page)
    elseif not check or not next_page or next_page == "" or next_page == nil then
        HopServer()
    end
end
local function StopTween()
    Stop_Tween = true
    if Tween ~= nil then
        repeat task.wait()
            if Tween.PlaybackState == Enum.PlaybackState.Playing then
                Tween:Cancel()
            end
        until Tween.PlaybackState ~= Enum.PlaybackState.Playing
    end
    RemoveVelocity()
    Stop_Tween = false
end
local function tween(place)
    repeat task.wait()
        if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0 then
            repeat task.wait(1) until game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0
            AddVelocity()
        end
        local request_place = CheckNearestRequestIsland(place)
        if request_place ~= nil then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Request_Places[request_place].Position)
        end
        local player = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true then
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Sit = false
        end
        AddVelocity()
        NoClip()
        local Distance = (place.Position - player.Position).Magnitude
        if Distance <= 100 then
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = place
        else
            local speed = 350
            local TweenService = game:GetService("TweenService")
            local start = player.Position
            local _end = place.Position
            local distance = (start - _end).Magnitude
            local _time = distance/(speed)
            local info = TweenInfo.new(
                _time,
                Enum.EasingStyle.Linear
            )
            Tween = TweenService:Create(player, info, {CFrame = place})
            Tween:Play()
            if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0 then
                repeat task.wait(1) until game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0
                AddVelocity()
            end
        end
        if Stop_Tween then
            break
        end
    until Distance <= 10
    RemoveVelocity()
end
local function BringFruit()
    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v:FindFirstChild("Fruit") then
            tween(v.Handle.CFrame)
            AddVelocity()
        end
    end
end
-- Execute
if game.PlaceId == 2753915549 then
    Request_Places = {
        ["Whirl Pool"] = CFrame.new(3864.6884765625, 6.736950397491455, -1926.214111328125),
        ["Sky Area 1"] = CFrame.new(-4607.82275, 872.54248, -1667.55688),
        ["Sky Area 2"] = CFrame.new(-7894.61767578125, 5547.1416015625, -380.29119873046875),
        ["Fish Man"] = CFrame.new(61163.8515625, 11.6796875, 1819.7841796875)
    }
elseif game.PlaceId == 4442272183 then
    Request_Places = {
        ["Swan's room"] = CFrame.new(2284.912109375, 15.152046203613281, 905.48291015625),
        ["Mansion"] = CFrame.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
        ["Ghost Ship"] = CFrame.new(923.21252441406, 126.9760055542, 32852.83203125),
        ["Ghost Ship Entrance"] = CFrame.new(-6508.5581054688, 89.034996032715, -132.83953857422)
    }
elseif game.PlaceId == 7449423635 then
    Request_Places = {
        ["Castle on the sea"] = CFrame.new(-5075.50927734375, 314.5155029296875, -3150.0224609375),
        ["Mansion"] = CFrame.new(-12548.998046875, 332.40396118164, -7603.1865234375),
        ["Hydra Island"] = CFrame.new(5753.5478515625, 610.7880859375, -282.33172607421875),
        ["Temple Of Time"] = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875),
        ["Beautiful Pirate Entrance"] = CFrame.new(-11993.580078125, 334.7812805175781, -8844.1826171875),
        ["Beautiful Pirate Place"] = CFrame.new(5314.58203125, 25.419387817382812, -125.94227600097656)
    }
end
task.spawn(function()
    while task.wait() do
        BuyRandomFruit()
        StoreFruit()
    end
end)
while task.wait() do
    if CheckFruit() then
        BringFruit()
    else
        StopTween()
        HopServer()
    end
end