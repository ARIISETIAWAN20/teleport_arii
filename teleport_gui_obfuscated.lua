-- ✅ Teleport GUI "Arii" versi UI CLIMB AND JUMP
-- Fitur: Teleport 2 titik, auto teleport, delay, anti cheat, anti staff, minimize

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
local PlayerGui = player:WaitForChild("PlayerGui")
local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8
local currentTarget = 1

-- 🔒 Blacklist Anti Staff
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

-- 🔧 Helper & Core
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

-- 📦 UI (gaya CLIMB AND JUMP)
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "CLIMB_JUMP_UI"
Gui.ResetOnSpawn = false

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 170, 0, 170)
Frame.Position = UDim2.new(0, 10, 0.5, -85)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Text = "CLIMB AND JUMP"
Title.Size = UDim2.new(1, 0, 0, 26)
Title.BackgroundColor3 = Color3.fromRGB(70, 40, 120)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13

local MinBtn = Instance.new("TextButton", Frame)
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 28, 0, 26)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local function makeBtn(txt, y, color)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -16, 0, 26)
    btn.Position = UDim2.new(0, 8, 0, y)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = txt
    return btn
end

local AutoBtn = makeBtn("🔁 Auto Teleport [OFF]", 32, Color3.fromRGB(50, 90, 160))
local Point1Btn = makeBtn("📍 Set Point 1", 62, Color3.fromRGB(100, 60, 180))
local Point2Btn = makeBtn("📍 Set Point 2", 92, Color3.fromRGB(140, 60, 200))

local DelayBox = Instance.new("TextBox", Frame)
DelayBox.Size = UDim2.new(1, -16, 0, 26)
DelayBox.Position = UDim2.new(0, 8, 0, 122)
DelayBox.PlaceholderText = "⏱ Delay (1-10)"
DelayBox.ClearTextOnFocus = false
DelayBox.Text = tostring(delayTime)
DelayBox.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.Font = Enum.Font.Gotham
DelayBox.TextSize = 13

-- 🔘 Fungsi Tombol
AutoBtn.MouseButton1Click:Connect(function()
    autoTeleport = not autoTeleport
    AutoBtn.Text = autoTeleport and "⏹ Stop Auto Teleport" or "🔁 Auto Teleport [OFF]"
end)

Point1Btn.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    teleportPoints.point1 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)

Point2Btn.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    teleportPoints.point2 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)

DelayBox.FocusLost:Connect(function()
    local val = tonumber(DelayBox.Text)
    if val and val >= 1 then delayTime = val end
end)

-- 🔁 Auto Teleport Loop
spawn(function()
    while wait(1) do
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            if currentTarget == 1 then
                teleportTo(teleportPoints.point1)
                currentTarget = 2
            else
                teleportTo(teleportPoints.point2)
                currentTarget = 1
            end
            wait(delayTime)
        end
    end
end)

-- 🔘 Minimize Logic
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(Frame:GetChildren()) do
        if (v:IsA("TextButton") or v:IsA("TextBox")) and v ~= MinBtn then
            v.Visible = not minimized
        end
    end
    Frame.Size = minimized and UDim2.new(0, 140, 0, 26) or UDim2.new(0, 170, 0, 170)
end)

-- 🛡 Anti Idle + Reset Physics
for _,v in pairs(getconnections(player.Idled)) do v:Disable() end
RunService.Stepped:Connect(function()
    local hrp = getHRP()
    if hrp and not hrp.Anchored then
        hrp.Velocity = Vector3.new(0, math.max(hrp.Velocity.Y, -50), 0)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end)

-- ⏬ Load
loadPoints()