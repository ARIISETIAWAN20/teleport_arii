-- ✅ Teleport GUI "Arii" - Final Fixed (Delta Safe, Proteksi Lengkap, UI Rapi, Auto Save)

-- Proteksi Fungsi File (Delta Friendly)
pcall(function()
    if not (writefile and readfile and isfile) then
        getgenv().writefile = nil
        getgenv().readfile = function() return "{}" end
        getgenv().isfile = function() return false end
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil, speed1 = 1.5, speed2 = 1.5}
local autoTeleport = false
local delayTime = 8

-- Blacklist Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true, ["legendxlenn"] = true,
    ["VicSimon8"] = true, ["Woodrowlvan_8"] = true, ["Chase02771"] = true, ["Crystalst1402"] = true,
    ["CoryOdom_8"] = true, ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

local function deepScan()
    for _, plr in pairs(Players:GetPlayers()) do
        if blacklist[plr.Name] then
            player:Kick("Staff terdeteksi")
        end
    end
end
deepScan()

Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    if blacklist[p.Name] then
        pcall(function()
            StarterGui:SetCore("SendNotification", {Title = "Auto Leave", Text = "Staff Terdeteksi", Duration = 1})
        end)
        task.wait(1)
        player:Kick("Staff terdeteksi")
    end
end)

-- Proteksi HWID & Username
pcall(function()
    local allowedHWID = "HWID_ARI_123"
    local allowedUsers = { ["supa_loi"] = true, ["Devrenzx"] = true }

    local function getHWID()
        local id = "UNKNOWN"
        pcall(function() id = tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)
        return id
    end

    if not allowedUsers[player.Name] and getHWID() ~= allowedHWID then
        player:Kick("Perangkat tidak diizinkan (HWID Lock)")
    end
end)

-- Anti Logging (Delta Safe)
pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            if tostring(self):lower():find("log") or tostring(self):lower():find("report") then
                return nil
            end
            return old(self, ...)
        end)
    end
end)

-- Auto Save & Load
local function loadPoints()
    if isfile and isfile(filename) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filename))
        end)
        if success and type(data) == "table" then
            teleportPoints = data
        end
    end
    teleportPoints.speed1 = teleportPoints.speed1 or 1.5
    teleportPoints.speed2 = teleportPoints.speed2 or 1.5
end

local function savePoints()
    if writefile then
        pcall(function()
            writefile(filename, HttpService:JSONEncode(teleportPoints))
        end)
    end
end

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
end

local function effectFlash()
    local flash = Instance.new("Part")
    flash.Anchored = true
    flash.CanCollide = false
    flash.Size = Vector3.new(5, 5, 5)
    flash.Shape = Enum.PartType.Ball
    flash.Material = Enum.Material.Neon
    flash.BrickColor = BrickColor.new("Electric blue")
    flash.CFrame = getHRP().CFrame
    flash.Parent = workspace
    game:GetService("Debris"):AddItem(flash, 0.5)
end

local function teleportTo(point)
    if point then
        effectFlash()
        local hrp = getHRP()
        local destination = Vector3.new(point.x, point.y + 3, point.z)
        hrp.Anchored = true
        hrp.CFrame = CFrame.new(destination)
        hrp.Velocity = Vector3.zero
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
        task.wait(0.2)
        hrp.Anchored = false
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
    end
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
ScreenGui.ResetOnSpawn = false

local function safeParent(gui)
    local parent = nil
    pcall(function() parent = game:GetService("CoreGui") end)
    if not parent or parent == nil then
        parent = player:WaitForChild("PlayerGui")
    end
    pcall(function() gui.Parent = parent end)
end
safeParent(ScreenGui)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 170, 0, 250)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 20)
title.Text = "🚀 Arii Teleport GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Position = UDim2.new(0, 0, 0, 0)
title.Parent = MainFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 16, 0, 16)
minimizeButton.Position = UDim2.new(1, -18, 0, 2)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 12
minimizeButton.Parent = MainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -22)
contentFrame.Position = UDim2.new(0, 0, 0, 22)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 5)
padding.PaddingBottom = UDim.new(0, 5)
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)
padding.Parent = contentFrame

local function createButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 22)
    b.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Text = text
    b.Parent = contentFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function createSlider(titleText, defaultVal, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Text = titleText
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Parent = contentFrame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 20)
    box.Text = tostring(defaultVal)
    box.ClearTextOnFocus = false
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.Parent = contentFrame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    box.FocusLost:Connect(function()
        task.wait(0.1)
        local val = tonumber(box.Text)
        if val and val > 0 and val <= 10 then
            callback(val)
            savePoints()
        else
            box.Text = tostring(defaultVal)
        end
    end)
end

createButton("🚀 Teleport to Point 1", function() teleportTo(teleportPoints.point1) end)
createButton("🚀 Teleport to Point 2", function() teleportTo(teleportPoints.point2) end)
createButton("📌 Set Point 1", function()
    local hrp = getHRP()
    teleportPoints.point1 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)
createButton("📌 Set Point 2", function()
    local hrp = getHRP()
    teleportPoints.point2 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)

createSlider("⏩ Delay Speed Point 1 (1-10)", teleportPoints.speed1, function(v) teleportPoints.speed1 = v end)
createSlider("⏩ Delay Speed Point 2 (1-10)", teleportPoints.speed2, function(v) teleportPoints.speed2 = v end)

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(1, 0, 0, 20)
delayBox.Text = tostring(delayTime)
delayBox.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 12
delayBox.ClearTextOnFocus = false
delayBox.Parent = contentFrame
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 6)

delayBox.FocusLost:Connect(function()
    task.wait(0.1)
    local val = tonumber(delayBox.Text)
    if val and val > 0 then delayTime = val end
end)

local autoBtn = createButton("▶️ Start Auto Teleport", function()
    autoTeleport = not autoTeleport
    autoBtn.Text = autoTeleport and "⏹ Stop Auto Teleport" or "▶️ Start Auto Teleport"
end)

createButton("❌ OFF Auto Teleport", function()
    autoTeleport = false
    autoBtn.Text = "▶️ Start Auto Teleport"
end)

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 14)
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.Font = Enum.Font.GothamSemibold
credit.TextSize = 11
credit.Text = "By Ari"
credit.Parent = MainFrame

minimizeButton.MouseButton1Click:Connect(function()
    contentFrame.Visible = not contentFrame.Visible
    minimizeButton.Text = contentFrame.Visible and "-" or "+"
end)

-- Auto Teleport Loop
spawn(function()
    while task.wait(1) do
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            wait(teleportPoints.speed1 or 1.5)
            teleportTo(teleportPoints.point2)
            wait(teleportPoints.speed2 or 1.5)
        end
    end
end)

-- Anti Idle
for _, v in pairs(getconnections(player.Idled)) do v:Disable() end

-- Auto Save From Fall
RunService.Stepped:Connect(function()
    local hrp = getHRP()
    if hrp and not hrp.Anchored and hrp.Position.Y < -100 then
        teleportTo(teleportPoints.point1 or Vector3.new(0, 50, 0))
    end
end)

loadPoints()
print("✅ Arii Teleport GUI Loaded")