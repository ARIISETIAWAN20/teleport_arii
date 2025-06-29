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

local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1, -60, 0, 30) title.Position = UDim2.new(0, 0, 0, 0) title.BackgroundTransparency = 1 title.Text = "Sc Project" title.TextColor3 = Color3.new(1, 1, 1) title.Font = Enum.Font.SourceSansBold title.TextSize = 18

local toggleBtn = Instance.new("TextButton", frame) toggleBtn.Size = UDim2.new(0, 30, 0, 30) toggleBtn.Position = UDim2.new(1, -60, 0, 0) toggleBtn.Text = "-" toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 180) toggleBtn.TextColor3 = Color3.new(1, 1, 1) toggleBtn.Font = Enum.Font.SourceSansBold toggleBtn.TextSize = 18

local maximizeBtn = Instance.new("TextButton", frame) maximizeBtn.Size = UDim2.new(0, 30, 0, 30) maximizeBtn.Position = UDim2.new(1, -30, 0, 0) maximizeBtn.Text = "+" maximizeBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 180) maximizeBtn.TextColor3 = Color3.new(1, 1, 1) maximizeBtn.Font = Enum.Font.SourceSansBold maximizeBtn.TextSize = 18 maximizeBtn.Visible = false

local elements = {} local function createElement(inst) table.insert(elements, inst) return inst end

local function hideUI() for _, v in pairs(elements) do v.Visible = false end toggleBtn.Visible = false maximizeBtn.Visible = true end

local function showUI() for _, v in pairs(elements) do v.Visible = true end toggleBtn.Visible = true maximizeBtn.Visible = false end

toggleBtn.MouseButton1Click:Connect(hideUI) maximizeBtn.MouseButton1Click:Connect(showUI)

-- Fungsi UI local function showNotification(text) local notif = Instance.new("TextLabel", gui) notif.Size = UDim2.new(0, 200, 0, 30) notif.Position = UDim2.new(0.5, -100, 0.1, 0) notif.BackgroundColor3 = Color3.fromRGB(0, 170, 0) notif.TextColor3 = Color3.new(1, 1, 1) notif.Font = Enum.Font.SourceSansBold notif.TextSize = 18 notif.Text = text notif.ZIndex = 10 game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {TextTransparency = 0}):Play() task.delay(2, function() game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {TextTransparency = 1}):Play() task.wait(0.5) notif:Destroy() end) end

-- Tombol local btn1 = createElement(Instance.new("TextButton", frame)) btn1.Size = UDim2.new(0, 220, 0, 30) btn1.Position = UDim2.new(0, 10, 0, 40) btn1.Text = "📍 Set Point Tinggi" btn1.BackgroundColor3 = Color3.fromRGB(100, 0, 140) btn1.TextColor3 = Color3.new(1, 1, 1) btn1.BorderSizePixel = 0 btn1.TextSize = 14 btn1.Font = Enum.Font.SourceSansBold btn1.MouseButton1Click:Connect(function() getgenv().pointHighY = player.Character.HumanoidRootPart.Position.Y savePoints() showNotification("✅ Titik Tinggi Disimpan") end)

local btn2 = createElement(Instance.new("TextButton", frame)) btn2.Size = UDim2.new(0, 220, 0, 30) btn2.Position = UDim2.new(0, 10, 0, 80) btn2.Text = "📍 Set Point Rendah" btn2.BackgroundColor3 = Color3.fromRGB(100, 0, 140) btn2.TextColor3 = Color3.new(1, 1, 1) btn2.BorderSizePixel = 0 btn2.TextSize = 14 btn2.Font = Enum.Font.SourceSansBold btn2.MouseButton1Click:Connect(function() getgenv().pointLowY = player.Character.HumanoidRootPart.Position.Y savePoints() showNotification("✅ Titik Rendah Disimpan") end)

local btn3 = createElement(Instance.new("TextButton", frame)) btn3.Size = UDim2.new(0, 220, 0, 30) btn3.Position = UDim2.new(0, 10, 0, 120) btn3.Text = "🚀 Toggle Auto Teleport" btn3.BackgroundColor3 = Color3.fromRGB(100, 0, 140) btn3.TextColor3 = Color3.new(1, 1, 1) btn3.BorderSizePixel = 0 btn3.TextSize = 14 btn3.Font = Enum.Font.SourceSansBold btn3.MouseButton1Click:Connect(function() getgenv().autoTeleport = not getgenv().autoTeleport showNotification("🚀 Auto Teleport " .. (getgenv().autoTeleport and "AKTIF" or "NONAKTIF")) end)

local label = createElement(Instance.new("TextLabel", frame)) label.Size = UDim2.new(0, 220, 0, 20) label.Position = UDim2.new(0, 10, 0, 160) label.BackgroundTransparency = 1 label.Text = "⏱️ Delay (1-10 detik):" label.TextColor3 = Color3.fromRGB(255, 255, 255) label.TextSize = 14 label.TextXAlignment = Enum.TextXAlignment.Left

local box = createElement(Instance.new("TextBox", frame)) box.Size = UDim2.new(0, 220, 0, 25) box.Position = UDim2.new(0, 10, 0, 180) box.PlaceholderText = "Isi delay 1-10 detik" box.Text = "" box.TextSize = 14 box.BackgroundColor3 = Color3.fromRGB(60, 0, 90) box.TextColor3 = Color3.new(1, 1, 1) box.BorderSizePixel = 0 box.FocusLost:Connect(function() local num = tonumber(box.Text) if num and num >= 1 and num <= 10 then delayTime = num showNotification("✅ Delay diatur menjadi " .. num .. " detik") else showNotification("❌ Masukkan angka 1-10") end end)

-- Auto Teleport Loop spawn(function() while wait(1) do if getgenv().autoTeleport and getgenv().pointHighY and getgenv().pointLowY then local char = player.Character if char and char:FindFirstChild("HumanoidRootPart") then local y = char.HumanoidRootPart.Position.Y local targetY = (math.abs(y - getgenv().pointHighY) > math.abs(y - getgenv().pointLowY)) and getgenv().pointHighY or getgenv().pointLowY wait(delayTime) if getgenv().autoTeleport then char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, targetY + 2, char.HumanoidRootPart.Position.Z) end end end end end)

-- Anti AFK pcall(function() for _, v in pairs(getconnections(player.Idled)) do v:Disable() end end)

-- Deep Scan Staff local blacklistStaff = { ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true, ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true, ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true, ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true, ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true, }

spawn(function() while wait(5) do for _, plr in pairs(game.Players:GetPlayers()) do if blacklistStaff[plr.Name] then frame.Visible = false warn("⚠️ STAFF DETECTED: " .. plr.Name) showNotification("⚠️ Staff Terdeteksi: " .. plr.Name) end end end end)

