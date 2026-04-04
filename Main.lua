-- [[ 👑 CH-HUB MM2 V3.2 SUPREME ]] --
-- [[ OPTIMIZADO - SILENT AIM + MAGIC BULLETS ]] --

task.wait(0.5)

-- [[ 🛠️ SERVICIOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ ⚙️ CONFIGURACIÓN ]]
local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false, FOV_Toggle = false,
        SilentAim = false, KillAura = false, Hitbox = false,
        ESP_Inno = false, ESP_Sheriff = false, ESP_Murd = false,
        Traces = false, UILocked = false
    },
    Values = {
        Speed = 50, FOV_Max = 120, FOV_Min = 70, 
        AuraRange = 48, LastSheriffPos = nil, Smooth = 0.8
    },
    Colors = {
        Murd = Color3.fromRGB(255, 35, 35),
        Sher = Color3.fromRGB(0, 180, 255),
        Inno = Color3.fromRGB(0, 255, 140),
        Accent = Color3.fromRGB(0, 230, 255),
        Bg = Color3.fromRGB(15, 15, 20)
    }
}

-- [[ 🎯 LÓGICA DE ROLES ]]
local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function GetMurderer()
    for _, v in pairs(Players:GetPlayers()) do
        if GetRole(v) == "Murderer" and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            return v.Character.HumanoidRootPart
        end
    end
    return nil
end

-- [[ 🛰️ NOTIFICACIONES ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 280, 0, 85); f.Position = UDim2.new(1, 20, 0.15, 0); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = color; s.Thickness = 2.5
    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1; tl.TextSize = 16
    local dl = Instance.new("TextLabel", f); dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = Enum.Font.Gotham; dl.BackgroundTransparency = 1; dl.TextSize = 13; dl.TextWrapped = true
    f:TweenPosition(UDim2.new(1, -300, 0.15, 0), "Out", "Back", 0.5)
    task.delay(3.5, function() if f then f:TweenPosition(UDim2.new(1, 20, 0.15, 0), "In", "Quad", 0.5); task.wait(0.6); sg:Destroy() end end)
end

-- [[ 🖱️ DRAGGABLE ENGINE ]]
local function MakeDraggable(obj, isFloatingFrame)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if isFloatingFrame and Config.Toggles.UILocked then return end
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

-- [[ 🛡️ SILENT AIM & MAGIC BULLETS ENGINE ]]
local oldNamecall
oldNamecall = hookmetatable(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if Config.Toggles.SilentAim and method == "FindPartOnRayWithIgnoreList" then
        local target = GetMurderer()
        if target then
            args[1] = Ray.new(camera.CFrame.Position, (target.Position - camera.CFrame.Position).Unit * 1000)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ 👁️ ESP MOTOR (IGUAL AL ORIGINAL) ]]
local active_esp = {}
local function CreateESP(p)
    if p == lp or active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui); highlight.OutlineTransparency = 0; highlight.FillTransparency = 0.4
    active_esp[p] = highlight
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p); local col = (role == "Murderer" and Config.Colors.Murd) or (role == "Sheriff" and Config.Colors.Sher) or Config.Colors.Inno
            local enabled = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or (role == "Innocent" and Config.Toggles.ESP_Inno)
            highlight.Enabled = enabled; highlight.Adornee = p.Character; highlight.FillColor = col
            if role == "Sheriff" then Config.Values.LastSheriffPos = p.Character.HumanoidRootPart.CFrame end
        else highlight.Enabled = false end
    end)
end

