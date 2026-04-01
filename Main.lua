-- [[ 🌌 FLOURITE SOFTWORKS V4.5 - THE GOD MODE EDITION 🌌 ]]
-- [[ DEVELOPERS: CODEX & CHRIXUS (SUPREME TEAM) ]]
-- [[ DATE: APRIL 1, 2026 | STATUS: UNDETECTED ]]
-- [[ OPTIMIZED FOR: DELTA, FLUXUS, HYDROGEN, ARCEUS ]]

task.wait(0.20) -- SEGURIDAD CONTRA ERROR LÍNEA 1

-- [[ 🛡️ SERVICIOS DEL SISTEMA ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

-- [[ 👤 REFERENCIAS LOCALES ]]
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [[ 🔑 DATABASE: 25 LICENCIAS PREMIUM ]]
local CH_KEYS = {
    "CHKEY-2a7d9f3b1c", "CHKEY-5g1h4j6k8l", "CHKEY-9m2n0p5q3r", "CHKEY-4s6t8u1v7w",
    "CHKEY-3x5y9z2a4b", "CHKEY-7c1d3e6f8g", "CHKEY-2h5i7j9k1l", "CHKEY-6m8n3p0q2r",
    "CHKEY-1s4t6u9v3w", "CHKEY-5x2y7z4a6b", "CHKEY-8c3d5e1f9g", "CHKEY-4h9i2j5k7l",
    "CHKEY-7m1n6p8q4r", "CHKEY-3s5t9u2v6w", "CHKEY-6x8y3z1a5b", "CHKEY-9c2d7e4f1g",
    "CHKEY-5h3i8j2k6l", "CHKEY-2m7n4p1q9r", "CHKEY-8s1t5u7v3w", "CHKEY-4x6y2z9a3b",
    "CHKEY-1c9d4e7f2g", "CHKEY-6h7i1j8k4l", "CHKEY-3m5n9p2q6r", "CHKEY-7s3t8u4v9w",
    "CHKEY-2x9y5z6a8b"
}

-- [[ ⚙️ CONFIGURACIÓN MAESTRA ]]
local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, ESP_Murd = false, ESP_Sheriff = false,
        ESP_Inno = false, Traces = false, Hitbox = false,
        AutoFarm = false, FullBright = false, AntiLag = false
    },
    Values = {
        Speed = 50, FOV = 70, Smooth = 0.12,
        HitboxSize = 25, JumpPower = 62,
        JumpDebounce = false, LastSheriffPos = nil,
        GunFound = false, GunPart = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 30, 30),
        Sher = Color3.fromRGB(0, 160, 255),
        Inno = Color3.fromRGB(50, 255, 50),
        Accent = Color3.fromRGB(0, 210, 255),
        Bg = Color3.fromRGB(12, 12, 25)
    }
}

-- [[ 🛰️ NOTIFICACIONES ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 260, 0, 75); frame.Position = UDim2.new(1, 10, 0.1, 0)
    frame.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", frame)
    Instance.new("UIStroke", frame).Color = color
    
    local tl = Instance.new("TextLabel", frame)
    tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = "GothamBold"; tl.BackgroundTransparency = 1; tl.TextSize = 14
    
    local dl = Instance.new("TextLabel", frame)
    dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = "Gotham"; dl.BackgroundTransparency = 1; dl.TextSize = 12
    
    frame:TweenPosition(UDim2.new(1, -270, 0.1, 0), "Out", "Back", 0.5)
    task.delay(3, function()
        frame:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.5)
        task.wait(0.6); sg:Destroy()
    end)
end

-- [[ 🖱️ DRAGGABLE MODULE (FIXED - NO SE MUEVE SOLO) ]]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ 👁️ ESP RENDER V5 ]]
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
    local line = Drawing.new("Line")
    line.Thickness = 2
    
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if p and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p); local col = Config.Colors[role]
            high.Enabled = Config.Toggles["ESP_"..role]; high.Adornee = p.Character; high.FillColor = col
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis then
                line.Visible = true; line.Color = col; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
            else line.Visible = false end
        else high.Enabled = false; line.Visible = false end
    end)
    active_esp[p] = {H = high, L = line, C = conn}
end

-- [[ 🛡️ COMBAT ENGINE (FIXED JUMP & HITBOX) ]]
local function InitCombat()
    RunService.Stepped:Connect(function()
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        -- Inf Jump
        if Config.Toggles.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if not Config.Values.JumpDebounce and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                Config.Values.JumpDebounce = true
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character.HumanoidRootPart.Velocity.X, Config.Values.JumpPower, lp.Character.HumanoidRootPart.Velocity.Z)
                task.wait(0.12); Config.Values.JumpDebounce = false
            end
        end

        -- Aimbot & Hitbox
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart; local role = GetRole(p)
                if role == "Murd" then
                    if Config.Toggles.Aimbot then
                        camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, hrp.Position), Config.Values.Smooth)
                    end
                    if Config.Toggles.Hitbox then
                        hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                        hrp.Transparency = 0.8; hrp.CanCollide = false
                    else hrp.Size = Vector3.new(2,2,1); hrp.Transparency = 1 end
                elseif role == "Sher" then Config.Values.LastSheriffPos = hrp.CFrame end
            end
        end
        
        -- BUSCAR ARMA TIRADA (TP GUN)
        local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("GunPart")
        if gun then Config.Values.GunFound = true; Config.Values.GunPart = gun else Config.Values.GunFound = false end

        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
    end)
