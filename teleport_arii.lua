-- ✅ Teleport GUI "Arii" versi final + Proteksi Lengkap + HWID Lock + Akun Aman

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
local StarterGui = game:GetService("StarterGui")
local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8

-- ✅ Blacklist Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

-- 🔒 Proteksi DeepScan + Kick jika ada staff masuk
local function deepScan()
    for _, plr in pairs(Players:GetPlayers()) do
        local name = plr.Name:lower()
        local desc = plr:FindFirstChild("HumanoidDescription")
        if blacklist[name] or (desc and tostring(desc):lower():find("moderator")) then
            player:Kick("Staff / Moderasi terdeteksi (deep scan)")
        end
    end
end
deepScan()
Players.PlayerAdded:Connect(function(p)
    if blacklist[p.Name] then
        StarterGui:SetCore("SendNotification", {
            Title = "Auto Leave", Text = "Staff terdeteksi. Keluar game.", Duration = 1
        })
        wait(2)
        player:Kick("Staff terdeteksi")
    end
    wait(1)
    deepScan()
end)

for _, p in pairs(Players:GetPlayers()) do
    if blacklist[p.Name] and p ~= player then
        player:Kick("Staff terdeteksi")
    end
end

-- 🔐 Proteksi Bypass Fungsi Lingkungan
pcall(function()
    for _,v in pairs(getnilinstances()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            v:Destroy()
        end
    end
    hookfunction(getfenv, function(...) return {} end)
    hookfunction(setfenv, function(...) return {} end)
    hookfunction(getgenv, function(...) return {} end)
    getgenv()._G = {}; getgenv().shared = {}
end)

StarterGui:SetCore("SendNotification", {
    Title = "Anti Cheat", Text = "Proteksi sederhana diaktifkan", Duration = 5
})

-- 🧊 HWID Lock + Izinkan akun tertentu
pcall(function()
    local allowedHWID = "HWID_ARI_123" -- Ganti dengan HWID kamu
    local allowedUsers = {
        ["supa_loi"] = true,
        ["Devrenzx"] = true
    }

    local function getHWID()
        return tostring(game:GetService("RbxAnalyticsService"):GetClientId())
    end

    if not allowedUsers[player.Name] then
        if getHWID() ~= allowedHWID then
            player:Kick("Perangkat tidak diizinkan (HWID Lock)")
        end
    end
end)

-- 🛡️ Proteksi Remote Spoofing
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(self):lower():find("log") or tostring(self):lower():find("report") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
end)

-- 💣 Hapus Signature Arii di getgenv
pcall(function()
    for k, v in pairs(getgenv()) do
        if typeof(v) == "string" and v:lower():find("ari") then
            getgenv()[k] = nil
        end
    end
end)

-- 💠 Fungsi-fungsi utama GUI Arii
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

-- 📦 UI Building
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

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
title.BorderSizePixel = 0
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = MainFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 14, 0, 14)
minimizeButton.Position = UDim2.new(1, -14, 0, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeButton.BorderSizePixel = 0
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
    b.BorderSizePixel = 0
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

-- 🔁 Auto Teleport Loop
spawn(function()
    while true do wait(1)
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            wait(delayTime)
            teleportTo(teleportPoints.point2)
        end
    end
end)

-- 🚫 Anti Idle
for _,v in pairs(getconnections(player.Idled)) do v:Disable() end

-- 🧱 Anti Clip Deteksi Tembus Part
RunService.Stepped:Connect(function()
    local hrp = getHRP()
    if hrp and not hrp.Anchored then
        hrp.Velocity = Vector3.new(0, math.max(hrp.Velocity.Y, -50), 0)
        local touching = workspace:GetPartsInPart(hrp)
        for _, part in pairs(touching) do
            if part.CanCollide and part.Transparency < 0.2 and not part:IsDescendantOf(player.Character) then
                StarterGui:SetCore("SendNotification", {
                    Title = "Anti Clip", Text = "Clip terdeteksi. Reset posisi.", Duration = 2
                })
                teleportTo(teleportPoints.point1 or hrp.Position)
                break
            end
        end
    end
end)

-- 🚶 Anti stuck saat respawn
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end)

-- 🔄 Load Teleport Data
loadPoints()
