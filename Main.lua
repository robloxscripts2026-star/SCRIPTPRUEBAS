-- [[ 🌌 FLOURITE  V3.0🌌 ]]
-- [[ DEVELOPER:CODEX

task.wait(0.5)

-- [[ 🛡️ SERVICIOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 LISTA DE 25 KEYS ]]
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
        ESP_Murd = false, ESP_Sheriff = false, Traces = false
    },
    Values = {
        Speed = 50, FOV = 90, Smooth = 0.12,
        HitboxSize = 8, AuraRange = 45,
        LastSheriffPos = nil, GunPart = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 30, 30),
        Sher = Color3.fromRGB(0, 160, 255),
        Accent = Color3.fromRGB(0, 210, 255),
        Bg = Color3.fromRGB(12, 12, 20)
    }
}

-- [[ 🖱️ DRAGGABLE ENGINE (SOPORTE MÓVIL/PC) ]]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ 🛰️ NOTIFICACIONES ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 250, 0, 70); f.Position = UDim2.new(1, 10, 0.1, 0); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = color
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0.4, 0); t.Text = title; t.TextColor3 = color; t.Font = Enum.Font.GothamBold; t.BackgroundTransparency = 1
    local d = Instance.new("TextLabel", f); d.Size = UDim2.new(1, 0, 0.6, 0); d.Position = UDim2.new(0,0,0.4,0); d.Text = text; d.TextColor3 = Color3.new(1,1,1); d.Font = Enum.Font.Gotham; d.BackgroundTransparency = 1
    f:TweenPosition(UDim2.new(1, -260, 0.1, 0), "Out", "Back", 0.5)
    task.delay(3, function() if f then f:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.5); task.wait(0.6); sg:Destroy() end end)
end

-- [[ ⚔️ MOTORES: ESP / AURA / AIMBOT / HITBOX ]]
local function GetRole(p)
    if not p or not p.Character then return "Inno" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murd" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sher" end
    return "Inno"
end

local function InitMotors()
    -- KILL AURA 45 STUDS
    RunService.Stepped:Connect(function()
        if Config.Toggles.KillAura and GetRole(lp) == "Murd" then
            local k = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if k then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < Config.Values.AuraRange then
                            firetouchinterest(p.Character.HumanoidRootPart, k.Handle, 0)
                            firetouchinterest(p.Character.HumanoidRootPart, k.Handle, 1)
                        end
                    end
                end
            end
        end
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)

    -- AIMBOT & HITBOX ROJO NEON
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart; local role = GetRole(p)
                if role == "Murd" and Config.Toggles.Aimbot then
                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, hrp.Position), Config.Values.Smooth)
                end
                if role == "Murd" and Config.Toggles.Hitbox then
                    hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                    hrp.Color = Color3.new(1, 0, 0); hrp.Material = Enum.Material.Neon; hrp.Transparency = 0.6; hrp.Massless = true
                else
                    if hrp.Size ~= Vector3.new(2,2,1) then hrp.Size = Vector3.new(2,2,1); hrp.Material = Enum.Material.Plastic; hrp.Transparency = 1 end
                end
                if role == "Sher" then Config.Values.LastSheriffPos = hrp.CFrame end
            end
        end
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
        camera.FieldOfView = Config.Values.FOV
    end)
end

