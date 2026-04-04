-- [[ CHRIXUS VERSIÓN 3.00]]

task.wait(0.5)

-- [[ 🛠️ SERVICIOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
        Noclip = false, InfJump = false, WalkSpeed = false, FOV_Toggle = false,
        Aimbot = false, KillAura = false, Hitbox = false,
        ESP_Inno = false, ESP_Sheriff = false, ESP_Murd = false,
        Traces = false, UILocked = false
    },
    Values = {
        Speed = 65, FOV_Max = 120, FOV_Min = 70, 
        HitboxSize = 10, AuraRange = 120, Smooth = 0.5,
        LastSheriffPos = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 35, 35),
        Sher = Color3.fromRGB(0, 180, 255),
        Inno = Color3.fromRGB(0, 255, 140),
        Accent = Color3.fromRGB(0, 230, 255),
        Bg = Color3.fromRGB(15, 15, 20)
    }
}

-- [[ 🛰️ NOTIFICACIONES ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 260, 0, 75); f.Position = UDim2.new(1, 20, 0.15, 0); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = color; s.Thickness = 2
    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1; tl.TextSize = 14
    local dl = Instance.new("TextLabel", f); dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = Enum.Font.Gotham; dl.BackgroundTransparency = 1; dl.TextSize = 12; dl.TextWrapped = true
    f:TweenPosition(UDim2.new(1, -280, 0.15, 0), "Out", "Back", 0.5)
    task.delay(3, function() if f then f:TweenPosition(UDim2.new(1, 20, 0.15, 0), "In", "Quad", 0.5); task.wait(0.6); sg:Destroy() end end)
end

-- [[ 🖱️ DRAGGABLE ENGINE (FIX TOTAL) ]]
local function MakeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if obj.Name == "FloatingFrame" and Config.Toggles.UILocked then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)
end

-- [[ 👁️ MOTOR ESP V2 ]]
local active_esp = {}
local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Knife")) then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

local function CreateESP(p)
    if p == lp or active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui); highlight.OutlineTransparency = 0; highlight.FillTransparency = 0.4
    local line = Drawing.new("Line"); line.Thickness = 2; line.Transparency = 1
    active_esp[p] = {Highlight = highlight, Line = line}
    local connection; connection = RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p); local col = (role == "Murderer" and Config.Colors.Murd) or (role == "Sheriff" and Config.Colors.Sher) or Config.Colors.Inno
            local enabled = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or (role == "Innocent" and Config.Toggles.ESP_Inno)
            if enabled then
                highlight.Enabled = true; highlight.Adornee = p.Character; highlight.FillColor = col
                local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if Config.Toggles.Traces and vis then
                    line.Visible = true; line.Color = col; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
                else line.Visible = false end
            else highlight.Enabled = false; line.Visible = false end
            if role == "Sheriff" then Config.Values.LastSheriffPos = p.Character.HumanoidRootPart.CFrame end
        else highlight.Enabled = false; line.Visible = false end
        if not Players:FindFirstChild(p.Name) then highlight:Destroy(); line:Remove(); active_esp[p] = nil; connection:Disconnect() end
    end)
end

-- [[ ⚔️ COMBAT: AUTO-SHOOT CORREGIDO ]]
local function CheckVisibility(targetPart)
    local char = lp.Character
    if not char then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char, camera, targetPart.Parent}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(camera.CFrame.Position, (targetPart.Position - camera.CFrame.Position).Unit * 500, params)
    return result == nil -- Si no golpea nada intermedio, hay visión clara
end

