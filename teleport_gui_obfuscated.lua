-- ✅ Teleport GUI "Sc Project" FINAL - Delta Mobile Safe Version

if not (writefile and readfile and isfile) then
 getgenv().writefile = function() end
 getgenv().readfile = function() return "{}" end
 getgenv().isfile = function() return false end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8

-- 🛡️ Staff Blacklist
local blacklist = {
 ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
 ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
 ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
 ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
 ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

-- 🔎 Deep Scan Staff
coroutine.wrap(function()
 while true do
  for _, v in pairs(getnilinstances()) do
   if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
    local name = tostring(v):lower()
    if name:find("kick") or name:find("ban") or name:find("spectate") then
     player:Kick("Staff memata-matai terdeteksi.")
    end
   end
  end
  task.wait(3)
 end
end)()

-- Cek staff saat join
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

-- Anti Cheat Ringan
pcall(function()
 for _,v in pairs(getnilinstances()) do
  if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
   v:Destroy()
  end
 end
end)

-- Anti AFK
player.Idled:Connect(function()
 VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
 task.wait(1)
 VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Load dan Save Point
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

-- Auto Save Posisi
coroutine.wrap(function()
 while true do
  local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
  if hrp then
   local pos = hrp.Position
   for i = 1, 2 do
    local key = "point"..i
    local point = teleportPoints[key]
    if point then
     local pVec = Vector3.new(point.x, point.y, point.z)
     if (pos - pVec).Magnitude > 10 then
      teleportPoints[key] = {x=pos.X, y=pos.Y, z=pos.Z}
      savePoints()
     end
    end
   end
  end
  task.wait(3)
 end
end)()

-- Fungsi Teleport (Fix)
local function getHRP()
 local char = player.Character or player.CharacterAdded:Wait()
 return char:WaitForChild("HumanoidRootPart")
end

local function teleportTo(point)
 if not point then return end
 local char = player.Character or player.CharacterAdded:Wait()
 local hrp = getHRP()
 local success = pcall(function()
  hrp.Anchored = true
  hrp.Velocity = Vector3.zero
  local humanoid = char:FindFirstChildOfClass("Humanoid")
  if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
  task.wait(0.1)
  char:PivotTo(CFrame.new(point.x, point.y + 3, point.z))
  task.wait(0.1)
  hrp.Anchored = false
  if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
 end)
 if not success then warn("Gagal teleport") end
end

-- UI Builder
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ScProjectGui"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 160, 0, 198)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 16)
title.Text = "Sc Project"
title.BackgroundColor3 = Color3.fromRGB(45,45,45)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.BorderSizePixel = 0

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0,14,0,14)
minimize.Position = UDim2.new(1,-14,0,0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.BorderSizePixel = 0

local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -16)
content.Position = UDim2.new(0, 0, 0, 16)
content.BackgroundTransparency = 1

local function createButton(text, y, callback)
 local btn = Instance.new("TextButton", content)
 btn.Size = UDim2.new(1, -10, 0, 18)
 btn.Position = UDim2.new(0, 5, 0, y)
 btn.Text = text
 btn.Font = Enum.Font.SourceSansBold
 btn.TextSize = 13
 btn.BackgroundColor3 = Color3.fromRGB(80,80,160)
 btn.TextColor3 = Color3.fromRGB(255,255,255)
 btn.BorderSizePixel = 0
 btn.MouseButton1Click:Connect(callback)
 return btn
end

createButton("🚀 Teleport ke Point 1", 5, function() teleportTo(teleportPoints.point1) end)
createButton("🚀 Teleport ke Point 2", 28, function() teleportTo(teleportPoints.point2) end)
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

local delayBox = Instance.new("TextBox", content)
delayBox.Size = UDim2.new(1, -10, 0, 18)
delayBox.Position = UDim2.new(0, 5, 0, 97)
delayBox.PlaceholderText = "Delay detik"
delayBox.Text = tostring(delayTime)
delayBox.BackgroundColor3 = Color3.fromRGB(90,90,90)
delayBox.TextColor3 = Color3.fromRGB(255,255,255)
delayBox.BorderSizePixel = 0
delayBox.ClearTextOnFocus = false
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

-- Loop Auto Teleport
coroutine.wrap(function()
 while true do task.wait(1)
  if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
   teleportTo(teleportPoints.point1)
   task.wait(delayTime)
   teleportTo(teleportPoints.point2)
  end
 end
end)()

-- Minimize Toggle
local minimized = false
minimize.MouseButton1Click:Connect(function()
 minimized = not minimized
 content.Visible = not minimized
 minimize.Text = minimized and "+" or "-"
end)

loadPoints()