-- [[ 🏙️ UI MINI SUPREME V3.2 ]]
local function BuildUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "CH_HUB_V32"
    
    -- CONTENEDOR TOGGLE / LOCK
    local FloatingFrame = Instance.new("Frame", sg); FloatingFrame.Size = UDim2.new(0, 150, 0, 35); FloatingFrame.Position = UDim2.new(0, 50, 0.5, 0); FloatingFrame.BackgroundTransparency = 1; MakeDraggable(FloatingFrame, true)
    local ToggleBtn = Instance.new("TextButton", FloatingFrame); ToggleBtn.Size = UDim2.new(0, 70, 1, 0); ToggleBtn.Text = "TOGGLE"; ToggleBtn.BackgroundColor3 = Config.Colors.Bg; ToggleBtn.TextColor3 = Config.Colors.Accent; ToggleBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", ToggleBtn); Instance.new("UIStroke", ToggleBtn).Color = Config.Colors.Accent
    local LockBtn = Instance.new("TextButton", FloatingFrame); LockBtn.Size = UDim2.new(0, 70, 1, 0); LockBtn.Position = UDim2.new(0, 75, 0, 0); LockBtn.Text = "LOCK"; LockBtn.BackgroundColor3 = Config.Colors.Bg; LockBtn.TextColor3 = Color3.new(1,1,1); LockBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", LockBtn); Instance.new("UIStroke", LockBtn).Color = Color3.new(1,1,1)

    -- BOTÓN SHOTMURDER (FLOTANTE)
    local ShotBtn = Instance.new("TextButton", sg); ShotBtn.Size = UDim2.new(0, 120, 0, 45); ShotBtn.Position = UDim2.new(0.8, 0, 0.8, 0); ShotBtn.Text = "SHOTMURDER"; ShotBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0); ShotBtn.TextColor3 = Color3.new(1,1,1); ShotBtn.Font = Enum.Font.GothamBold; ShotBtn.Visible = false; Instance.new("UICorner", ShotBtn); MakeDraggable(ShotBtn, false)
    ShotBtn.MouseButton1Click:Connect(function()
        local gun = lp.Character:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Gun")
        if gun then lp.Character.Humanoid:EquipTool(gun); task.wait(0.05); gun:Activate() end
    end)

    -- PANEL PRINCIPAL
    local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 360, 0, 340); Main.Position = UDim2.new(0.5, -180, 0.5, -170); Main.BackgroundColor3 = Config.Colors.Bg; Main.Visible = false; Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Config.Colors.Accent; MakeDraggable(Main, false)
    
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
    LockBtn.MouseButton1Click:Connect(function() 
        Config.Toggles.UILocked = not Config.Toggles.UILocked
        LockBtn.Text = Config.Toggles.UILocked and "UNLOCK" or "LOCK"
        LockBtn.TextColor3 = Config.Toggles.UILocked and Config.Colors.Murd or Color3.new(1,1,1)
    end)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 110, 1, -10); Sidebar.Position = UDim2.new(0, 5, 0, 5); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -125, 1, -50); Content.Position = UDim2.new(0, 120, 0, 45); Content.BackgroundTransparency = 1

    local function Tab(n)
        local f = Instance.new("ScrollingFrame", Content); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 1; Instance.new("UIListLayout", f).Padding = UDim.new(0, 8)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 38); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(25,25,30); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 10; b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end); return f
    end

    local t1 = Tab("GENERAL ⚙️"); t2 = Tab("VISUAL 👾"); t3 = Tab("COMBAT ⚔️"); t4 = Tab("TELEPORT 🔮"); t1.Visible = true

    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 35); b.Text = t .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() 
            Config.Toggles[k] = not Config.Toggles[k]
            b.Text = t .. (Config.Toggles[k] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[k] and Config.Colors.Accent or Color3.fromRGB(35, 35, 45)
            b.TextColor3 = Config.Toggles[k] and Color3.new(0,0,0) or Color3.new(1,1,1)
            if k == "SilentAim" then ShotBtn.Visible = Config.Toggles[k] end
        end)
    end

    -- GENERAL
    Toggle(t1, "NOCLIP", "Noclip"); Toggle(t1, "SPEED HACK", "WalkSpeed"); Toggle(t1, "INF JUMP", "InfJump"); Toggle(t1, "FOV", "FOV_Toggle")
    -- VISUAL
    Toggle(t2, "ESP INOCENTE", "ESP_Inno"); Toggle(t2, "ESP SHERIFF", "ESP_Sheriff"); Toggle(t2, "ESP ASESINO", "ESP_Murd")
    -- COMBAT
    Toggle(t3, "SILENT AIM", "SilentAim"); Toggle(t3, "KILL AURA", "KillAura")
    -- TELEPORT
    local function Btn(p, t, f) local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 35); b.Text = t; b.BackgroundColor3 = Color3.fromRGB(50,50,70); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 11; Instance.new("UICorner", b); b.MouseButton1Click:Connect(f) end
    Btn(t4, "TP GUN 🔫", function() local g = workspace:FindFirstChild("Gun") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("Gun")); if g then lp.Character.HumanoidRootPart.CFrame = g.CFrame end end)
    Btn(t4, "TP SHERIFF 👮", function() if Config.Values.LastSheriffPos then lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos end end)

    -- MOTORES
    RunService.Stepped:Connect(function()
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
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
    end)

    RunService.RenderStepped:Connect(function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
        camera.FieldOfView = Config.Toggles.FOV_Toggle and Config.Values.FOV_Max or 70
    end)

    UserInputService.JumpRequest:Connect(function()
        if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid:ChangeState(3) end
    end)

    for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
    Players.PlayerAdded:Connect(CreateESP)
    Notify("V3.2 CARGADA ✅", "Bienvenido de nuevo", Config.Colors.Accent)
end

BuildUI() -- Llama a tu función de login aquí si prefieres
