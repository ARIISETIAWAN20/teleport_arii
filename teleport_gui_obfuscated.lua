-- ✅ Teleport GUI "Arii" versi gabungan dua UI
-- Fitur: Teleport 2 titik, auto teleport, delay, anti cheat, anti staff, minimize + Anti Gacha Animasi
-- Hanya untuk Climb and Jump Tower (Tokyo Tower)

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
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8

-- ✅ Anti Gacha Animasi (Remote & GUI)
local function disableGachaAnimationUI()
    local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("EggOpen")
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

-- ✅ Teleport Fungsi
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

-- ✅ Sisanya UI dan fungsi kamu tetap seperti sebelumnya

-- Jalankan AutoTeleport
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

warn("[Arii GUI] Teleport + Anti Gacha Animasi aktif.")
