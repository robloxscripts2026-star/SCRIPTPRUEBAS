--MM2 HUB V3.0
task.wait(0.5)

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
        Noclip = false, InfJump = false, WalkSpeed = false, FOV_Toggle = false,
        Aimbot = false, KillAura = false, Hitbox = false,
        ESP_Inno = false, ESP_Sheriff = false, ESP_Murd = false,
        Traces = false, UILocked = false
    },
    Values = {
        Speed = 50, FOV_Max = 120, FOV_Min = 70, 
        HitboxSize = 10, AuraRange = 48, Smooth = 0.8,
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
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 280, 0, 85); f.Position = UDim2.new(1, 20, 0.15, 0); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = color; s.Thickness = 2.5
    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1; tl.TextSize = 16
    local dl = Instance.new("TextLabel", f); dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = Enum.Font.Gotham; dl.BackgroundTransparency = 1; dl.TextSize = 13; dl.TextWrapped = true
    f:TweenPosition(UDim2.new(1, -300, 0.15, 0), "Out", "Back", 0.5)
    task.delay(3.5, function() if f then f:TweenPosition(UDim2.new(1, 20, 0.15, 0), "In", "Quad", 0.5); task.wait(0.6); sg:Destroy() end end)
end

-- [[ 🖱️ DRAGGABLE ENGINE (FIXED) ]]
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

-- [[ 👁️ MOTOR ESP V2 ]]
local active_esp = {}
local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function CreateESP(p)
    if p == lp or active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui); highlight.OutlineTransparency = 0; highlight.FillTransparency = 0.4
    local line = Drawing.new("Line"); line.Thickness = 2; line.Transparency = 1
    active_esp[p] = {Highlight = highlight, Line = line}
    local connection; connection = RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p); local col = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.7,1)) or Color3.new(0,1,0)
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

-- [[ ⚔️ COMBAT ENGINE (AUTO-SHOOT RESTORED) ]]
local function CheckVisibility(target)
    local ray = Ray.new(camera.CFrame.Position, (target.Position - camera.CFrame.Position).Unit * 500)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, camera})
    return hit and hit:IsDescendantOf(target.Parent)
end

local function InitMotors()
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if GetRole(p) == "Murderer" and Config.Toggles.Aimbot then
                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, hrp.Position), Config.Values.Smooth)
                    
                    -- AUTO-SHOOT LÓGICA
                    local gun = lp.Character:FindFirstChild("Gun")
                    if gun and CheckVisibility(hrp) then
                        gun:Activate()
                    end
                end
            end
        end
    end) -- Cierra el RenderStepped
end -- Cierra la función InitMotors

        camera.FieldOfView = Config.Toggles.FOV_Toggle and Config.Values.FOV_Max or Config.Values.FOV_Min
        Camera.FieldOfView = Config.Toggles.FOV_Toggle and Config.Values.FOV_Max or Config.Values.FOV_Min
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

-- [[ 🛡️ HITBOX OPTIMIZADO ]]
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
                    -- Solo resetea si el tamaño fue alterado para no sobrecargar el Heartbeat
                    if hrp.Size ~= Vector3.new(2, 2, 1) then
                        hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.CanCollide = true
                    end
                end
            end
        end
    end)
end


-- [[ 🚀 INFINITY JUMP (TU VERSIÓN) ]]
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- ==========================================================
--               MINI SUPREME V21 - TOTAL FIXED (FLUENT)
-- ==========================================================
task.wait(0.1)

-- [[ 🛠️ SERVICIOS DE INTERFAZ ]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ ⚙️ CONFIGURACIÓN VISUAL ]]
local VisualConfig = {
    Colors = {
        Bg = Color3.fromRGB(18, 18, 24),          -- Fondo oscuro premium
        SidebarBg = Color3.fromRGB(24, 24, 32),   -- Lateral ligeramente más claro
        CardBg = Color3.fromRGB(28, 28, 38),      -- Fondo de los botones/tarjetas
        Accent = Color3.fromRGB(0, 210, 255),     -- Cyan brillante (Acento)
        Text = Color3.fromRGB(245, 245, 255),     -- Texto principal
        MutedText = Color3.fromRGB(140, 145, 160),-- Texto secundario
        ToggleOn = Color3.fromRGB(0, 210, 255),   -- Switch Encendido
        ToggleOff = Color3.fromRGB(45, 45, 60),   -- Switch Apagado
        Murd = Color3.fromRGB(255, 60, 60)         -- Color Rojo de bloqueo
    },
    States = {
        MainVisible = false,
        UILocked = false  -- Controla si se puede mover o no
    }
}

