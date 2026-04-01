-- [[ DEVELOPERS: CODEX & CHRIXUS ]]
-- [[ STATUS: 100% STABLE | MANUAL KEYS | 2026 ]]

task.wait(0.5)

-- [[ 🛡️ SERVICIOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- [[ 👤 REFERENCIAS ]]
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 LISTA DE 25 KEYS (EDICIÓN MANUAL) ]]
local MANUAL_KEYS = {
    "CHKEY-2a7d9f3b1c", "CHKEY-5g1h4j6k8l", "CHKEY-9m2n0p5q3r", "CHKEY-4s6t8u1v7w",
    "CHKEY-3x5y9z2a4b", "CHKEY-7c1d3e6f8g", "CHKEY-2h5i7j9k1l", "CHKEY-6m8n3p0q2r",
    "CHKEY-1s4t6u9v3w", "CHKEY-5x2y7z4a6b", "CHKEY-8c3d5e1f9g", "CHKEY-4h9i2j5k7l",
    "CHKEY-7m1n6p8q4r", "CHKEY-3s5t9u2v6w", "CHKEY-6x8y3z1a5b", "CHKEY-9c2d7e4f1g",
    "CHKEY-5h3i8j2k6l", "CHKEY-2m7n4p1q9r", "CHKEY-8s1t5u7v3w", "CHKEY-4x6y2z9a3b",
    "CHKEY-1c9d4e7f2g", "CHKEY-6h7i1j8k4l", "CHKEY-3m5n9p2q6r", "CHKEY-7s3t8u4v9w",
    "CHKEY-2x9y5z6a8b"
}

-- [[ ⚙️ CONFIGURACIÓN ]]
local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, KillAura = false, Hitbox = false,
        ESP_Murd = false, ESP_Sheriff = false, ESP_Inno = false, 
        Traces = false, FullBright = false
    },
    Values = {
        Speed = 50, FOV = 85, Smooth = 0.11,
        HitboxSize = 8, AuraRange = 45,
        LastSheriffPos = nil, GunPart = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 30, 30),
        Sher = Color3.fromRGB(0, 160, 255),
        Inno = Color3.fromRGB(50, 255, 50),
        Accent = Color3.fromRGB(0, 210, 255),
        Bg = Color3.fromRGB(8, 8, 15)
    }
}

-- [[ 🛰️ NOTIFICACIONES SUPREME ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg); frame.Size = UDim2.new(0, 260, 0, 75); frame.Position = UDim2.new(1, 10, 0.1, 0); frame.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", frame); Instance.new("UIStroke", frame).Color = color
    local tl = Instance.new("TextLabel", frame); tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1; tl.TextSize = 14
    local dl = Instance.new("TextLabel", frame); dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = Enum.Font.Gotham; dl.BackgroundTransparency = 1; dl.TextSize = 12
    frame:TweenPosition(UDim2.new(1, -270, 0.1, 0), "Out", "Back", 0.5)
    task.delay(3, function() if frame then frame:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.5); task.wait(0.6); sg:Destroy() end end)
end

-- [[ 👁️ ESP ENGINE ]]
local active_esp = {}
local function GetRole(p)
    if not p or not p.Character then return "Inno" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murd" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sher" end
    return "Inno"
end

local function ApplyESP(p)
    if active_esp[p] then return end
    local high = Instance.new("Highlight", CoreGui)
    local line = Drawing.new("Line"); line.Thickness = 2; line.Transparency = 1
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if p and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p); local col = Config.Colors[role]
            high.Enabled = Config.Toggles["ESP_"..role]; high.Adornee = p.Character; high.FillColor = col
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis then
                line.Visible = true; line.Color = col; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
            else line.Visible = false end
        else
            high:Destroy(); line:Remove(); if conn then conn:Disconnect() end; active_esp[p] = nil
        end
    end)
    active_esp[p] = {H = high, L = line, C = conn}
end

