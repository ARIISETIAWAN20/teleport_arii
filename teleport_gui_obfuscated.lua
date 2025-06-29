-- ✅ Arii Teleport GUI - Final + Mild Protected (Anti Edit)

local fenv = getfenv() local enc = function(str) return string.reverse(string.gsub(str, ".", function(c) return string.char(string.byte(c) + 1) end)) end

local dec = function(str) return string.gsub(string.reverse(str), ".", function(c) return string.char(string.byte(c) - 1) end) end

local function protect(name, value) local _name = enc(name) rawset(fenv, dec(_name), value) end

-- Proteksi Fungsi File (Delta Friendly) pcall(function() if not (writefile and readfile and isfile) then protect("writefile", nil) protect("readfile", function() return "{}" end) protect("isfile", function() return false end) end end)

-- Loadstring Script Asli (disisipkan aman di bawah ini) local main = [[ -- ✅ Teleport GUI "Arii" - Final (Teleport Cepat, UI Rapi, Auto Save, Proteksi Lengkap)

-- Proteksi Fungsi File (Delta Friendly) pcall(function() if not (writefile and readfile and isfile) then getgenv().writefile = nil getgenv().readfile = function() return "{}" end getgenv().isfile = function() return false end end end)

local Players = game:GetService("Players") local player = Players.LocalPlayer local HttpService = game:GetService("HttpService") local RunService = game:GetService("RunService") local StarterGui = game:GetService("StarterGui") local filename = "teleport_points.json" local teleportPoints = {point1 = nil, point2 = nil, speed1 = 1.5, speed2 = 1.5} local autoTeleport = false local delayTime = 8

local blacklist = { ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true, ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true, ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true, ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true, ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true }

local function deepScan() for _, plr in pairs(Players:GetPlayers()) do if blacklist[plr.Name] then player:Kick("Staff terdeteksi") end end end deepScan() Players.PlayerAdded:Connect(function(p) wait(1) if blacklist[p.Name] then StarterGui:SetCore("SendNotification", {Title = "Auto Leave", Text = "Staff Terdeteksi", Duration = 1}) wait(1) player:Kick("Staff terdeteksi") end end)

pcall(function() local allowedHWID = "HWID_ARI_123" local allowedUsers = { ["supa_loi"] = true, ["Devrenzx"] = true } local function getHWID() local id = "UNKNOWN" pcall(function() id = tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end) return id end if not allowedUsers[player.Name] and getHWID() ~= allowedHWID then player:Kick("Perangkat tidak diizinkan (HWID Lock)") end end)

pcall(function() local mt = getrawmetatable(game) setreadonly(mt, false) local old = mt.__namecall mt.__namecall = newcclosure(function(self, ...) if tostring(self):lower():find("log") or tostring(self):lower():find("report") then return nil end return old(self, ...) end) end)

local function loadPoints() if isfile and isfile(filename) then local success, data = pcall(function() return HttpService:JSONDecode(readfile(filename)) end) if success and type(data) == "table" then teleportPoints = data end end end

local function savePoints() if writefile then pcall(function() writefile(filename, HttpService:JSONEncode(teleportPoints)) end) end end

local function getHRP() local char = player.Character or player.CharacterAdded:Wait() return char:WaitForChild("HumanoidRootPart") end

local function effectFlash() local flash = Instance.new("Part") flash.Anchored = true flash.CanCollide = false flash.Size = Vector3.new(5, 5, 5) flash.Shape = Enum.PartType.Ball flash.Material = Enum.Material.Neon flash.BrickColor = BrickColor.new

    
