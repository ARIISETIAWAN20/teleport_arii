-- ✅ Teleport GUI "Arii" - Versi Final Ketinggian (Fix Speed)
-- Developer: AriiSetiawan

if not (writefile and readfile and isfile) then
	getgenv().writefile = function() end
	getgenv().readfile = function() return "{}" end
	getgenv().isfile = function() return false end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local filename = "ketinggian_arii.json"
local autoTeleport = true
local delayTime = 8
local pointData = {tinggi = nil, rendah = nil}

-- Blokir staff
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

local function savePoints()
	pcall(function()
		writefile(filename, HttpService:JSONEncode(pointData))
	end)
end

local function loadPoints()
	if isfile(filename) then
		local success, data = pcall(function()
			return HttpService:JSONDecode(readfile(filename))
		end)
		if success and type(data) == "table" then
			pointData = data
		end
	end
end

local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local function teleportY(yLevel)
	local hrp = getHRP()
	local char = player.Character
	if char and hrp then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		hrp.Anchored = true
		hrp.Velocity = Vector3.zero
		if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
		wait(0.05)
		char:PivotTo(CFrame.new(hrp.Position.X, yLevel + 3, hrp.Position.Z))
		wait(0.05)
		hrp.Anchored = false
		if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
	end
end

-- GUI
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

createButton("🚀 Ke Tinggi", 5, function() if pointData.tinggi then teleportY(pointData.tinggi) end end)
createButton("🚀 Ke Rendah", 28, function() if pointData.rendah then teleportY(pointData.rendah) end end)
createButton("📌 Set Tinggi", 51, function()
	pointData.tinggi = getHRP().Position.Y
	savePoints()
end)
createButton("📌 Set Rendah", 74, function()
	pointData.rendah = getHRP().Position.Y
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

local autoBtn = createButton("⏹ Stop Auto Teleport", 120, function()
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
		if autoTeleport and pointData.tinggi and pointData.rendah then
			teleportY(pointData.tinggi)
			wait(delayTime)
			teleportY(pointData.rendah)
			wait(delayTime)
		end
	end
end)

-- Anti AFK
for _,v in pairs(getconnections(player.Idled)) do v:Disable() end

-- Anti jatuh terlalu cepat (fix tidak lambat)
RunService.Stepped:Connect(function()
	local hrp = getHRP()
	if hrp and not hrp.Anchored and hrp.Velocity.Y < -200 then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, -50, hrp.Velocity.Z)
	end
end)

-- Muat data awal
loadPoints()

-- Minimize
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	contentFrame.Visible = not minimized
	minimizeButton.Text = minimized and "+" or "-"
end)

-- Perbaiki state Humanoid jika stuck
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Physics then
			char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end)
end)