-- [[ ⚔️ COMBAT ENGINE ]]
local function InitCombat()
    -- NOCLIP
    RunService.Stepped:Connect(function()
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)

    -- KILL AURA (45 STUDS)
    RunService.Stepped:Connect(function()
        if Config.Toggles.KillAura and GetRole(lp) == "Murd" and (lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")) then
            local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < Config.Values.AuraRange then
                        firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 0)
                        firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 1)
                    end
                end
            end
        end
    end)

    -- MAIN LOOP (AIMBOT + HITBOX)
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart; local role = GetRole(p)
                
                -- AIMBOT
                if role == "Murd" and Config.Toggles.Aimbot then
                    local targetPos, cameraPos = hrp.Position, camera.CFrame.Position
                    if (targetPos - cameraPos).Magnitude > 0.5 then
                        camera.CFrame = camera.CFrame:Lerp(CFrame.new(cameraPos, targetPos), Config.Values.Smooth)
                    end
                end

                -- HITBOX ASESINO (ROJO NEON)
                if role == "Murd" and Config.Toggles.Hitbox then
                    hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                    hrp.Transparency = 0.7; hrp.Color = Color3.new(1, 0, 0); hrp.Material = Enum.Material.Neon; hrp.CanCollide = false; hrp.Massless = true    
                else
                    if hrp.Size ~= Vector3.new(2, 2, 1) then hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.Material = Enum.Material.Plastic end
                end
                if role == "Sher" then Config.Values.LastSheriffPos = hrp.CFrame end
            end
        end
        -- SPEED & FOV
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
        camera.FieldOfView = Config.Values.FOV
        local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("GunPart") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop"))
        Config.Values.GunPart = gun
    end)
end

-- [[ 🚀 INFINITY JUMP (FIXED) ]]
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- [[ 🏙️ MENU ELITE ]]
local function CreateUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "Flourite_V10"
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 450, 0, 320); main.Position = UDim2.new(0.5, -225, 0.5, -160); main.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Config.Colors.Accent
    
    local bar = Instance.new("Frame", main); bar.Size = UDim2.new(0, 120, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(15, 15, 25); Instance.new("UICorner", bar)
    local container = Instance.new("Frame", main); container.Position = UDim2.new(0, 130, 0, 40); container.Size = UDim2.new(1, -140, 1, -50); container.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", container); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0; Instance.new("UIListLayout", f).Padding = UDim.new(0, 5)
        local b = Instance.new("TextButton", bar); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.8; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 12; Instance.new("UIListLayout", bar)
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end)
        return f
    end

    local t1 = Tab("GENERAL⚙️"); t1.Visible = true; local t2 = Tab("VISUALS👾"); local t3 = Tab("COMBAT⚔️"); local t4 = Tab("TELEPORTS🔮")

    local function Toggle(p, text, key)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 35); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]; b.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(30, 30, 50)
        end)
    end

    Toggle(t1, "SPEED HACK", "WalkSpeed"); Toggle(t1, "NOCLIP", "Noclip"); Toggle(t1, "INF JUMP", "InfJump")
    Toggle(t2, "ESP MURDER", "ESP_Murd"); Toggle(t2, "ESP SHERIFF", "ESP_Sheriff"); Toggle(t2, "TRACERS", "Traces")
    Toggle(t3, "KILL AURA", "KillAura"); Toggle(t3, "AIMBOT", "Aimbot"); Toggle(t3, "HITBOX", "Hitbox")

    local function Btn(p, text, func)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 35); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(50, 50, 80); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(func)
    end
    Btn(t4, "TP TO GUN", function() if Config.Values.GunPart then lp.Character.HumanoidRootPart.CFrame = Config.Values.GunPart.CFrame; Notify("TELEPORT", "Cerca del arma", Config.Colors.Accent) end end)
    Btn(t4, "TP TO SHERIFF", function() if Config.Values.LastSheriffPos then lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos; Notify("TELEPORT", "Cerca del Sheriff", Config.Colors.Sher) end end)

    Notify("BIENVENIDO USUARIO", "Script Cargado✅", Config.Colors.Accent)
end

-- [[ 🔑 SISTEMA DE LLAVES MANUAL ]]
local function RunKeys()
    local kg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", kg); f.Size = UDim2.new(0, 320, 0, 220); f.Position = UDim2.new(0.5, -160, 0.5, -110); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Config.Colors.Accent
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8, 0, 0, 40); box.Position = UDim2.new(0.1, 0, 0.3, 0); box.PlaceholderText = "INGRESA TU LLAVE"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(20, 20, 30); Instance.new("UICorner", box)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8, 0, 0, 40); btn.Position = UDim2.new(0.1, 0, 0.6, 0); btn.Text = "LOGIN"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if table.find(MANUAL_KEYS, box.Text) then
            kg:Destroy(); CreateUI(); InitCombat()
            for _, p in pairs(Players:GetPlayers()) do if p ~= lp then ApplyESP(p) end end
            Players.PlayerAdded:Connect(function(p) task.wait(1); ApplyESP(p) end)
        else
            box.Text = ""; box.PlaceholderText = "LLAVE INCORRECTA"
        end
    end)
end

RunKeys()