if CoreGui:FindFirstChild("MINI_SUPREME_FLUENT") then
    CoreGui.MINI_SUPREME_FLUENT:Destroy()
end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "MINI_SUPREME_FLUENT"
sg.ResetOnSpawn = false

-- [[ 🖱️ MOTOR DRAGGABLE CLÁSICO Y FLUIDO ]]
local function MakeDraggable(obj, isFloatingFrame)
    local dragging, dragStart, startPos
    
    obj.InputBegan:Connect(function(input)
        -- Si es la barra flotante y está bloqueada (UILocked = true), NO permite moverla
        if isFloatingFrame and VisualConfig.States.UILocked then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then dragging = false end 
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(obj, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

-- [[ 🚀 EFECTO DE REBOTE PARA BOTONES DEL PANEL ]]
local function AddTouchFeedback(btn)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset - 4, btn.Size.Y.Scale, btn.Size.Y.Offset - 4)}):Play()
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset + 4, btn.Size.Y.Scale, btn.Size.Y.Offset + 4)}):Play()
        end
    end)
end

-- [[ 🌌 PANEL MAIN PRINCIPAL (380 x 300) ]]
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 380, 0, 300)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5) 
Main.BackgroundColor3 = VisualConfig.Colors.Bg
Main.ClipsDescendants = true
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = VisualConfig.Colors.CardBg; MainStroke.Thickness = 1.5
MakeDraggable(Main, false)

-- Botón de cerrar (X)
local X = Instance.new("TextButton", Main)
X.Size = UDim2.new(0, 26, 0, 26)
X.Position = UDim2.new(1, -34, 0, 10)
X.Text = "×"
X.TextSize = 22
X.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
X.TextColor3 = VisualConfig.Colors.MutedText
X.Font = Enum.Font.Gotham
Instance.new("UICorner", X).CornerRadius = UDim.new(1, 0)
X.MouseEnter:Connect(function() X.TextColor3 = Color3.new(1,1,1); X.BackgroundColor3 = VisualConfig.Colors.Murd end)
X.MouseLeave:Connect(function() X.TextColor3 = VisualConfig.Colors.MutedText; X.BackgroundColor3 = Color3.fromRGB(35, 35, 45) end)

-- Título del Menú
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(0, 200, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "MINI SUPREME V21"
Title.TextColor3 = VisualConfig.Colors.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- [[ 🗂️ CONTENEDORES INTERNOS ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 115, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundColor3 = VisualConfig.Colors.SidebarBg
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
local SideLayout = Instance.new("UIListLayout", Sidebar); SideLayout.Padding = UDim.new(0, 6); SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -150, 1, -55)
Content.Position = UDim2.new(0, 135, 0, 45)
Content.BackgroundTransparency = 1

-- [[ 🎴 SISTEMA DE PESTAÑAS ]]
local tabs = {}
local function CreateTab(name)
    local f = Instance.new("ScrollingFrame", Content)
    f.Size = UDim2.new(1, 0, 1, 0)
    f.Visible = false
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 2
    f.ScrollBarImageColor3 = VisualConfig.Colors.CardBg
    local scrollLayout = Instance.new("UIListLayout", f); scrollLayout.Padding = UDim.new(0, 8)

local scrollLayout = Instance.new("UIListLayout", f); scrollLayout.Padding = UDim.new(0, 8)
f.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y) -- 💡 esto sirve para que el menú se ajuste solo xd



    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0, 103, 0, 36)
    b.Text = "  " .. name
    b.BackgroundColor3 = Color3.new(0,0,0)
    b.BackgroundTransparency = 1
    b.TextColor3 = VisualConfig.Colors.MutedText
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    local indicator = Instance.new("Frame", b)
    indicator.Size = UDim2.new(0, 3, 0, 16)
    indicator.Position = UDim2.new(0, 0, 0.5, -8)
    indicator.BackgroundColor3 = VisualConfig.Colors.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    Instance.new("UICorner", indicator)

    b.MouseButton1Click:Connect(function()
        for _, v in pairs(tabs) do
            v.Frame.Visible = false
            v.Button.TextColor3 = VisualConfig.Colors.MutedText
            v.Button.BackgroundTransparency = 1
            v.Indicator.Visible = false
        end
        f.Visible = true
        b.TextColor3 = VisualConfig.Colors.Text
        b.BackgroundColor3 = VisualConfig.Colors.CardBg
        b.BackgroundTransparency = 0.4
        indicator.Visible = true
    end)
    
    table.insert(tabs, {Frame = f, Button = b, Indicator = indicator})
    if #tabs == 1 then
        f.Visible = true
        b.TextColor3 = VisualConfig.Colors.Text
        b.BackgroundColor3 = VisualConfig.Colors.CardBg
        b.BackgroundTransparency = 0.4
        indicator.Visible = true
    end
    return f
