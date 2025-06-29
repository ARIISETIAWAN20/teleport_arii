-- ✅ Arii Teleport GUI v2 (Delta Mobile Compatible)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local nameBypass = "supa_loi"
local requiredKey = "OwnerAri"

pcall(function()
    hookfunction(getgenv, function(...) return nil end)
    hookfunction(setreadonly, function(t, b) if b then return end end)
end)

if player.Name ~= nameBypass then
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystem"
    keyGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1, -20, 0, 30)
    box.Position = UDim2.new(0, 10, 0, 10)
    box.PlaceholderText = "Masukkan Key"
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local submit = Instance.new("TextButton", frame)
    submit.Size = UDim2.new(1, -20, 0, 30)
    submit.Position = UDim2.new(0, 10, 0, 50)
    submit.Text = "Submit"
    submit.TextColor3 = Color3.new(1, 1, 1)
    submit.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

    submit.MouseButton1Click:Connect(function()
        if box.Text == requiredKey then
            keyGui:Destroy()
            loadArii()
        else
            box.Text = ""
            box.PlaceholderText = "Key Salah!"
        end
    end)
else
    loadArii()
end

function loadArii()
    if not (writefile and readfile and isfile) then
        getgenv().writefile = function() end
        getgenv().readfile = function() return "{}" end
        getgenv().isfile = function() return false end
    end

    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")
    local filename = "teleport_points.json"
    local teleportPoints = {point1 = nil, point2 = nil}
    local autoTeleport = false
    local delayTime = 8

    local blacklist = {
        ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
        ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
        ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
        ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
        ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
    }

    local function kickIfBlacklisted()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and blacklist[p.Name] then
                StarterGui:SetCore("SendNotification", {
                    Title = "Auto Leave", Text = "Staff terdeteksi!", Duration = 1
                })
                wait(1)
                player:Kick("Staff terdeteksi")
            end
        end
    end
    game.Players.PlayerAdded:Connect(kickIfBlacklisted)
    kickIfBlacklisted()

    StarterGui:SetCore("SendNotification", {
        Title = "Arii GUI", Text = "Proteksi aktif ✔", Duration = 3
    })

    local function loadPoints()
        if isfile(filename) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(filename))
            end)
            if success and type(data) == "table" then
                teleportPoints = data
            end
        end
    end

    local function savePoints()
        pcall(function()
            writefile(filename, HttpService:JSONEncode(teleportPoints))
        end)
    end

    local function getHRP()
        local char = player.Character or player.CharacterAdded:Wait()
        return char:WaitForChild("HumanoidRootPart")
    end

    local function teleportTo(point)
        if point then
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = getHRP()
            hrp.Anchored = true
            hrp.Velocity = Vector3.zero
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
            wait(0.05)
            char:PivotTo(CFrame.new(point.x, point.y + 3, point.z))
            wait(0.05)
            hrp.Anchored = false
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
        end
    end

    -- UI
    local gui = Instance.new("ScreenGui")
    gui.Name = "TeleportGUI"
    gui.Parent = player:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame", gui)
    MainFrame.Size = UDim2.new(0, 145, 0, 180)
    MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local title = Instance.new("TextLabel", MainFrame)
    title.Size = UDim2.new(1, 0, 0, 16)
    title.Text = "Arii"
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 14

    local minimize = Instance.new("TextButton", MainFrame)
    minimize.Size = UDim2.new(0, 14, 0, 14)
    minimize.Position = UDim2.new(1, -14, 0, 0)
    minimize.Text = "-"
    minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
    minimize.TextColor3 = Color3.new(1,1,1)

    local content = Instance.new("Frame", MainFrame)
    content.Size = UDim2.new(1, 0, 1, -16)
    content.Position = UDim2.new(0, 0, 0, 16)
    content.BackgroundTransparency = 1

    local function createBtn(text, y, cb)
        local b = Instance.new("TextButton", content)
        b.Size = UDim2.new(1, -10, 0, 18)
        b.Position = UDim2.new(0, 5, 0, y)
        b.Text = text
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 13
        b.TextColor3 = Color3.new(1,1,1)
        b.BackgroundColor3 = Color3.fromRGB(80,80,160)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    createBtn("🚀 Teleport to Point 1", 5, function() teleportTo(teleportPoints.point1) end)
    createBtn("🚀 Teleport to Point 2", 28, function() teleportTo(teleportPoints.point2) end)
    createBtn("📌 Set Point 1", 51, function()
        local hrp = getHRP()
        teleportPoints.point1 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
        savePoints()
    end)
    createBtn("📌 Set Point 2", 74, function()
        local hrp = getHRP()
        teleportPoints.point2 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
        savePoints()
    end)

    local delayBox = Instance.new("TextBox", content)
    delayBox.Size = UDim2.new(1, -10, 0, 18)
    delayBox.Position = UDim2.new(0, 5, 0, 97)
    delayBox.PlaceholderText = "Delay detik"
    delayBox.Text = tostring(delayTime)
    delayBox.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    delayBox.TextColor3 = Color3.new(1, 1, 1)
    delayBox.ClearTextOnFocus = false
    delayBox.FocusLost:Connect(function()
        local val = tonumber(delayBox.Text)
        if val and val > 0 then delayTime = val end
    end)

    local autoBtn = createBtn("▶️ Start Auto Teleport", 120, function()
        autoTeleport = not autoTeleport
        autoBtn.Text = autoTeleport and "⏹ Stop Auto Teleport" or "▶️ Start Auto Teleport"
    end)

    createBtn("❌ OFF Auto Teleport", 143, function()
        autoTeleport = false
        autoBtn.Text = "▶️ Start Auto Teleport"
    end)

    local credit = Instance.new("TextLabel", MainFrame)
    credit.Size = UDim2.new(1, 0, 0, 14)
    credit.Position = UDim2.new(0, 0, 1, -14)
    credit.Text = "By Ari"
    credit.BackgroundTransparency = 1
    credit.Font = Enum.Font.SourceSansItalic
    credit.TextColor3 = Color3.fromRGB(180, 180, 180)
    credit.TextSize = 11

    spawn(function()
        while true do wait(1)
            if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
                teleportTo(teleportPoints.point1)
                wait(delayTime)
                teleportTo(teleportPoints.point2)
            end
        end
    end)

    pcall(function()
        for _,v in pairs(getconnections(player.Idled)) do v:Disable() end
    end)

    RunService.Stepped:Connect(function()
        local hrp = getHRP()
        if hrp then
            local touching = hrp:GetTouchingParts()
            for _, part in ipairs(touching) do
                if part:IsA("BasePart") and part.CanCollide == false then
                    part.CanCollide = true
                end
            end
            if not hrp.Anchored then
                hrp.Velocity = Vector3.new(0, math.max(hrp.Velocity.Y, -50), 0)
            end
        end
    end)

    loadPoints()

    local minimized = false
    minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        content.Visible = not minimized
        minimize.Text = minimized and "+" or "-"
    end)

    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Physics then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end)
end
