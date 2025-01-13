repeat wait() until game:IsLoaded()
ChooseTeam = "Pirate"
repeat wait() until game.Players.LocalPlayer and game:IsLoaded()
if game.PlaceId == 4442272183 then
local success, errorMessage = pcall(function()
    repeat wait()
    if game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"]:FindFirstChild("ChooseTeam") then
        print(1)
        local v99 = game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"].ChooseTeam
        local v52 = v99.Container.Pirates.Frame.TextButton
        local v123 = v99.Container.Marines.Frame.TextButton

        if string.find(ChooseTeam, "Pirate") then
            for _, connection in pairs(getconnections(v52.Activated)) do
                connection.Function()
            end
        elseif string.find(ChooseTeam, "Marine") then
            for _, connection in pairs(getconnections(v123.Activated)) do
                connection.Function()
            end
        else
            for _, connection in pairs(getconnections(v52.Activated)) do
                connection.Function()
            end
        end
    end
until  game:IsLoaded()
end)
end
wait(2)
local tuoidz = game.Players.LocalPlayer
function acacaca()
local args = {
    			[1] = "Cousin",
    			[2] = "Buy"
		}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
end
function tuoivippro()
    for _,v in pairs(tuoidz.Backpack:GetDescendants()) do
    if v:IsA("RemoteFunction") and v.Name == "EatRemote" then
        tuoidz.Character.Humanoid:EquipTool(v.Parent)
    end
    end
end
function tuoised()
for _,v in pairs(tuoidz.Character:GetDescendants()) do
    if v:IsA("Tool") then
        v.Parent = game.workspace    
    end
end
end
function checkngu()
    for _,v in pairs(tuoidz.Character:GetChildren()) do
        if v:IsA("Tool") then
        for k,p in pairs(v:GetChildren()) do
            if p.Name == "ClientEatScript" then
                return true
            end
        end
        end
    end
    return false

end
checktuoi = Vector3.new(-361,73,435)
while wait(2) do
pcall(function()
if game.PlaceId == 4442272183 then
    if (checktuoi - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
        acacaca()
        tuoivippro()
        if checkngu() then
            tuoised()
        else
            tuoivippro()
        end
    else
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
        repeat
        local destination = CFrame.new(-361, 73, 435)
        game.workspace.SetPrimaryPartCFrame(game.Players.LocalPlayer.Character,destination)
        wait()
        until (checktuoi - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 and game.Players.LocalPlayer.Character.Humanoid.Health > 0
    end
else
    print(1)
    local args = {
    			[1] = "TravelDressrosa"
		}

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
end 
end)
end
