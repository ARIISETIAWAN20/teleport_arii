-- ✅ Sc Project - FINAL | Delta Executor Safe -- Developer: Devrenzx | Fitur: Teleport Y, Delay, Anti Staff, Anti Cheat, HWID Lock

-- 🛡️ HWID Lock + Bypass Dev local allowedHWIDs = { ["MASUKKAN_HWID_KAMU_DI_SINI"] = true, }

local allowedUsers = { ["supa_loi"] = true, ["Devrenzx"] = true, }

local function getHWID() local id = "unknown" pcall(function() id = tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end) return id end

local hwid = getHWID() local name = game.Players.LocalPlayer.Name if not allowedUsers[name] and not allowedHWIDs[hwid] then game.Players.LocalPlayer:Kick("⛔ HWID tidak dikenali. Akses ditolak.") return end

-- Proteksi File pcall(function() if not writefile then getgenv().writefile = function() end end if not readfile then getgenv().readfile = function() return "" end end if not isfile then getgenv().isfile = function() return false end end end)

-- Global getgenv().pointHighY = nil getgenv().pointLowY = nil getgenv().autoTeleport = false getgenv().uiVisible = true local delayTime = 8

-- Save/Load local function savePoints() local data = { high = getgenv().pointHighY, low = getgenv().pointLowY } pcall(function() writefile("ScProjectPoints.txt", game:GetService("HttpService"):JSONEncode(data)) end) end

local function loadPoints() pcall(function() if isfile("ScProjectPoints.txt") then local data = game:GetService("HttpService"):JSONDecode(readfile("ScProjectPoints.txt")) getgenv().pointHighY = data.high getgenv().pointLowY = data.low end end) end loadPoints()

-- UI Setup local player = game:GetService("Players").LocalPlayer local gui = Instance.new("ScreenGui", player.PlayerGui) local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 240, 0, 320) frame.Position = UDim2.new(0.02, 0, 0.4, 0) frame.BackgroundColor3 = Color3.fromRGB(85, 0, 127) frame.BorderSizePixel = 0 frame.Active = true frame.Draggable = true

local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1, -35, 0, 30) title.Position = UDim2.new(0, 0, 0, 0) title.BackgroundTransparency = 1 title.Text = "Sc Project GUI" title.TextColor3 = Color3.new(1, 1, 1) title.Font = Enum.Font.SourceSansBold title.TextSize = 18

toggleBtn = Instance.new("TextButton", frame) toggleBtn.Size = UDim2.new(0, 30, 0, 30) toggleBtn.Position = UDim2.new(1, -30, 0, 0) toggleBtn.Text = "-" toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 180) toggleBtn.TextColor3 = Color3.new(1, 1, 1) toggleBtn.Font = Enum.Font.SourceSansBold toggleBtn.TextSize = 18

toggleBtn.MouseButton1Click:Connect(function() frame.Visible = false logo.Visible = true end)

local logo = Instance.new("TextButton", gui) logo.Size = UDim2.new(0, 130, 0, 30) logo.Position = UDim2.new(0.02, 0, 0.37, 0) logo.Text = "+ Sc Project" logo.BackgroundColor3 = Color3.fromRGB(85, 0, 127) logo.TextColor3 = Color3.new(1, 1, 1) logo.BorderSizePixel = 0 logo.Visible = false logo.MouseButton1Click:Connect(function() frame.Visible = true logo.Visible = false end)

-- Fungsi UI local function showNotification(text) local notif = Instance.new("TextLabel", gui) notif.Size = UDim2.new(0, 200, 0, 30) notif.Position = UDim2.new(0.5, -100, 0.1, 0) notif.BackgroundColor3 = Color3.fromRGB(0, 170, 0) notif.TextColor3 = Color3.new(1, 1, 1) notif.Font = Enum.Font.SourceSansBold notif.TextSize = 18 notif.Text = text notif.ZIndex = 10 game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {TextTransparency = 0}):Play() task.delay(2, function() game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {TextTransparency = 1}):Play() task.wait(0.5) notif:Destroy() end) end

local function createBtn(txt, pos, callback) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(0, 220, 0, 30) btn.Position = pos btn.Text = txt btn.BackgroundColor3 = Color3.fromRGB(100, 0, 140) btn.TextColor3 = Color3.new(1, 1, 1) btn.BorderSizePixel = 0 btn.TextSize = 14 btn.Font = Enum.Font.SourceSansBold btn.MouseButton1Click:Connect(callback) end

local function createInputLabel(labelText, pos, callback) local label = Instance.new("TextLabel", frame) label.Size = UDim2.new(0, 220, 0, 20) label.Position = pos label.BackgroundTransparency = 1 label.Text = labelText label.TextColor3 = Color3.fromRGB(255, 255, 255) label.TextSize = 14 label.TextXAlignment = Enum.TextXAlignment.Left

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0, 220, 0, 25)
box.Position = pos + UDim2.new(0, 0, 0, 20)
box.PlaceholderText = "Isi delay 1-10 detik"
box.Text = ""
box.TextSize = 14
box.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
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

-- Tombol UI createBtn("📍 Set Point Tinggi", UDim2.new(0, 10, 0, 40), function() getgenv().pointHighY = player.Character.HumanoidRootPart.Position.Y savePoints() showNotification("✅ Titik Tinggi Disimpan") end)

createBtn("📍 Set Point Rendah", UDim2.new(0, 10, 0, 80), function() getgenv().pointLowY = player.Character.HumanoidRootPart.Position.Y savePoints() showNotification("✅ Titik Rendah Disimpan") end)

createBtn("🚀 Toggle Auto Teleport", UDim2.new(0, 10, 0, 120), function() getgenv().autoTeleport = not getgenv().autoTeleport showNotification("🚀 Auto Teleport " .. (getgenv().autoTeleport and "AKTIF" or "NONAKTIF")) end)

createInputLabel("⏱️ Delay (1-10 detik):", UDim2.new(0, 10, 0, 160), function(num) delayTime = num end)

-- Auto Teleport Loop spawn(function() while wait(1) do if getgenv().autoTeleport and getgenv().pointHighY and getgenv().pointLowY then local char = player.Character if char and char:FindFirstChild("HumanoidRootPart") then local y = char.HumanoidRootPart.Position.Y local targetY = (math.abs(y - getgenv().pointHighY) > math.abs(y - getgenv().pointLowY)) and getgenv().pointHighY or getgenv().pointLowY wait(delayTime) if getgenv().autoTeleport then char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, targetY + 2, char.HumanoidRootPart.Position.Z) end end end end end)

-- Anti AFK pcall(function() for _, v in pairs(getconnections(player.Idled)) do v:Disable() end end)

-- Deep Scan Staff local blacklistStaff = { ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true, ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true, ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true, ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true, ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true, }

spawn(function() while wait(5) do for _, plr in pairs(game.Players:GetPlayers()) do if blacklistStaff[plr.Name] then frame.Visible = false logo.Visible = true warn("⚠️ STAFF DETECTED: " .. plr.Name) showNotification("⚠️ Staff Terdeteksi: " .. plr.Name) end end end end)

