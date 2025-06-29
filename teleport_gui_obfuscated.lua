-- 🔐 Obfuscated Arii 
local function protect()
    local s = {
        ["teleportPoints"] = {p1=nil,p2=nil},
        ["auto"] = false,
        ["delay"] = 8,
        ["blacklist"] = {
            ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
            ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
            ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
            ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
            ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
        },
        ["f"] = "teleport_points.json",
        ["allowedHWID"] = "HWID_ARI_123",
        ["allowedUsers"] = { ["supa_loi"] = true, ["Devrenzx"] = true },
        ["guiName"] = "TeleportGUI"
    }

    local srv = setmetatable({}, {__index = function(_, k) return game:GetService(k) end})
    local plr = srv.Players.LocalPlayer

    pcall(function()
        if not (writefile and readfile and isfile) then
            getgenv().writefile = nil
            getgenv().readfile = function() return "{}" end
            getgenv().isfile = function() return false end
        end
    end)

    local function hashCheck()
        for _,p in pairs(srv.Players:GetPlayers()) do
            if s.blacklist[p.Name] then
                plr:Kick("Staff Terdeteksi")
            end
        end
    end

    hashCheck()
    srv.Players.PlayerAdded:Connect(function(p)
        task.wait(1)
        if s.blacklist[p.Name] then
            srv.StarterGui:SetCore("SendNotification", {Title = "Auto Leave", Text = "Staff Terdeteksi", Duration = 1})
            task.wait(1)
            plr:Kick("Staff Terdeteksi")
        end
    end)

    pcall(function()
        local id = "UNK"
        pcall(function()
            id = tostring(srv.RbxAnalyticsService:GetClientId())
        end)
        if not s.allowedUsers[plr.Name] and id ~= s.allowedHWID then
            plr:Kick("Perangkat tidak diizinkan")
        end
    end)

    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self,...)
            local t = tostring(self):lower()
            if t:find("log") or t:find("report") then return nil end
            return old(self,...)
        end)
    end)

    local function getHRP()
        local c = plr.Character or plr.CharacterAdded:Wait()
        return c:WaitForChild("HumanoidRootPart")
    end

    local function tele(p)
        if not p then return end
        local c = plr.Character or plr.CharacterAdded:Wait()
        local h = getHRP()
        h.Anchored = true
        h.Velocity = Vector3.zero
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        task.wait(0.05)
        c:PivotTo(CFrame.new(p.x,p.y+3,p.z))
        task.wait(0.05)
        h.Anchored = false
        if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
    end

    local function load()
        if isfile and isfile(s.f) then
            local ok, data = pcall(function()
                return srv.HttpService:JSONDecode(readfile(s.f))
            end)
            if ok and type(data)=="table" then s.teleportPoints = data end
        end
    end

    local function save()
        if writefile then
            pcall(function()
                writefile(s.f, srv.HttpService:JSONEncode(s.teleportPoints))
            end)
        end
    end

    local gui = Instance.new("ScreenGui", pcall(function() return game.CoreGui end) and game.CoreGui or plr:WaitForChild("PlayerGui"))
    gui.Name = s.guiName

    local f = Instance.new("Frame", gui)
    f.Size = UDim2.new(0, 145, 0, 180)
    f.Position = UDim2.new(0.05,0,0.2,0)
    f.BackgroundColor3 = Color3.fromRGB(30,30,30)
    f.BorderSizePixel = 0
    f.Active = true
    f.Draggable = true

    local title = Instance.new("TextLabel", f)
    title.Size = UDim2.new(1, 0, 0, 16)
    title.Text = "Arii"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.BackgroundColor3 = Color3.fromRGB(45,45,45)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 14

    local minBtn = Instance.new("TextButton", f)
    minBtn.Size = UDim2.new(0, 14, 0, 14)
    minBtn.Position = UDim2.new(1, -14, 0, 0)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

    local content = Instance.new("Frame", f)
    content.Size = UDim2.new(1,0,1,-16)
    content.Position = UDim2.new(0,0,0,16)
    content.BackgroundTransparency = 1

    local function btn(txt,y,cb)
        local b = Instance.new("TextButton", content)
        b.Size = UDim2.new(1,-10,0,18)
        b.Position = UDim2.new(0,5,0,y)
        b.BackgroundColor3 = Color3.fromRGB(80,80,160)
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 13
        b.Text = txt
        b.MouseButton1Click:Connect(cb)
    end

    btn("🚀 Teleport to Point 1", 5, function() tele(s.teleportPoints.p1) end)
    btn("🚀 Teleport to Point 2", 28, function() tele(s.teleportPoints.p2) end)
    btn("📌 Set Point 1", 51, function()
        local h = getHRP()
        s.teleportPoints.p1 = {x=h.Position.X,y=h.Position.Y,z=h.Position.Z}
        save()
    end)
    btn("📌 Set Point 2", 74, function()
        local h = getHRP()
        s.teleportPoints.p2 = {x=h.Position.X,y=h.Position.Y,z=h.Position.Z}
        save()
    end)

    local delayInput = Instance.new("TextBox", content)
    delayInput.Size = UDim2.new(1,-10,0,18)
    delayInput.Position = UDim2.new(0,5,0,97)
    delayInput.PlaceholderText = "Delay detik"
    delayInput.Text = tostring(s.delay)
    delayInput.BackgroundColor3 = Color3.fromRGB(90,90,90)
    delayInput.TextColor3 = Color3.fromRGB(255,255,255)
    delayInput.BorderSizePixel = 0
    delayInput.ClearTextOnFocus = false
    delayInput.FocusLost:Connect(function()
        local v = tonumber(delayInput.Text)
        if v and v > 0 then s.delay = v end
    end)

    local autoBtn
    autoBtn = btn("▶️ Start Auto Teleport", 120, function()
        s.auto = not s.auto
        autoBtn.Text = s.auto and "⏹ Stop Auto Teleport" or "▶️ Start Auto Teleport"
    end)

    btn("❌ OFF Auto Teleport", 143, function()
        s.auto = false
        autoBtn.Text = "▶️ Start Auto Teleport"
    end)

    local cr = Instance.new("TextLabel", f)
    cr.Size = UDim2.new(1,0,0,14)
    cr.Position = UDim2.new(0,0,1,-14)
    cr.BackgroundTransparency = 1
    cr.TextColor3 = Color3.fromRGB(180,180,180)
    cr.Font = Enum.Font.SourceSansItalic
    cr.TextSize = 11
    cr.Text = "By Ari"

    minBtn.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        minBtn.Text = content.Visible and "-" or "+"
    end)

    spawn(function()
        while task.wait(1) do
            if s.auto and s.teleportPoints.p1 and s.teleportPoints.p2 then
                tele(s.teleportPoints.p1)
                task.wait(s.delay)
                tele(s.teleportPoints.p2)
            end
        end
    end)

    for _,v in pairs(getconnections(plr.Idled)) do v:Disable() end

    srv.RunService.Stepped:Connect(function()
        local h = getHRP()
        if h and not h.Anchored and h.Position.Y < -100 then
            tele(s.teleportPoints.p1 or Vector3.new(0,50,0))
        end
    end)

    load()
end

protect()