end

local t1 = CreateTab("GENERAL ⚙️")
local t2 = CreateTab("VISUAL 👾")
local t3 = CreateTab("COMBAT ⚔️")
local t4 = CreateTab("TELEPORT 🔮")

-- [[ 🎛️ CREADORES DE COMPONENTES INTERACTIVOS ]]
local function AddFluentToggle(parent, text,key)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(0.96, 0, 0, 42) 
    card.BackgroundColor3 = VisualConfig.Colors.CardBg
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    
    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Text = text
    label.TextColor3 = VisualConfig.Colors.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local switch = Instance.new("TextButton", card)
    switch.Size = UDim2.new(0, 36, 0, 20)
    switch.Position = UDim2.new(1, -46, 0.5, -10)
    switch.Text = ""
    switch.BackgroundColor3 = VisualConfig.Colors.ToggleOff
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    
    switch.MouseButton1Click:Connect(function()
         Config.Toggles[key] = not Config.Toggles[key]
    local state = Config.Toggles[key]

            
        local targetColor = state and VisualConfig.Colors.ToggleOn or VisualConfig.Colors.ToggleOff
        local targetPos = state and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        
        TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end)
end

local function AddFluentButton(parent, text,callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.96, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(38, 40, 55)
    btn.Text = "   " .. text
    btn.TextColor3 = VisualConfig.Colors.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local arrow = Instance.new("TextLabel", btn)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = "→"
    arrow.TextSize = 16
    arrow.TextColor3 = VisualConfig.Colors.MutedText
    arrow.Font = Enum.Font.Gotham
    arrow.BackgroundTransparency = 1

        
     AddTouchFeedback(btn)
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    end
    


-- MAQUETADO DE BOTONES
AddFluentToggle(t1, "NOCLIP", "Noclip")
AddFluentToggle(t1, "SPEED HACK", "WalkSpeed")
AddFluentToggle(t1, "INFJUMP", "InfJump")
AddFluentToggle(t1, "FOV", "FOV_Toggle")

AddFluentToggle(t2, "ESP INOCENTE", "ESP_Inno")
AddFluentToggle(t2, "ESP SHERIFF", "ESP_Sheriff")
AddFluentToggle(t2, "ESP ASESINO", "ESP_Murd")
AddFluentToggle(t2, "TRACES", "Traces")

AddFluentToggle(t3, "AIM/SHOOT", "Aimbot")
AddFluentToggle(t3, "HITBOX", "Hitbox")
AddFluentToggle(t3, "AURAKILL", "KillAura")

AddFluentButton(t4, "TP GUN 🔫", function()
    local g = workspace:FindFirstChild("Gun") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("Gun"))
    if g then lp.Character.HumanoidRootPart.CFrame = g.CFrame end
end)

AddFluentButton(t4, "TP SHERIFF 👮", function()
    if Config.Values.LastSheriffPos then lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos end
end)
)


-- [[ 📱 CONTENEDOR FLOTANTE DE ARRASTRE Y CONTROL ]]
local FloatingFrame = Instance.new("Frame", sg)
FloatingFrame.Size = UDim2.new(0, 180, 0, 85) -- Más alto para contener los dos elementos verticales
FloatingFrame.Position = UDim2.new(0, 30, 0.4, 0)
FloatingFrame.BackgroundTransparency = 1
MakeDraggable(FloatingFrame, true) -- Esta zona se arrastra libremente si no está bloqueada

