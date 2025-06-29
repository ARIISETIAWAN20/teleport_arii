-- ✅ Arii Teleport GUI FINAL | Delta Executor Mobile Safe
-- Developer: AriiSetiawan

-- Proteksi Fungsi File (Delta Friendly)
if not (writefile and readfile and isfile) then
    getgenv().writefile = function() end
    getgenv().readfile = function() return "{}" end
    getgenv().isfile = function() return false end
end

-- HWID Lock & Allowed Users
local allowedHWIDs = {
    ["MASUKKAN_HWID_KAMU_DI_SINI"] = true,
}
local allowedUsers = {
    ["supa_loi"] = true,
    ["Devrenzx"] = true,
}

local function getHWID()
    local id = "unknown"
    pcall(function()
        id = game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    return id
end

local player = game.Players.LocalPlayer
local hwid = getHWID()
if not allowedUsers[player.Name] and not allowedHWIDs[hwid] then
    player:Kick("⛔ HWID tidak dikenali. Akses ditolak.")
    return
end

-- Auto Kick jika Chat mencurigakan
local forbiddenWords = {
    "cheating", "cheat", "hack", "hacking", "script", "aimbot",
    "esp", "riport", "ban", "banned", "exploit", "exploiting"
}

local function containsForbiddenWord(message)
    message = message:lower()
    for _, word in ipairs(forbiddenWords) do
        if string.find(message, word) then
            return true
        end
    end
    return false
end

player.Chatted:Connect(function(message)
    if containsForbiddenWord(message) then
        player:Kick("KAMU TELAH DI CURIGAI!!!")
    end
end)

-- Service
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Anti Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

for _, p in pairs(game.Players:GetPlayers()) do
    if blacklist[p.Name] and p ~= player then
        player:Kick("Staff terdeteksi")
    end
end

game.Players.PlayerAdded:Connect(function(p)
    if blacklist[p.Name] then
        player:Kick("Staff terdeteksi")
    end
end)

-- 🔍 Deep Scan Admin/Observer Tersembunyi
RunService.RenderStepped:Connect(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") or obj:IsA("Highlight") or obj:IsA("SelectionBox") then
            if obj.Adornee and not obj:IsDescendantOf(player.Character) then
                player:Kick("Observer/Admin tersembunyi terdeteksi!")
            end
        end
    end
end)

-- Data dan Auto Teleport
local filename = "teleport_points.json"
local teleportPoints = { point1 = nil, point2 = nil }
local autoTeleport = true
local delayTime = 8

local function savePoints()
    pcall(function()
        writefile(filename, HttpService:JSONEncode(teleportPoints))
    end)
end

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

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function teleportTo(pos)
    if pos then
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = getHRP()
        hrp.Anchored = true
        hrp.Velocity = Vector3.zero
        wait(0.05)
        char:PivotTo(CFrame.new(pos.x, pos.y, pos.z))
        wait(0.05)
        hrp.Anchored = false
    end
end

-- GUI (Tanpa CoreGui)
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "TeleportGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 188, 0, 234)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 16)
title.Text = "Sc Project"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.BorderSizePixel = 0

local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, 0, 1, -16)
contentFrame.Position = UDim2.new(0, 0, 0, 16)
contentFrame.BackgroundTransparency = 1

local function createButton(text, y, callback)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.new(1, -10, 0, 18)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.Text = text
    b.MouseButton1Click:Connect(callback)
    return b
end

createButton("🚀 Teleport ke Point 1", 5, function() teleportTo(teleportPoints.point1) end)
createButton("🚀 Teleport ke Point 2", 28, function() teleportTo(teleportPoints.point2) end)
createButton("📌 Set Point 1", 51, function()
    local hrp = getHRP()
    teleportPoints.point1 = { x = hrp.Position.X, y = hrp.Position.Y, z = hrp.Position.Z }
    savePoints()
end)
createButton("📌 Set Point 2", 74, function()
    local hrp = getHRP()
    teleportPoints.point2 = { x = hrp.Position.X, y = hrp.Position.Y, z = hrp.Position.Z }
    savePoints()
end)

local delayBox = Instance.new("TextBox", contentFrame)
delayBox.Size = UDim2.new(1, -10, 0, 18)
delayBox.Position = UDim2.new(0, 5, 0, 97)
delayBox.PlaceholderText = "Delay (detik)"
delayBox.Text = tostring(delayTime)
delayBox.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.Font = Enum.Font.SourceSans
delayBox.TextSize = 13
delayBox.BorderSizePixel = 0
delayBox.ClearTextOnFocus = false
delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val then delayTime = val end
end)

local autoBtn
autoBtn = createButton("⏹ Stop Auto Teleport", 120, function()
    autoTeleport = not autoTeleport
    autoBtn.Text = autoTeleport and "⏹ Stop Auto Teleport" or "▶️ Start Auto Teleport"
end)

createButton("❌ OFF Auto Teleport", 143, function()
    autoTeleport = false
    autoBtn.Text = "▶️ Start Auto Teleport"
end)

-- Loop Teleport
task.spawn(function()
    while true do
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            wait(delayTime)
            teleportTo(teleportPoints.point2)
            wait(1)
        else
            wait(0.5)
        end
    end
end)

-- Anti AFK
for _, v in pairs(getconnections(player.Idled)) do v:Disable() end

-- Humanoid Recovery
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end)

loadPoints()
