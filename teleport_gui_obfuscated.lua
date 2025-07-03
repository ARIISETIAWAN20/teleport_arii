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

task.spawn(function()
    while true do
        disableGachaAnimationUI()
        task.wait(2)
    end
end)

local eggRemote = ReplicatedStorage:FindFirstChild("RemoteEvent") and ReplicatedStorage.RemoteEvent:FindFirstChild("Egg")
if eggRemote then
    eggRemote.OnClientEvent:Connect(function(action)
        if action == "Start" or action == "Anim" then
            return -- Blokir animasi
        end
    end)
end

-- ✅ Anti Staff & Cheat
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

-- ✅ UI Menu
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TeleportGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 160, 0, 220)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local function createBtn(txt, posY, cb)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -10, 0, 24)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Text = txt
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(cb)
    return btn
end

createBtn("📌 Set Point 1", 10, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        teleportPoints.point1 = {x = hrp.Position.X, y = hrp.Position.Y, z = hrp.Position.Z}
        savePoints()
    end
end)

createBtn("📌 Set Point 2", 40, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        teleportPoints.point2 = {x = hrp.Position.X, y = hrp.Position.Y, z = hrp.Position.Z}
        savePoints()
    end
end)

createBtn("🚀 Teleport ke Point 1", 70, function()
    teleportTo(teleportPoints.point1)
end)

createBtn("🚀 Teleport ke Point 2", 100, function()
    teleportTo(teleportPoints.point2)
end)

createBtn("▶️ Auto Teleport ON/OFF", 130, function()
    autoTeleport = not autoTeleport
end)

createBtn("💾 Simpan Data", 160, function()
    savePoints()
end)

local delayBox = Instance.new("TextBox", Frame)
delayBox.Size = UDim2.new(1, -10, 0, 24)
delayBox.Position = UDim2.new(0, 5, 0, 190)
delayBox.PlaceholderText = "Delay (detik): " .. tostring(delayTime)
delayBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
delayBox.TextColor3 = Color3.new(1, 1, 1)
delayBox.ClearTextOnFocus = false
delayBox.Text = tostring(delayTime)
delayBox.Font = Enum.Font.SourceSans

-- Delay input
delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val and val > 0 then
        delayTime = val
    end
end)

-- Teleport Loop
spawn(function()
    while true do
        task.wait(1)
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            task.wait(delayTime)
            teleportTo(teleportPoints.point2)
        end
    end
end)

for _,v in pairs(getconnections(player.Idled)) do v:Disable() end

RunService.Stepped:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and not hrp.Anchored then
        hrp.Velocity = Vector3.new(0, math.max(hrp.Velocity.Y, -50), 0)
    end
end)

loadPoints()

warn("[Arii GUI] Teleport + Anti Gacha Animasi aktif.")