-- 1. Botón superior TOGGLE (Simple, reactivo y sin errores)
local ToggleBtn = Instance.new("TextButton", FloatingFrame)
ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
ToggleBtn.Text = "TOGGLE MENU"
ToggleBtn.BackgroundColor3 = VisualConfig.Colors.Bg
ToggleBtn.TextColor3 = VisualConfig.Colors.Accent
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
local strokeT = Instance.new("UIStroke", ToggleBtn); strokeT.Color = VisualConfig.Colors.Accent; strokeT.Thickness = 1.8

-- 2. Tarjeta inferior LOCK / UNLOCK (Estilo Fluent Switch)
local LockCard = Instance.new("Frame", FloatingFrame)
LockCard.Size = UDim2.new(1, 0, 0, 38)
LockCard.Position = UDim2.new(0, 0, 0, 44)
LockCard.BackgroundColor3 = VisualConfig.Colors.Bg
Instance.new("UICorner", LockCard).CornerRadius = UDim.new(0, 10)
local strokeL = Instance.new("UIStroke", LockCard); strokeL.Color = Color3.fromRGB(80, 80, 100); strokeL.Thickness = 1.5

local LockLabel = Instance.new("TextLabel", LockCard)
LockLabel.Size = UDim2.new(0.6, 0, 1, 0)
LockLabel.Position = UDim2.new(0, 12, 0, 0)
LockLabel.Text = "MOVE (LOCK)"
LockLabel.TextColor3 = Color3.new(1,1,1)
LockLabel.Font = Enum.Font.GothamBold
LockLabel.TextSize = 10
LockLabel.TextXAlignment = Enum.TextXAlignment.Left
LockLabel.BackgroundTransparency = 1

local LockSwitch = Instance.new("TextButton", LockCard)
LockSwitch.Size = UDim2.new(0, 34, 0, 18)
LockSwitch.Position = UDim2.new(1, -44, 0.5, -9)
LockSwitch.Text = ""
LockSwitch.BackgroundColor3 = VisualConfig.Colors.ToggleOff -- Empieza apagado (O sea, desbloqueado para moverse)
Instance.new("UICorner", LockSwitch).CornerRadius = UDim.new(1, 0)

local LockCircle = Instance.new("Frame", LockSwitch)
LockCircle.Size = UDim2.new(0, 12, 0, 12)
LockCircle.Position = UDim2.new(0, 3, 0.5, -6)
LockCircle.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", LockCircle).CornerRadius = UDim.new(1, 0)


-- [[ ⚡ ACCIONES TÁCTILES DIRECTAS ]]

-- Acción abrir / cerrar menú
ToggleBtn.MouseButton1Click:Connect(function()
    VisualConfig.States.MainVisible = not VisualConfig.States.MainVisible
    if VisualConfig.States.MainVisible then
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 380, 0, 300)}):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(0.2, function() Main.Visible = false end)
    end
end)

X.MouseButton1Click:Connect(function()
    VisualConfig.States.MainVisible = false
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(0.2, function() Main.Visible = false end)
end)

-- Acción del Switch para congelar o mover la barra flotante
LockSwitch.MouseButton1Click:Connect(function()
    VisualConfig.States.UILocked = not VisualConfig.States.UILocked
    
    local targetColor = VisualConfig.States.UILocked and VisualConfig.Colors.Murd or VisualConfig.Colors.ToggleOff
    local targetPos = VisualConfig.States.UILocked and UDim2.new(0, 19, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    
    -- Animación visual del switch
    TweenService:Create(LockSwitch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(LockCircle, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    
    -- Cambios de texto informativos
    LockLabel.Text = VisualConfig.States.UILocked and "FIXED (UNLOCK)" or "MOVE (LOCK)"
    LockLabel.TextColor3 = VisualConfig.States.UILocked and VisualConfig.Colors.Murd or Color3.new(1,1,1)
    strokeL.Color = VisualConfig.States.UILocked and VisualConfig.Colors.Murd or Color3.fromRGB(80, 80, 100)
end)
