local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
        return string.char(tonumber(r,2))
    end))
end

-- ✅ Teleport GUI decode("QXJpaQ==") - Versi Delta Mobile Safe + Tween Fast Teleport

-- Proteksi Fungsi File (Delta Friendly)
pcall(function()
    if not (writefile and readfile and isfile) then
        getgenv().writefile = nil
        getgenv().readfile = function() return "{}" end
        getgenv().isfile = function() return false end
    end
end)

local PL = game:GetService("PL")
local p = PL.LocalPlayer
local HS = game:GetService("HS")
local RS = game:GetService("RS")
local SG = game:GetService("SG")
local TS = game:GetService("TS")

local filename = "teleport_points.json"
local tp = {point1 = nil, point2 = nil}
local auto = false
local dt = 8

-- Blacklist Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}
local function deepScan()
    for _, plr in pairs(PL:GetPlayers()) do
        if blacklist[plr.Name] then
            p:Kick("Staff terdeteksi")
        end
    end
end
deepScan()
PL.PlayerAdded:Connect(function(p)
    wait(1)
    if blacklist[p.Name] then
        SG:SetCore("SendNotification", {Title = decode("QXV0byBMZWF2ZQ=="), Text = decode("U3RhZmYgVGVyZGV0ZWtzaQ=="), Duration = 1})
        wait(1)
        p:Kick("Staff terdeteksi")
    end
end)

-- HWID Lock
pcall(function()
    local allowedHWID = decode("SFdJRF9BUklfMTIz")
    local allowedUsers = {["supa_loi"] = true, ["Devrenzx"] = true}
    local function getHWID()
        local id = "UNKNOWN"
        pcall(function()
            id = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        end)
        return id
    end
    if not allowedUsers[p.Name] and getHWID() ~= allowedHWID then
        p:Kick(decode("UGVyYW5na2F0IHRpZGFrIGRpaXppbmthbiAoSFdJRCBMb2NrKQ=="))
    end
end)

-- Anti Remote Log/Report
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if tostring(self):lower():find("log") or tostring(self):lower():find("report") then
            return nil
        end
        return old(self, ...)
    end)
end)

-- Load/Save Point
local function lP()
    if isfile and isfile(filename) then
        local success, data = pcall(function()
            return HS:JSONDecode(readfile(filename))
        end)
        if success and type(data) == "table" then
            tp = data
        end
    end
end
local function sP()
    if writefile then
        pcall(function()
            writefile(filename, HS:JSONEncode(tp))
        end)
    end
end

local function gH()
    local char = p.Character or p.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- ✅ TELEPORT DENGAN TWEEN (FAST)
local function a9(point)
    if point then
        local char = p.Character or p.CharacterAdded:Wait()
        local hrp = gH()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end

        hrp.Anchored = true
        local targetCFrame = CFrame.new(point.x, point.y + 3, point.z)
        local tween = TS:Create(hrp, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()

        hrp.Anchored = false
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
    end
end

-- GUI Section and rest continues...