end

-- [[ 🏙️ UI SUPREME V4.5 (FIXED DRAG) ]]
local function CreateUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "MM2 HUB🌌"
    
    local Widget = Instance.new("ImageButton", sg)
    Widget.Size = UDim2.new(0, 60, 0, 60); Widget.Position = UDim2.new(0, 20, 0.5, -30)
    Widget.BackgroundColor3 = Config.Colors.Bg; Widget.Image = "rbxassetid://6031068433"; Widget.Visible = false; Instance.new("UICorner", Widget).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Widget).Color = Config.Colors.Accent; MakeDraggable(Widget)

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 480, 0, 350); main.Position = UDim2.new(0.5, -240, 0.5, -175)
    main.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", main); local ms = Instance.new("UIStroke", main); ms.Color = Config.Colors.Accent; ms.Thickness = 3; MakeDraggable(main)

    local x = Instance.new("TextButton", main); x.Size = UDim2.new(0, 35, 0, 35); x.Position = UDim2.new(1, -40, 0, 5); x.Text = "X"; x.BackgroundColor3 = Color3.fromRGB(200, 40, 40); x.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", x)
    x.MouseButton1Click:Connect(function() main.Visible = false; Widget.Visible = true end)
    Widget.MouseButton1Click:Connect(function() main.Visible = true; Widget.Visible = false end)

    local bar = Instance.new("Frame", main); bar.Size = UDim2.new(0, 130, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(20, 20, 40); Instance.new("UICorner", bar)
    Instance.new("UIListLayout", bar).Padding = UDim.new(0, 5)
    
    local container = Instance.new("Frame", main); container.Position = UDim2.new(0, 140, 0, 50); container.Size = UDim2.new(1, -150, 1, -60); container.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", container); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0; Instance.new("UIListLayout", f).Padding = UDim.new(0, 8)
        local b = Instance.new("TextButton", bar); b.Size = UDim2.new(1, 0, 0, 45); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.8; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end)
        return f
    end

    local t1 = Tab("GENERAL"); t1.Visible = true; local t2 = Tab("VISUALES"); local t3 = Tab("COMBAT"); local t4 = Tab("TELEPORTS")

    local function Toggle(p, text, key)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 40); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 35, 60); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]; b.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(35, 35, 60); b.TextColor3 = Config.Toggles[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    -- PESTAÑAS
    Toggle(t1, "SPEED HACK", "WalkSpeed"); Toggle(t1, "NOCLIP", "Noclip"); Toggle(t1, "INF JUMP ", "InfJump")
    Toggle(t2, "ESP MURDERER", "ESP_Murd"); Toggle(t2, "ESP SHERIFF", "ESP_Sheriff"); Toggle(t2, "ESP INNOCENTS", "ESP_Inno"); Toggle(t2, "TRACERS", "Traces")
    Toggle(t3, "AIMBOT", "Aimbot"); Toggle(t3, "HITBOX 25x25", "Hitbox")
    
    -- PESTAÑA TELEPORTS (AQUÍ ESTÁ TU TP GUN)
    local tpGun = Instance.new("TextButton", t4); tpGun.Size = UDim2.new(0.95, 0, 0, 45); tpGun.Text = "TELE GUN PRÓXIMAMENTE"; tpGun.BackgroundColor3 = Color3.fromRGB(200, 100, 0); tpGun.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpGun)
    tpGun.MouseButton1Click:Connect(function()
        if Config.Values.GunPart then 
            lp.Character.HumanoidRootPart.CFrame = Config.Values.GunPart.CFrame
            Notify("ÉXITO", "Teletransportado al arma.", Config.Colors.Inno)
        else Notify("AVISO", "función próximamente usuario.", Color3.new(1,0,0)) end
    end)

    local tpSheriff = Instance.new("TextButton", t4); tpSheriff.Size = UDim2.new(0.95, 0, 0, 45); tpSheriff.Text = "TELEPORT TO SHERIFF"; tpSheriff.BackgroundColor3 = Config.Colors.Sher; tpSheriff.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpSheriff)
    tpSheriff.MouseButton1Click:Connect(function()
        if Config.Values.LastSheriffPos then 
            lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos
        else Notify("AVISO", "Sheriff no detectado.", Color3.new(1,0,0)) end
    end)

    Notify("BIENVENIDO USUARIO", "script de codex 2.0.", Config.Colors.Accent)
end

-- [[ 🚀 SISTEMA DE LLAVE Y LANZAMIENTO ]]
local function RunKeys()
    local kg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", kg); f.Size = UDim2.new(0, 350, 0, 250); f.Position = UDim2.new(0.5, -175, 0.5, -125); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Config.Colors.Accent
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8, 0, 0, 50); box.Position = UDim2.new(0.1, 0, 0.35, 0); box.PlaceholderText = "CHKEY-XXXXX"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(30, 30, 50); Instance.new("UICorner", box)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8, 0, 0, 50); btn.Position = UDim2.new(0.1, 0, 0.7, 0); btn.Text = "VERIFICAR"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = "GothamBold"; Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if table.find(CH_KEYS, box.Text) then
            kg:Destroy(); CreateUI(); InitCombat()
            for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
            Players.PlayerAdded:Connect(function(p) task.wait(1); ApplyESP(p) end)
        else box.Text = ""; box.PlaceholderText = "LLAVE INVÁLIDA" end
    end)
end


RunKeys()
-- [[ FIN DEL SCRIPT SUPREME GOD EDITION ]]
