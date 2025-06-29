-- ✅ Sc Project - FINAL | Delta Executor Safe
-- Developer: Devrenzx | Fitur: Teleport Y, Delay, Anti Staff, Anti Cheat, HWID Lock

-- 🛡️ HWID Lock + Bypass Dev
local allowedHWIDs = {
    ["MASUKKAN_HWID_KAMU_DI_SINI"] = true, -- Ganti dengan HWID kamu
}

local allowedUsers = {
    ["supa_loi"] = true,
    ["Devrenzx"] = true,
}

local function getHWID()
    local id = "unknown"
    pcall(function()
        id = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
    end)
    return id
end

local hwid = getHWID()
local name = game.Players.LocalPlayer.Name

if not allowedUsers[name] and not allowedHWIDs[hwid] then
    game.Players.LocalPlayer:Kick("⛔ HWID tidak dikenali. Akses ditolak.")
    return
end

-- 🌐 Proteksi File (Delta Safe)
pcall(function()
    if not writefile then getgenv().writefile = function() end end
    if not readfile then getgenv().readfile = function() return "" end end
    if not isfile then getgenv().isfile = function() return false end end
end)

-- 🔧 Global Konfigurasi
getgenv().pointHighY = nil
getgenv().pointLowY = nil
getgenv().autoTeleport = false
getgenv().uiVisible = true
local delayTime = 8 -- Default Delay 8 Detik

-- 💾 Save / Load Point
local function savePoints()
    local data = {
        high = getgenv().pointHighY,
        low = getgenv().pointLowY
    }
    pcall(function()
        writefile("ScProjectPoints.txt", game:GetService("HttpService"):JSONEncode(data))
    end)
end

local function loadPoints()
    pcall(function()
        if isfile("ScProjectPoints.txt") then
            local data = game:GetService("HttpService"):JSONDecode(readfile("ScProjectPoints.txt"))
            getgenv().pointHighY = data.high
            getgenv().pointLowY = data.low
        end
    end)
end

loadPoints()

-- 🎨 UI Setup
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ScProjectUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 290)
frame.Position = UDim2.new(0.02, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- 🔔 Notifikasi UI
local function showNotification(text)
    local notif = Instance.new("TextLabel", gui)
    notif.Size = UDim2.new(0, 200, 0, 30)
    notif.Position = UDim2.new(0.5, -100, 0.1, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    notif.TextColor3 = Color3.new(1, 1, 1)
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 18
    notif.Text = text
    notif.BorderSizePixel = 0
    notif.ZIndex = 10
    game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.delay(2, function()
        game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.5)
        notif:Destroy()
    end)
end

-- 🔘 UI Helper
local function createBtn(txt, pos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = pos
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(callback)
end

-- 🧾 Input Delay Manual
local function createInputLabel(labelText, pos, callback)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 200, 0, 20)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0, 200, 0, 25)
    box.Position = pos + UDim2.new(0, 0, 0, 20)
    box.PlaceholderText = "Isi delay 1-10 detik"
    box.Text = ""
    box.TextSize = 14
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BorderSizePixel = 0

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num and num >= 1 and num <= 10 then
            callback(num)
            showNotification("✅ Delay diatur menjadi " .. num .. " detik")
        else
            showNotification("❌ Masukkan angka 1-10")
        end
    end)
end

-- 📌 Tombol Utama
createBtn("📍 Set Point Tinggi", UDim2.new(0,10,0,10), function()
    getgenv().pointHighY = player.Character.HumanoidRootPart.Position.Y
    savePoints()
    showNotification("✅ Titik Tinggi Disimpan")
end)

createBtn("📍 Set Point Rendah", UDim2.new(0,10,0,50), function()
    getgenv().pointLowY = player.Character.HumanoidRootPart.Position.Y
    savePoints()
    showNotification("✅ Titik Rendah Disimpan")
end)

createBtn("🚀 Toggle Auto Teleport", UDim2.new(0,10,0,90), function()
    getgenv().autoTeleport = not getgenv().autoTeleport
    showNotification("🚀 Auto Teleport " .. (getgenv().autoTeleport and "AKTIF" or "NONAKTIF"))
end)

createInputLabel("⏱️ Delay (1-10 detik):", UDim2.new(0,10,0,130), function(num)
    delayTime = num
end)

createBtn("🔽 Minimize", UDim2.new(0,10,0,200), function()
    frame.Visible = false
    logo.Visible = true
end)

-- 🔒 Minimize UI
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 130, 0, 30)
logo.Position = UDim2.new(0.02, 0, 0.37, 0)
logo.Text = "🔒 Sc Project"
logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.BorderSizePixel = 0
logo.Visible = false
logo.MouseButton1Click:Connect(function()
    frame.Visible = true
    logo.Visible = false
end)

-- 🔁 Auto Teleport Loop
task.spawn(function()
    while task.wait(1) do
        if getgenv().autoTeleport and getgenv().pointHighY and getgenv().pointLowY then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local y = char.HumanoidRootPart.Position.Y
                local targetY = (math.abs(y - getgenv().pointHighY) > math.abs(y - getgenv().pointLowY)) and getgenv().pointHighY or getgenv().pointLowY

                task.wait(delayTime)
                if getgenv().autoTeleport then
                    char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, targetY + 2, char.HumanoidRootPart.Position.Z)
                end
            end
        end
    end
end)

-- ⚠️ Anti AFK
pcall(function()
    for _, v in pairs(getconnections(player.Idled)) do
        v:Disable()
    end
end)

-- 🕵️‍♂️ Deep Scan Staff
local blacklistStaff = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true,
}

task.spawn(function()
    while task.wait(5) do
        for _, plr in pairs(game.Players:GetPlayers()) do
            if blacklistStaff[plr.Name] then
                frame.Visible = false
                logo.Visible = true
                warn("⚠️ STAFF DETECTED: " .. plr.Name)
                showNotification("⚠️ Staff Terdeteksi: " .. plr.Name)
            end
        end
    end
end)