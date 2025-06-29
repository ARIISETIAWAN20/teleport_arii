-- ✅ Teleport GUI "Arii" FINAL - Aman Delta + HWID Lock + GUI Mobile

-- Proteksi Fungsi File (untuk Executor HP/Delta)
if not (writefile and readfile and isfile) then
    getgenv().writefile = function() end
    getgenv().readfile = function() return "{}" end
    getgenv().isfile = function() return false end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8

-- 🛡️ Blacklist Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

-- Deep Scan Staff
local function deepScan()
    for _, plr in pairs(Players:GetPlayers()) do
        if blacklist[plr.Name:lower()] then
            player:Kick("Staff / Moderator terdeteksi.")
        end
    end
end
deepScan()
Players.PlayerAdded:Connect(function(p)
    if blacklist[p.Name] then
        wait(2)
        player:Kick("Staff terdeteksi")
    end
    wait(1)
    deepScan()
end)

-- Proteksi Anti Remote
pcall(function()
    for _,v in pairs(getnilinstances()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            v:Destroy()
        end
    end
end)

-- HWID Lock + Nama Aman
pcall(function()
    local allowedHWID = "HWID_ARI_123" -- Ganti sesuai perangkat kamu
    local allowedUsers = {["supa_loi"] = true, ["Devrenzx"] = true}
    local function getHWID()
        return tostring(game:GetService("RbxAnalyticsService"):GetClientId())
    end
    if not allowedUsers[player.Name] and getHWID() ~= allowedHWID then
        player:Kick("Perangkat tidak diizinkan (HWID Lock)")
    end
end)

-- Auto Save / Load
local function loadPoints()
    if isfile(filename) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(filename)) end)
        if ok and type(data) == "table" then teleportPoints = data end
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
        char:PivotTo(CFrame.new(point.x, point.y + 1, point.z)) -- 🟢 hanya sedikit di atas tanah
        wait(0.05)
        hrp.Anchored = false
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
    end
end

-- GUI Aman Mobile (tanpa CoreGui)
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AriiTeleport"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 145, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 16)
title.Text = "Arii GUI"
title.BackgroundColor3 = Color3.fromRGB(45,45,45)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.BorderSizePixel = 0

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0,14,0,14)
minimize.Position = UDim2.new(1,-14,0,0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.BorderSizePixel = 0

local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -16)
content.Position = UDim2.new(0, 0, 0, 16)
content.BackgroundTransparency = 1

local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -10, 0, 18)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(80,80,160)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createButton("🚀 Teleport ke Point 1", 5, function() teleportTo(teleportPoints.point1) end)
createButton("🚀 Teleport ke Point 2", 28, function() teleportTo(teleportPoints.point2) end)
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

local delayBox = Instance.new("TextBox", content)
delayBox.Size = UDim2.new(1, -10, 0, 18)
delayBox.Position = UDim2.new(0, 5, 0, 97)
delayBox.PlaceholderText = "Delay detik"
delayBox.Text = tostring(delayTime)
delayBox.BackgroundColor3 = Color3.fromRGB(90,90,90)
delayBox.TextColor3 = Color3.fromRGB(255,255,255)
delayBox.BorderSizePixel = 0
delayBox.ClearTextOnFocus = false
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

content.Parent = frame

-- Minimize
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    minimize.Text = minimized and "+" or "-"
end)

-- Loop Auto Teleport
spawn(function()
    while task.wait(1) do
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            wait(delayTime)
            teleportTo(teleportPoints.point2)
        end
    end
end)

-- Anti AFK
for _,v in pairs(getconnections(player.Idled)) do v:Disable() end

-- Anti jatuh ke void
RunService.Stepped:Connect(function()
    local hrp = getHRP()
    if hrp and not hrp.Anchored and hrp.Position.Y < -100 then
        teleportTo(teleportPoints.point1 or Vector3.new(0, 50, 0))
    end
end)

-- Respawn Fix
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, state)
        if state == Enum.HumanoidStateType.Physics then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end)

loadPoints()
