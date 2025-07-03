-- ✅ Teleport GUI "Arii" versi gabungan dua UI
-- Fitur: Teleport 2 titik, auto teleport, delay, anti cheat, anti staff, minimize + Anti Gacha Animasi
-- Hanya untuk Climb and Jump Tower (Tokyo Tower)

if game.PlaceId ~= 123921593837160 then
    return warn("[Teleport GUI] Script hanya berjalan di Climb and Jump Tower (Tokyo Tower).")
end

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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8

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

local function disableGachaAnimationUI()
    local gui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("EggOpen")
    if gui then
        gui.Enabled = false
        for _, obj in pairs(gui:GetDescendants()) do
            if obj:IsA("Tween") or obj:IsA("Animation") or obj:IsA("Sound") then
                obj:Destroy()
            end
        end
    end
end

game.Loaded:Connect(disableGachaAnimationUI)
task.delay(2, disableGachaAnimationUI)

warn("[Anti Gacha Anim] Aktif di Climb and Jump Tower!")

local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

Players.PlayerAdded:Connect(function(p)
    if blacklist[p.Name] then
        StarterGui:SetCore("SendNotification", {
            Title = "Auto Leave", Text = "Staff terdeteksi. Keluar game.", Duration = 1
        })
        wait(2)
        player:Kick("Staff terdeteksi")
    end
end)

for _, p in pairs(Players:GetPlayers()) do
    if blacklist[p.Name] and p ~= player then
        player:Kick("Staff terdeteksi")
    end
end

pcall(function()
    for _,v in pairs(getnilinstances()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            v:Destroy()
        end
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Anti Cheat", Text = "Proteksi sederhana diaktifkan", Duration = 5
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

-- UI Building
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

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    contentFrame.Visible = not minimized
    minimizeButton.Text = minimized and "+" or "-"
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end)
