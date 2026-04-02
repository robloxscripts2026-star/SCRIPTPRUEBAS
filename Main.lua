--V3.0 HUB MM2 - FIXED & OPTIMIZED

task.wait(1.0)

-- [[ 🛠️ SERVICIOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 DATABASE: 25 KEYS ]]
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
        ESP_Inno = false, ESP_Sheriff = false, ESP_Murd = false,
        Traces = false
    },
    Values = {
        Speed = 65, FOV_Max = 120, FOV_Min = 70, 
        HitboxSize = 10,        -- ← Cambiado a 10 como pediste
        AuraRange = 48, Smooth = 0.7,
        LastSheriffPos = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 35, 35),
        Sher = Color3.fromRGB(0, 180, 255),
        Inno = Color3.fromRGB(0, 255, 140),
        Accent = Color3.fromRGB(0, 230, 255),
        Bg = Color3.fromRGB(12, 12, 18)
    }
}

-- [[ 🛰️ NOTIFICACIONES ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 290, 0, 90); f.Position = UDim2.new(1, 20, 0.15, 0); f.BackgroundColor3 = Config.Colors.Bg
    Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = color; s.Thickness = 3
    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1; tl.TextSize = 17
    local dl = Instance.new("TextLabel", f); dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = Enum.Font.Gotham; dl.BackgroundTransparency = 1; dl.TextSize = 14; dl.TextWrapped = true
    f:TweenPosition(UDim2.new(1, -310, 0.15, 0), "Out", "Back", 0.6)
    task.delay(4, function() if f then f:TweenPosition(UDim2.new(1, 20, 0.15, 0), "In", "Quad", 0.6); task.wait(0.7); sg:Destroy() end end)
end

-- [[ 🖱️ DRAGGABLE ]]
local function MakeDraggable(obj)
    local dragging, dragStart, startPos
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

-- [[ MOTOR DE ROLES (CODEX SUPREME) ]]
local function GetRole(p)
    if not p or not p.Character then return "Inno" end
    local char = p.Character
    local bp = p.Backpack or p:FindFirstChild("Backpack")
    
    if char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then return "Murd" end
    
    local function CheckTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        return n:find("gun") or n:find("revolver") or n:find("sheriff") or 
               n:find("hero") or n:find("toy") or n:find("apoc") or 
               n:find("elderwood") or n:find("treat") or n:find("heart") or 
               n:find("valent") or n:find("luger") or n:find("blaster")
    end
    
    for _, tool in ipairs(char:GetChildren()) do if CheckTool(tool) then return "Sher" end end
    if bp then for _, tool in ipairs(bp:GetChildren()) do if CheckTool(tool) then return "Sher" end end end
    for _, v in ipairs(char:GetDescendants()) do if v:IsA("Tool") and CheckTool(v) then return "Sher" end end
    
    return "Inno"
end

-- [[ VISUAL ENGINE - ESP ]]
local active_esp = {}
local function CreateESP(p)
    if p == lp or active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui)
    highlight.Name = "CHHUB_"..p.Name
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.5
    
    local line = Drawing.new("Line"); line.Thickness = 2.5; line.Transparency = 1
    
    local render = RunService.RenderStepped:Connect(function()
        if p and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p)
            local col = Config.Colors[role] or Color3.new(1,1,1)
            
            highlight.Enabled = Config.Toggles["ESP_"..role]
            highlight.Adornee = p.Character
            highlight.FillColor = col
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis and Config.Toggles["ESP_"..role] then
                line.Visible = true
                line.Color = col
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
            else
                line.Visible = false
            end
            
            if role == "Sher" and p.Character.HumanoidRootPart then
                Config.Values.LastSheriffPos = p.Character.HumanoidRootPart.CFrame
            end
        else
            highlight:Destroy()
            line:Remove()
            render:Disconnect()
            active_esp[p] = nil
        end
    end)
    active_esp[p] = true
end

-- Escaneo de jugadores
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p \~= lp and not active_esp[p] then
                CreateESP(p)
            end
        end
    end
end)

-- [[ COMBAT ENGINE ]]
local function InitMotors()
    RunService.Stepped:Connect(function()
        if Config.Toggles.KillAura and GetRole(lp) == "Murd" then
            local k = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if k then
                for _, p in pairs(Players:GetPlayers()) do
                    if p \~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < Config.Values.AuraRange then
                            firetouchinterest(p.Character.HumanoidRootPart, k.Handle, 0)
                            firetouchinterest(p.Character.HumanoidRootPart, k.Handle, 1)
                        end
                    end
                end
            end
        end
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p \~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local role = GetRole(p)
                if role == "Murd" and Config.Toggles.Aimbot then
                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, hrp.Position), Config.Values.Smooth)
                end
            end
        end
        camera.FieldOfView = Config.Toggles.Noclip and Config.Values.FOV_Max or Config.Values.FOV_Min
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
    end)
end

-- [[ HITBOX 10x10 (Estable) ]]
local function HitboxMaintainer()
    RunService.Heartbeat:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p == lp or not p.Character then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            if Config.Toggles.Hitbox and GetRole(p) == "Murd" then
                hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                hrp.Transparency = 0.45
                hrp.Color = Color3.new(1, 0, 0)
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            else
                if hrp.Size \~= Vector3.new(2, 2, 1) then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Color = Color3.new(1, 1, 1)
                    hrp.Material = Enum.Material.Plastic
                    hrp.CanCollide = true
                end
            end
        end
    end)