-- [[ 🚀 INF JUMP FIX ]]
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- [[ 🏙️ UI SYSTEM V10.5 ]]
local function CreateUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "CH-HUB MM2🪐"
    
    -- Botón Círculo Abierto (Movible)
    local Circle = Instance.new("ImageButton", sg); Circle.Size = UDim2.new(0, 60, 0, 60); Circle.Position = UDim2.new(0, 50, 0.5, -30); Circle.BackgroundColor3 = Config.Colors.Bg; Circle.Image = "rbxassetid://6031068433"; Circle.Visible = false; Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Circle).Color = Config.Colors.Accent; MakeDraggable(Circle)

    -- Menú Principal (Movible)
    local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 460, 0, 340); Main.Position = UDim2.new(0.5, -230, 0.5, -170); Main.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Config.Colors.Accent; MakeDraggable(Main)

    -- Botón "X" de Cierre
    local CloseX = Instance.new("TextButton", Main); CloseX.Size = UDim2.new(0, 35, 0, 35); CloseX.Position = UDim2.new(1, -40, 0, 5); CloseX.Text = "X"; CloseX.BackgroundColor3 = Color3.fromRGB(200, 0, 0); CloseX.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CloseX)
    CloseX.MouseButton1Click:Connect(function() Main.Visible = false; Circle.Visible = true; Notify("MENÚ", "Cerrado. Usa el círculo para abrir.", Config.Colors.Accent) end)
    Circle.MouseButton1Click:Connect(function() Main.Visible = true; Circle.Visible = false end)

    local bar = Instance.new("Frame", Main); bar.Size = UDim2.new(0, 130, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(15, 15, 25); Instance.new("UICorner", bar); Instance.new("UIListLayout", bar).Padding = UDim.new(0,2)
    local cont = Instance.new("Frame", Main); cont.Position = UDim2.new(0, 140, 0, 45); cont.Size = UDim2.new(1, -150, 1, -55); cont.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", cont); f.Size = UDim2.new(1,0,1,0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0; Instance.new("UIListLayout", f).Padding = UDim.new(0,5)
        local b = Instance.new("TextButton", bar); b.Size = UDim2.new(1,0,0,40); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.8; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
        b.MouseButton1Click:Connect(function() for _, v in pairs(cont:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end)
        return f
    end

    local t1 = Tab("GENERAL ⚙️"); t1.Visible = true; local t2 = Tab("VISUAL👾"); local t3 = Tab("COMBATE⚔️"); local t4 = Tab("TELEPORTS🔮")

    local function Toggle(p, text, key)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96,0,0,38); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]; b.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(30,30,45); b.TextColor3 = Config.Toggles[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    Toggle(t1, "SPEED HACK", "WalkSpeed"); Toggle(t1, "NOCLIP", "Noclip"); Toggle(t1, "INF JUMP", "InfJump")
    Toggle(t2, "ESP MURDER", "ESP_Murd"); Toggle(t2, "ESP SHERIFF", "ESP_Sheriff"); Toggle(t3, "KILL AURA", "KillAura"); Toggle(t3, "AIMBOT", "Aimbot"); Toggle(t3, "HITBOX", "Hitbox")

    local function Btn(p, text, func)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96,0,0,38); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(45,45,65); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(func)
    end
    Btn(t4, "TP GUN", function() local g = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("GunPart"); if g then lp.Character.HumanoidRootPart.CFrame = g.CFrame; Notify("TP", "funcion próximamente user", Config.Colors.Accent) end end)
    Btn(t4, "TP SHERIFF", function() if Config.Values.LastSheriffPos then lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos; Notify("TP", "Teletransportado al Sheriff", Config.Colors.Sher) end end)

    Notify("CH-HUB V3.0", "Bienvenido usuario. Script Listo✅.", Config.Colors.Accent)
    InitMotors()
end

-- [[ 🔑 LOGIN SYSTEM ]]
local function RunLogin()
    local sg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 300, 0, 200); f.Position = UDim2.new(0.5, -150, 0.5, -100); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Config.Colors.Accent; MakeDraggable(f)
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8, 0, 0, 40); box.Position = UDim2.new(0.1, 0, 0.3, 0); box.PlaceholderText = "KEY SUPREME"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(20,20,30); Instance.new("UICorner", box)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8, 0, 0, 40); btn.Position = UDim2.new(0.1, 0, 0.65, 0); btn.Text = "LOGIN"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if table.find(MANUAL_KEYS, box.Text) then sg:Destroy(); CreateUI() else box.Text = ""; box.PlaceholderText = "LLAVE INVÁLIDA" end
    end)
end

RunLogin()
-- [[ FIN V3.0 ]]