local function InitMotors()
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if GetRole(p) == "Murderer" and Config.Toggles.Aimbot then
                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, hrp.Position), Config.Values.Smooth)
                    
                    -- Lógica Auto-Shoot: ¿Soy el Sheriff?
                    if GetRole(lp) == "Sheriff" then
                        local gun = lp.Character:FindFirstChild("Gun")
                        if gun and CheckVisibility(hrp) then
                            gun:Activate()
                        end
                    end
                end
            end
        end
        camera.FieldOfView = Config.Toggles.FOV_Toggle and Config.Values.FOV_Max or Config.Values.FOV_Min
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
    end)
    
    RunService.Stepped:Connect(function()
        if Config.Toggles.KillAura and GetRole(lp) == "Murderer" then
            local k = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if k then for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < Config.Values.AuraRange then
                        firetouchinterest(p.Character.HumanoidRootPart, k.Handle, 0); firetouchinterest(p.Character.HumanoidRootPart, k.Handle, 1)
                    end
                end
            end end
        end
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)
end

-- [[ 🛡️ HITBOX ]]
local function HitboxMaintainer()
    RunService.Heartbeat:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p == lp or not p.Character then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if Config.Toggles.Hitbox and GetRole(p) == "Murderer" then
                    hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                    hrp.Transparency = 0.4; hrp.Color = Color3.new(1, 0, 0); hrp.Material = Enum.Material.Neon; hrp.CanCollide = false
                else
                    if hrp.Size ~= Vector3.new(2, 2, 1) then
                        hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.Material = Enum.Material.Plastic; hrp.CanCollide = true
                    end
                end
            end
        end
    end)
end