end

UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- [[ UI MÁS PEQUEÑA ]]
local function BuildUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "CH-HUB_V3"
    
    local Circle = Instance.new("ImageButton", sg)
    Circle.Size = UDim2.new(0, 60, 0, 60)
    Circle.Position = UDim2.new(0, 25, 0.5, -30)
    Circle.BackgroundColor3 = Config.Colors.Bg
    Circle.Image = "rbxassetid://6031068433"
    Circle.Visible = false
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", Circle).Color = Config.Colors.Accent
    MakeDraggable(Circle)

    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 420, 0, 380)  -- ← Menú más pequeño
    Main.Position = UDim2.new(0.5, -210, 0.5, -190)
    Main.BackgroundColor3 = Config.Colors.Bg
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Config.Colors.Accent
    MakeDraggable(Main)

    local X = Instance.new("TextButton", Main)
    X.Size = UDim2.new(0, 40, 0, 40)
    X.Position = UDim2.new(1, -45, 0, 5)
    X.Text = "X"
    X.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
    X.TextColor3 = Color3.new(1,1,1)
    X.Font = Enum.Font.GothamBold
    Instance.new("UICorner", X)

    X.MouseButton1Click:Connect(function() Main.Visible = false; Circle.Visible = true end)
    Circle.MouseButton1Click:Connect(function() Main.Visible = true; Circle.Visible = false end)

    -- Sidebar y Content (ajustados al tamaño nuevo)
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -10); Sidebar.Position = UDim2.new(0, 8, 0, 8); Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 6)
    
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -160, 1, -70); Content.Position = UDim2.new(0, 155, 0, 55); Content.BackgroundTransparency = 1

    local function Tab(n)
        local f = Instance.new("ScrollingFrame", Content); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 2
        Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 42); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(20,20,30); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(20,20,30); v.TextColor3 = Color3.new(1,1,1) end end
            f.Visible = true; b.BackgroundColor3 = Config.Colors.Accent; b.TextColor3 = Color3.new(0,0,0)
        end)
        return f
    end

    local t1 = Tab("GENERAL ⚙️"); t1.Visible = true
    local t2 = Tab("VISUAL 👾")
    local t3 = Tab("COMBATE ⚔️")
    local t4 = Tab("TELEPORTS 🔮")

    local function Toggle(p, text, key)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 40); b.Text = text .. " [OFF]"
        b.BackgroundColor3 = Color3.fromRGB(35,35,50); b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            b.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(35,35,50)
            b.TextColor3 = Config.Toggles[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    Toggle(t1, "NOCLIP", "Noclip")
    Toggle(t1, "SPEED HACK", "WalkSpeed")
    Toggle(t1, "INF JUMP", "InfJump")
    Toggle(t2, "ESP INOCENTE", "ESP_Inno")
    Toggle(t2, "ESP SHERIFF", "ESP_Sheriff")
    Toggle(t2, "ESP ASESINO", "ESP_Murd")
    Toggle(t2, "TRACES", "Traces")
    Toggle(t3, "AIMBOT", "Aimbot")
    Toggle(t3, "HITBOX 10x10", "Hitbox")
    Toggle(t3, "KILL AURA", "KillAura")

    local function Btn(p, text, func)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 42); b.Text = text
        b.BackgroundColor3 = Color3.fromRGB(50,50,75); b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(func)
    end

    Btn(t4, "TP TO GUN 🔫", function()
        local g = workspace:FindFirstChild("GunDrop") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop"))
        if g then
            lp.Character.HumanoidRootPart.CFrame = g.CFrame
            Notify("TELEPORT", "Arma recogida!", Config.Colors.Accent)
        else
            Notify("TELEPORT", "No hay arma en el mapa", Color3.new(1,0.5,0))
        end
    end)

    Btn(t4, "TP TO SHERIFF 👮", function()
        if Config.Values.LastSheriffPos then
            lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos
            Notify("TELEPORT", "Sheriff alcanzado", Config.Colors.Sher)
        else
            Notify("TELEPORT", "Sheriff no detectado aún", Color3.new(1,0,0))
        end
    end)

    Notify("CH-HUB V3.0", "Script cargado correctamente", Config.Colors.Accent)
    InitMotors()
    HitboxMaintainer()
end

-- [[ KEY SYSTEM ]]
local function RunLogin()
    local sg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 360, 0, 280); f.Position = UDim2.new(0.5, -180, 0.5, -140)
    f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f)
    local s = Instance.new("UIStroke", f); s.Color = Config.Colors.Accent; s.Thickness = 3
    MakeDraggable(f)

    local title = Instance.new("TextLabel", f); title.Size = UDim2.new(1,0,0.25,0); title.Text = "CH-HUB MM2 V3.0"
    title.TextColor3 = Config.Colors.Accent; title.Font = Enum.Font.GothamBold; title.TextSize = 26; title.BackgroundTransparency = 1

    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8,0,0,50); box.Position = UDim2.new(0.1,0,0.35,0)
    box.PlaceholderText = "Ingresa tu Key"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(25,25,35)
    Instance.new("UICorner", box)

    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8,0,0,50); btn.Position = UDim2.new(0.1,0,0.55,0)
    btn.Text = "LOGIN"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        if table.find(MANUAL_KEYS, box.Text) then
            sg:Destroy()
            BuildUI()
        else
            box.Text = ""; box.PlaceholderText = "Key incorrecta"
        end
    end)
end

RunLogin()
