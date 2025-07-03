-- ✅ Teleport GUI "Arii" FINAL Version | HWID Lock + Deep Scan + Delta Safe
-- Developer: AriiSetiawan
-- Hanya berjalan di Climb and Jump Tower (Tokyo Tower)

if game.PlaceId ~= 123921593837160 then
    return warn("[Teleport GUI] Script hanya berjalan di Climb and Jump Tower (Tokyo Tower).")
end

-- Proteksi Fungsi File (Delta Friendly)
if not (writefile and readfile and isfile) then
    getgenv().writefile = function() end
    getgenv().readfile = function() return "{}" end
    getgenv().isfile = function() return false end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8

-- ✅ HWID Lock (Bypass untuk supa_loi dan Devrenzx)
local allowedHWID = "hwid_arix_2024"
local function getHWID()
    return (identifyexecutor and identifyexecutor() or "") .. (gethwid and gethwid() or "")
end

if not table.find({"supa_loi", "Devrenzx"}, player.Name) then
    local currentHWID = getHWID()
    if not currentHWID:lower():find(allowedHWID:lower()) then
        player:Kick("HWID tidak dikenali.")
        return
    end
end

-- ✅ Anti Admin Deep Scan
local suspicious = {"admin", "staff", "mod", "dev", "owner", "helper"}
for _, v in ipairs(Players:GetPlayers()) do
    if v ~= player then
        for _, word in ipairs(suspicious) do
            if string.find(v.Name:lower(), word) or string.find(v.DisplayName:lower(), word) then
                player:Kick("Admin/Staff terdeteksi melalui Deep Scan")
                return
            end
        end
    end
end

-- ✅ Anti Gacha Animasi (Remote & GUI)
local eggRemote = ReplicatedStorage:FindFirstChild("RemoteEvent") and ReplicatedStorage.RemoteEvent:FindFirstChild("Egg")
if eggRemote then
    eggRemote.OnClientEvent:Connect(function(action, data)
        if action == "Start" or action == "Anim" then
            return
        else
            return eggRemote:FireServer(action, data)
        end
    end)
end

task.delay(2, function()
    local gui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("EggOpen")
    if gui then
        gui.Enabled = false
        for _, obj in pairs(gui:GetDescendants()) do
            if obj:IsA("Tween") or obj:IsA("Animation") or obj:IsA("Sound") then
                obj:Destroy()
            end
        end
    end
end)

warn("[Anti Gacha Anim] Aktif di Climb and Jump Tower!")

-- ✅ Blacklist Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

Players.PlayerAdded:Connect(function(p)
    if blacklist[p.Name] then
        player:Kick("Staff terdeteksi")
    end
end)

for _, p in pairs(Players:GetPlayers()) do
    if blacklist[p.Name] and p ~= player then
        player:Kick("Staff terdeteksi")
    end
end

-- ✅ Proteksi Remote Hilang
pcall(function()
    for _,v in pairs(getnilinstances()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            v:Destroy()
        end
    end
end)

-- ✅ Load & Save Teleport Point
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

-- ✅ Fungsi Teleport
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

-- ✅ UI (Delta Friendly - PlayerGui)
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 145, 0, 180)
main.Position = UDim2.new(0.05, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 16)
title.Text = "Arii"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 14, 0, 14)
minimize.Position = UDim2.new(1, -14, 0, 0)
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

local content = Instance.new("Frame", main)
content.Position = UDim2.new(0, 0, 0, 16)
content.Size = UDim2.new(1, 0, 1, -16)
content.BackgroundTransparency = 1

local function button(text, y, callback)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, -10, 0, 18)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.Text = text
    b.MouseButton1Click:Connect(callback)
    return b
end

button("🚀 Teleport Point 1", 5, function() teleportTo(teleportPoints.point1) end)
button("🚀 Teleport Point 2", 28, function() teleportTo(teleportPoints.point2) end)
button("📌 Set Point 1", 51, function()
    local hrp = getHRP()
    teleportPoints.point1 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)
button("📌 Set Point 2", 74, function()
    local hrp = getHRP()
    teleportPoints.point2 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)

local delayBox = Instance.new("TextBox", content)
delayBox.Position = UDim2.new(0, 5, 0, 97)
delayBox.Size = UDim2.new(1, -10, 0, 18)
delayBox.PlaceholderText = "Delay detik"
delayBox.Text = tostring(delayTime)
delayBox.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
delayBox.TextColor3 = Color3.new(1, 1, 1)
delayBox.ClearTextOnFocus = false

delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val and val > 0 then delayTime = val end
end)

local autoBtn = button("▶️ Start Auto Teleport", 120, function()
    autoTeleport = not autoTeleport
    autoBtn.Text = autoTeleport and "⏹ Stop Auto Teleport" or "▶️ Start Auto Teleport"
end)

button("❌ OFF Auto Teleport", 143, function()
    autoTeleport = false
    autoBtn.Text = "▶️ Start Auto Teleport"
end)

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    minimize.Text = minimized and "+" or "-"
end)

spawn(function()
    while true do wait(1)
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            wait(delayTime)
            teleportTo(teleportPoints.point2)
        end
    end
end)

for _,v in pairs(getconnections(player.Idled)) do v:Disable() end

RunService.Stepped:Connect(function()
    local hrp = getHRP()
    if hrp and not hrp.Anchored then
        hrp.Velocity = Vector3.new(0, math.max(hrp.Velocity.Y, -50), 0)
    end
end)

loadPoints()

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end)