-- [[ 🚀 INFINITY JUMP ]]
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- [[ 🏙️ UI MINI SUPREME V22 (370x240) ]]
local function BuildUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "MINI_SUPREME_V22"
    
    local FloatingFrame = Instance.new("Frame", sg); FloatingFrame.Name = "FloatingFrame"; FloatingFrame.Size = UDim2.new(0, 150, 0, 35); FloatingFrame.Position = UDim2.new(0, 50, 0.5, 0); FloatingFrame.BackgroundColor3 = Config.Colors.Bg; FloatingFrame.BackgroundTransparency = 0.2; MakeDraggable(FloatingFrame)
    Instance.new("UICorner", FloatingFrame)
    
    local ToggleBtn = Instance.new("TextButton", FloatingFrame); ToggleBtn.Size = UDim2.new(0, 70, 1, 0); ToggleBtn.Text = "TOGGLE"; ToggleBtn.BackgroundColor3 = Color3.new(0,0,0); ToggleBtn.BackgroundTransparency = 1; ToggleBtn.TextColor3 = Config.Colors.Accent; ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 10
    
    local LockBtn = Instance.new("TextButton", FloatingFrame); LockBtn.Size = UDim2.new(0, 70, 1, 0); LockBtn.Position = UDim2.new(0, 75, 0, 0); LockBtn.Text = "LOCK"; LockBtn.BackgroundColor3 = Color3.new(0,0,0); LockBtn.BackgroundTransparency = 1; LockBtn.TextColor3 = Color3.new(1,1,1); LockBtn.Font = Enum.Font.GothamBold; LockBtn.TextSize = 10

    local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 370, 0, 240); Main.Position = UDim2.new(0.5, -185, 0.5, -120); Main.BackgroundColor3 = Config.Colors.Bg; Main.Visible = false; Instance.new("UICorner", Main); local s = Instance.new("UIStroke", Main); s.Color = Config.Colors.Accent; MakeDraggable(Main)
    
    local X = Instance.new("TextButton", Main); X.Size = UDim2.new(0, 25, 0, 25); X.Position = UDim2.new(1, -30, 0, 5); X.Text = "X"; X.BackgroundColor3 = Color3.new(0.8,0,0); X.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", X); X.MouseButton1Click:Connect(function() Main.Visible = false end)

    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
    LockBtn.MouseButton1Click:Connect(function() 
        Config.Toggles.UILocked = not Config.Toggles.UILocked
        LockBtn.Text = Config.Toggles.UILocked and "UNLOCK" or "LOCK"
        LockBtn.TextColor3 = Config.Toggles.UILocked and Config.Colors.Murd or Color3.new(1,1,1)
    end)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 100, 1, -10); Sidebar.Position = UDim2.new(0, 5, 0, 5); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 3)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -115, 1, -40); Content.Position = UDim2.new(0, 110, 0, 35); Content.BackgroundTransparency = 1

    local function Tab(n)
        local f = Instance.new("ScrollingFrame", Content); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 1; Instance.new("UIListLayout", f).Padding = UDim.new(0, 5)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 32); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(25,25,30); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 9; b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end); return f
    end

    local t1 = Tab("GENERAL ⚙️"); t1.Visible = true; local t2 = Tab("VISUAL 👾"); local t3 = Tab("COMBAT ⚔️"); local t4 = Tab("TELEPORT 🔮")
    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 30); b.Text = t .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 10; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() Config.Toggles[k] = not Config.Toggles[k]; b.Text = t .. (Config.Toggles[k] and " [ON]" or " [OFF]"); b.BackgroundColor3 = Config.Toggles[k] and Config.Colors.Accent or Color3.fromRGB(35, 35, 45); b.TextColor3 = Config.Toggles[k] and Color3.new(0,0,0) or Color3.new(1,1,1) end)
    end

    Toggle(t1, "NOCLIP", "Noclip"); Toggle(t1, "SPEED HACK", "WalkSpeed"); Toggle(t1, "INFJUMP", "InfJump"); Toggle(t1, "FOV ", "FOV_Toggle")
    Toggle(t2, "ESP INOCENTE", "ESP_Inno"); Toggle(t2, "ESP SERIFF", "ESP_Sheriff"); Toggle(t2, "ESP ASESINO", "ESP_Murd"); Toggle(t2, "TRACES", "Traces")
    Toggle(t3, "AUTO AIM", "Aimbot"); Toggle(t3, "HITBOX", "Hitbox"); Toggle(t3, "AURAKILL", "KillAura")
    
    local function Btn(p, t, f) local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 30); b.Text = t; b.BackgroundColor3 = Color3.fromRGB(50,50,70); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 10; Instance.new("UICorner", b); b.MouseButton1Click:Connect(f) end
    Btn(t4, "TP GUN 🔫", function() local g = workspace:FindFirstChild("Gun") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("Gun")); if g then lp.Character.HumanoidRootPart.CFrame = g.CFrame; Notify("TP", "próximamente usuario👤", Config.Colors.Accent) end end)
    Btn(t4, "TP SHERIFF 👮", function() 
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do if GetRole(p) == "Sheriff" then target = p.Character end end
        if target and target:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame
            Notify("TP", "Teletransportado al Sheriff activo.", Config.Colors.Sher)
        elseif Config.Values.LastSheriffPos then
            lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos
            Notify("TP", "Sheriff muerto. TP a última ubicación.", Color3.new(1,0.5,0))
        else
            Notify("TP", "No hay Sheriff ni memoria.", Color3.new(1,0,0))
        end
    end)

    for _, v in pairs(Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
    Players.PlayerAdded:Connect(function(v) if v ~= lp then CreateESP(v) end end)

    Notify("OVERDRIVE CARGADO✅", "Bienvenido usuario 👤", Config.Colors.Accent)
    InitMotors(); HitboxMaintainer()
end

local function RunLogin()
    local sg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 300, 0, 220); f.Position = UDim2.new(0.5, -150, 0.5, -110); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = Config.Colors.Accent; MakeDraggable(f)
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,0.3,0); t.Text = "CH-HUB MM2 👑"; t.TextColor3 = Config.Colors.Accent; t.Font = Enum.Font.GothamBold; t.TextSize = 20; t.BackgroundTransparency = 1
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8,0,0,45); box.Position = UDim2.new(0.1,0,0.35,0); box.PlaceholderText = "ENTER KEY 🔑"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(25,25,35); Instance.new("UICorner", box)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8,0,0,45); btn.Position = UDim2.new(0.1,0,0.7,0); btn.Text = "LOGIN👤"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() if table.find(MANUAL_KEYS, box.Text) then sg:Destroy(); BuildUI() end end)
end

RunLogin()
