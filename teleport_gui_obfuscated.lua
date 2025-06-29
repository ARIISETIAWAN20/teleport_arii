-- ✅ Teleport GUI "Arii" - FINAL DELTA SAFE v2.0
-- Kompatibel Delta Executor | Lengkap Fitur: GUI + Proteksi + Efek Petir + Deep Scan + Auto Save + Auto Teleport

-- Proteksi Fungsi File (Delta Friendly)
pcall(function()
    if not (writefile and readfile and isfile) then
        getgenv().writefile = function() end
        getgenv().readfile = function() return "{}" end
        getgenv().isfile = function() return false end
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local filename = "teleport_points.json"
local teleportPoints = { point1 = nil, point2 = nil, last = nil }
local autoTeleport = false
local delayTime = 8

-- HWID Lock & Whitelist
local allowedHWIDs = { ["abc123"] = true, ["xyz789"] = true }
local whitelistUser = { ["supa_loi"] = true, ["Devrenzx"] = true }
pcall(function()
    local hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId()):gsub("-", ""):lower()
    if not allowedHWIDs[hwid] and not whitelistUser[player.Name] then
        StarterGui:SetCore("SendNotification", { Title = "Blokir Akses", Text = "HWID tidak dikenali.", Duration = 5 })
        task.wait(1.5)
        player:Kick("HWID tidak terdaftar.")
    end
end)

-- Deep Scan Staff / Admin
local blacklist = { ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true, ["legendxlenn"] = true, ["VicSimon8"] = true }
local suspiciousKeywords = {"mod", "staff", "admin", "check", "spectate", "inspect"}
local function isSuspiciousUser(p)
    local dn, un = (p.DisplayName or ""):lower(), p.Name:lower()
    for _, word in ipairs(suspiciousKeywords) do if dn:find(word) or un:find(word) then return true end end
    return p.AccountAge > 200 and p.MembershipType == Enum.MembershipType.Premium
end
local function scanPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and (blacklist[p.Name] or isSuspiciousUser(p)) then
            StarterGui:SetCore("SendNotification", { Title = "Deep Scan", Text = "Staff/Admin terdeteksi.", Duration = 4 })
            task.wait(1)
            player:Kick("Deep Scan: Staff/Observer Detected")
        end
    end
end
Players.PlayerAdded:Connect(scanPlayers)
Players.PlayerRemoving:Connect(scanPlayers)
task.spawn(function() while true do scanPlayers() task.wait(10) end end)

-- Bypass Anti Cheat
pcall(function()
    Workspace.DescendantAdded:Connect(function(desc)
        if desc:IsA("Camera") or desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
            local name = desc.Name:lower()
            if name:find("spectate") or name:find("spy") or name:find("view") then
                desc:Destroy()
                StarterGui:SetCore("SendNotification", {Title="Bypass", Text="Observer diblokir", Duration=4})
            end
        end
    end)
end)

pcall(function()
    local function blockCore(obj)
        local n = obj.Name:lower()
        if n:find("anti") or n:find("cheat") or n:find("admin") or n:find("track") then
            obj:Destroy()
            StarterGui:SetCore("SendNotification", {Title="Bypass", Text="Anti-Cheat module diblokir", Duration=3})
        end
    end
    for _, v in ipairs(CoreGui:GetChildren()) do blockCore(v) end
    for _, v in ipairs(ReplicatedStorage:GetChildren()) do blockCore(v) end
    CoreGui.ChildAdded:Connect(blockCore)
    ReplicatedStorage.ChildAdded:Connect(blockCore)
end)

pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod():lower()
        local name = tostring(self):lower()
        if name:find("report") or name:find("log") or name:find("check") then return nil end
        return old(self, ...)
    end)
end)

-- Anti AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end)

-- Teleport & Save
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function savePoints()
    pcall(function() writefile(filename, HttpService:JSONEncode(teleportPoints)) end)
end

local function loadPoints()
    if isfile(filename) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(filename)) end)
        if ok and type(data) == "table" then teleportPoints = data end
    end
end

local function saveLastPosition()
    local hrp = getHRP()
    teleportPoints.last = { x = hrp.Position.X, y = hrp.Position.Y, z = hrp.Position.Z }
    savePoints()
end

local function teleportTo(point)
    if point then
        saveLastPosition()
        local hrp = getHRP()
        hrp.Anchored = true
        hrp.Velocity = Vector3.zero
        task.wait(0.05)
        hrp.Parent:PivotTo(CFrame.new(point.x, point.y + 3, point.z))
        task.wait(0.05)
        hrp.Anchored = false
    end
end

-- Efek Petir
local function lightningEffect(guiButton)
    local absPos = guiButton.AbsolutePosition
    local absSize = guiButton.AbsoluteSize
    local center = Vector3.new(absPos.X + absSize.X/2, absPos.Y, 0)
    local part = Instance.new("Part")
    part.Anchored = true part.CanCollide = false part.Size = Vector3.new(1, 20, 1)
    part.BrickColor = BrickColor.new("Institutional white")
    part.Material = Enum.Material.Neon part.Transparency = 0
    part.CFrame = CFrame.new(Vector3.new(0, 10, 0)) part.Parent = workspace part.Name = "LightningEffect"
    local cam = workspace.CurrentCamera
    local unitRay = cam:ViewportPointToRay(center.X, center.Y)
    part.CFrame = CFrame.new(unitRay.Origin + unitRay.Direction * 10)
    local tween = TweenService:Create(part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1, Size = Vector3.new(0.5, 40, 0.5)})
    tween:Play()
    tween.Completed:Connect(function() part:Destroy() end)
end

-- Proteksi Jatuh + Auto Simpan
RunService.Stepped:Connect(function()
    local hrp = getHRP()
    if hrp and not hrp.Anchored then
        hrp.Velocity = Vector3.new(0, math.max(hrp.Velocity.Y, -50), 0)
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        local hrp = getHRP()
        local pos = hrp.Position
        if teleportPoints.point1 and (Vector3.new(teleportPoints.point1.x, teleportPoints.point1.y, teleportPoints.point1.z) - pos).Magnitude > 5 then
            teleportPoints.point1 = {x = pos.X, y = pos.Y, z = pos.Z} savePoints()
        end
        if teleportPoints.point2 and (Vector3.new(teleportPoints.point2.x, teleportPoints.point2.y, teleportPoints.point2.z) - pos).Magnitude > 5 then
            teleportPoints.point2 = {x = pos.X, y = pos.Y, z = pos.Z} savePoints()
        end
    end
end)

-- Auto Teleport Loop
task.spawn(function()
    while true do
        task.wait(1)
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            task.wait(delayTime)
            teleportTo(teleportPoints.point2)
        end
    end
end)

-- Simpan Saat Keluar
game:BindToClose(function() saveLastPosition() end)
loadPoints()

-- GUI akan diimpor ke dokumen setelah ini jika belum lengkap
StarterGui:SetCore("SendNotification", {
    Title = "Teleport GUI Arii Final",
    Text = "✅ Semua sistem terpasang dan aktif",
    Duration = 4
})
