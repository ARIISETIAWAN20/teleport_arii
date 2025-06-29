-- ✅ Teleport GUI "Arii" Versi Gabungan - Perlindungan Maksimal -- Fitur: Teleport 2 Titik, Auto Teleport, Delay, Anti Cheat, Anti Staff, HWID Lock, Deep Scan, Minimize UI

-- Proteksi Fungsi File untuk Delta Executor if not (writefile and readfile and isfile) then getgenv().writefile = function() end getgenv().readfile = function() return "{}" end getgenv().isfile = function() return false end end

local Players = game:GetService("Players") local player = Players.LocalPlayer local HttpService = game:GetService("HttpService") local RunService = game:GetService("RunService") local StarterGui = game:GetService("StarterGui") local filename = "teleport_points.json" local teleportPoints = {point1 = nil, point2 = nil} local autoTeleport = false local delayTime = 8

-- HWID Lock & Whitelist local allowedHWIDs = { ["abc123"] = true,  -- Ganti dengan HWID kamu ["xyz789"] = true, } local whitelistUser = { ["supa_loi"] = true, ["Devrenzx"] = true }

pcall(function() local hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId()):gsub("-", ""):lower() if not allowedHWIDs[hwid] and not whitelistUser[player.Name] then StarterGui:SetCore("SendNotification", { Title = "Blokir Akses", Text = "HWID tidak dikenali.", Duration = 5 }) wait(2) player:Kick("HWID tidak terdaftar.") end end)

-- Blacklist dan Deep Scan local blacklist = { ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true, ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true, ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true, ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true, ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true }

local suspiciousKeywords = {"mod", "staff", "admin", "check", "spectate", "inspect"} local function isSuspiciousUser(p) local dn = (p.DisplayName or ""):lower() local un = p.Name:lower() for _, k in pairs(suspiciousKeywords) do if dn:find(k) or un:find(k) then return true end end return p.AccountAge > 200 and p.MembershipType == Enum.MembershipType.Premium end

local function scanPlayers() for _, p in pairs(Players:GetPlayers()) do if p ~= player and (blacklist[p.Name] or isSuspiciousUser(p)) then StarterGui:SetCore("SendNotification", { Title = "Deep Scan", Text = "Staff terdeteksi.", Duration = 4 }) wait(1) player:Kick("Deep Scan: Staff/Observer Detected") end end end

Players.PlayerAdded:Connect(scanPlayers) Players.PlayerRemoving:Connect(scanPlayers) task.spawn(function() while true do scanPlayers() wait(10) end end)

-- Bypass Kick, Anti Error pcall(function() local mt = getrawmetatable(game) setreadonly(mt, false) local old = mt.__index mt.__index = function(self, k) if tostring(k):lower():find("kick") or tostring(k):lower():find("crash") then return function() end end return old(self, k) end setreadonly(mt, true) end)

-- Anti AFK pcall(function() local vu = game:GetService("VirtualUser") player.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end) end)

-- Load & Save Point local function loadPoints() if isfile(filename) then local success, data = pcall(function() return HttpService:JSONDecode(readfile(filename)) end) if success and type(data) == "table" then teleportPoints = data end end end

local function savePoints() pcall(function() writefile(filename, HttpService:JSONEncode(teleportPoints)) end) end

local function getHRP() local char = player.Character or player.CharacterAdded:Wait() return char:WaitForChild("HumanoidRootPart") end

local function teleportTo(point) if point then local char = player.Character or player.CharacterAdded:Wait() local hrp = getHRP() hrp.Anchored = true hrp.Velocity = Vector3.zero local humanoid = char:FindFirstChildOfClass("Humanoid") if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end wait(0.05) char:PivotTo(CFrame.new(point.x, point.y + 3, point.z)) wait(0.05) hrp.Anchored = false if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end end end

-- GUI local gui = Instance.new("ScreenGui", game.CoreGui) local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0,145,0,180) frame.Position = UDim2.new(0.05,0,0.2,0) frame.BackgroundColor3 = Color3.fromRGB(30,30,30) frame.Active = true frame.Draggable = true

local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1,0,0,16) title.Text = "Arii" title.TextColor3 = Color3.new(1,1,1) title.BackgroundColor3 = Color3.fromRGB(45,45,45) title.Font = Enum.Font.SourceSansBold title.TextSize = 14

local minimize = Instance.new("TextButton", frame) minimize.Size = UDim2.new(0,14,0,14) minimize.Position = UDim2.new(1,-14,0,0) minimize.Text = "-" minimize.TextColor3 = Color3.new(1,1,1) minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)

local content = Instance.new("Frame", frame) content.Size = UDim2.new(1,0,1,-16) content.Position = UDim2.new(0,0,0,16) content.BackgroundTransparency = 1

local function button(text, y, callback) local b = Instance.new("TextButton", content) b.Size = UDim2.new(1,-10,0,18) b.Position = UDim2.new(0,5,0,y) b.BackgroundColor3 = Color3.fromRGB(80,80,160) b.TextColor3 = Color3.new(1,1,1) b.Font = Enum.Font.SourceSansBold b.TextSize = 13 b.Text = text b.MouseButton1Click:Connect(callback) return b end

button("🚀 Teleport to Point 1", 5, function() teleportTo(teleportPoints.point1) end) button("🚀 Teleport to Point 2", 28, function() teleportTo(teleportPoints.point2) end) button("📌 Set Point 1", 51, function() local hrp = getHRP() teleportPoints.point1 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z} savePoints() end) button("📌 Set Point 2", 74, function() local hrp = getHRP() teleportPoints.point2 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z} savePoints() end)

local delayBox = Instance.new("TextBox", content) delayBox.Size = UDim2.new(1,-10,0,18) delayBox.Position = UDim2.new(0,5,0,97) delayBox.PlaceholderText = "Delay detik" delayBox.Text = tostring(delayTime) delayBox.BackgroundColor3 = Color3.fromRGB(90,90,90) delayBox.TextColor3 = Color3.new(1,1,1) delayBox.ClearTextOnFocus = false

delayBox.FocusLost:Connect(function() local val = tonumber(delayBox.Text) if val and val > 0 then delayTime = val end end)

local autoBtn = button("▶️ Start Auto Teleport", 120, function() autoTeleport = not autoTeleport autoBtn.Text = autoTeleport and "⏹ Stop Auto Teleport" or "▶️ Start Auto Teleport" end)

button("❌ OFF Auto Teleport", 143, function() autoTeleport = false autoBtn.Text = "▶️ Start Auto Teleport" end)

local credit = Instance.new("TextLabel", frame) credit.Size = UDim2.new(1,0,0,14) credit.Position = UDim2.new(0,0,1,-14) credit.BackgroundTransparency = 1 credit.TextColor3 = Color3.fromRGB(180,180,180) credit.Font = Enum.Font.SourceSansItalic credit.TextSize = 11 credit.Text = "By Ari"

-- Minimize UI local minimized = false minimize.MouseButton1Click:Connect(function() minimized = not minimized content.Visible = not minimized minimize.Text = minimized and "+" or "-" end)

-- Auto Teleport spawn(function() while true do wait(1) if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then teleportTo(teleportPoints.point1) wait(delayTime) teleportTo(teleportPoints.point2) end end end)

-- Proteksi jatuh/fly exploit RunService.Stepped:Connect(function() local hrp = getHRP() if hrp and not hrp.Anchored then hrp.Velocity = Vector3.new(0, math.max(hrp.Velocity.Y, -50), 0) end end)

loadPoints()

