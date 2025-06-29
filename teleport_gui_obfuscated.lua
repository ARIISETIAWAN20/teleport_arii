-- ✅ Teleport GUI "Arii" 
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
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8

-- Blacklist Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
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
    wait(1)
    if blacklist[p.Name] then
        StarterGui:SetCore("SendNotification", {Title = "Auto Leave", Text = "Staff Terdeteksi", Duration = 1})
        wait(1)
        player:Kick("Staff terdeteksi")
    end
end)

-- HWID Lock
pcall(function()
    local allowedHWID = "HWID_ARI_123"
    local allowedUsers = {["supa_loi"] = true, ["Devrenzx"] = true}
    local function getHWID()
        local id = "UNKNOWN"
        pcall(function()
            id = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        end)
        return id
    end
    if not allowedUsers[player.Name] and getHWID() ~= allowedHWID then
        player:Kick("Perangkat tidak diizinkan (HWID Lock)")
    end
end)

-- Anti Remote Log/Report
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if tostring(self):lower():find("log") or tostring(self):lower():find("report") then
            return nil
        end
        return old(self, ...)
    end)
end)

-- Load/Save Points
local function loadPoints()
    if isfile and isfile(filename) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filename))
        end)
        if success and type(data) == "table" then
            teleportPoints = data
        end
    end
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

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 145, 0, 180)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 16)
title.Text = "Arii"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = MainFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 14, 0, 14)
minimizeButton.Position = UDim2.new(1, -14, 0, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeButton.Parent = MainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -16)
contentFrame.Position = UDim2.new(0, 0, 0, 16)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = MainFrame

local function createButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 18)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.Text = text
    b.Parent = contentFrame
    b.MouseButton1Click:Connect(callback)
    return b
end

createButton("🚀 Teleport to Point 1", 5, function() teleportTo(teleportPoints.point1) end)
createButton("🚀 Teleport to Point 2", 28, function() teleportTo(teleportPoints.point2) end)
createButton("📌 Set Point 1", 51, function()
    local hrp = getHRP()
    teleportPoints.point1 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)
createButton("📌 Set Point 2", 74, function()
    local hrp = getHRP()
    teleportPoints.point2 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(1, -10, 0, 18)
delayBox.Position = UDim2.new(0, 5, 0, 97)
delayBox.PlaceholderText = "Delay detik"
delayBox.Text = tostring(delayTime)
delayBox.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.BorderSizePixel = 0
delayBox.ClearTextOnFocus = false
delayBox.Parent = contentFrame
delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val and val > 0 then delayTime = val end
end)

local autoBtn = createButton("▶️ Start Auto Teleport", 120, function()
    autoTeleport = not autoTeleport
    autoBtn.Text = autoTeleport and "⏹ Stop Auto Teleport" or "▶️ Start Auto Teleport"
end)

createButton("❌ OFF Auto Teleport", 143, function()
    autoTeleport = false
    autoBtn.Text = "▶️ Start Auto Teleport"
end)

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 14)
credit.Position = UDim2.new(0, 0, 1, -14)
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.Font = Enum.Font.SourceSansItalic
credit.TextSize = 11
credit.Text = "By Ari"
credit.Parent = MainFrame

minimizeButton.MouseButton1Click:Connect(function()
    contentFrame.Visible = not contentFrame.Visible
    minimizeButton.Text = contentFrame.Visible and "-" or "+"
end)

-- Auto Teleport
spawn(function()
    while task.wait(1) do
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            wait(delayTime)
            teleportTo(teleportPoints.point2)
        end
    end
end)

-- Anti Idle
for _,v in pairs(getconnections(player.Idled)) do v:Disable() end

-- Anti Clip (Jatuh)
RunService.Stepped:Connect(function()
    local hrp = getHRP()
    if hrp and not hrp.Anchored then
        if hrp.Position.Y < -100 then
            teleportTo(teleportPoints.point1 or Vector3.new(0, 50, 0))
        end
    end
end)

-- Load Point
loadPoints()
