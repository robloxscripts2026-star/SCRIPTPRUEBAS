-- [[ 🛠️ SERVICIOS DE INTERFAZ ]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ ⚙️ CONFIGURACIÓN VISUAL (ESTILO FLUENT) ]]
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
        UILocked = false
    }
}

-- Destruir interfaz anterior si existe para evitar duplicados al testear
if CoreGui:FindFirstChild("MM2_FLUENT_MENU") then
    CoreGui.MM2_FLUENT_MENU:Destroy()
end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "MM2_FLUENT_MENU"
sg.ResetOnSpawn = false

-- [[ 🖱️ MOTOR DRAGGABLE OPTIMIZADO (CON TWEEN) ]]
local function MakeDraggable(obj, isFloatingFrame)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if isFloatingFrame and VisualConfig.States.UILocked then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(obj, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

-- [[ 🚀 EFECTO TÁCTIL (BOUNCE SHOT) ]]
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


-- [[ 📱 CONTENEDOR TOGGLE / LOCK (BOTONES MÁS GRANDES) ]]
local FloatingFrame = Instance.new("Frame", sg)
FloatingFrame.Size = UDim2.new(0, 180, 0, 45) -- Más alto y ancho para mejor Hitbox táctil
FloatingFrame.Position = UDim2.new(0, 30, 0.4, 0)
FloatingFrame.BackgroundTransparency = 1
MakeDraggable(FloatingFrame, true)

-- Botón TOGGLE
local ToggleBtn = Instance.new("TextButton", FloatingFrame)
ToggleBtn.Size = UDim2.new(0, 85, 1, 0)
ToggleBtn.Text = "TOGGLE"
ToggleBtn.BackgroundColor3 = VisualConfig.Colors.Bg
ToggleBtn.TextColor3 = VisualConfig.Colors.Accent
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
local strokeT = Instance.new("UIStroke", ToggleBtn); strokeT.Color = VisualConfig.Colors.Accent; strokeT.Thickness = 1.8
AddTouchFeedback(ToggleBtn)

-- Botón LOCK
local LockBtn = Instance.new("TextButton", FloatingFrame)
LockBtn.Size = UDim2.new(0, 85, 1, 0)
LockBtn.Position = UDim2.new(0, 95, 0, 0)
LockBtn.Text = "LOCK"
LockBtn.BackgroundColor3 = VisualConfig.Colors.Bg
LockBtn.TextColor3 = Color3.new(1,1,1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = 13
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 10)
local strokeL = Instance.new("UIStroke", LockBtn); strokeL.Color = Color3.fromRGB(80, 80, 100); strokeL.Thickness = 1.8
AddTouchFeedback(LockBtn)


-- [[ 🌌 PANEL MAIN (380 x 300) ]]
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 380, 0, 300)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5) -- Abre y cierra desde su centro perfectamente
Main.BackgroundColor3 = VisualConfig.Colors.Bg
Main.ClipsDescendants = true
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16) -- Bordes más redondos y estéticos
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = VisualConfig.Colors.CardBg; MainStroke.Thickness = 1.5
MakeDraggable(Main, false)

-- Botón Cerrar (X) Estilizado
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

-- [[ 🗂️ DIVISIÓN: SIDEBAR Y CONTENIDO ]]
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

-- [[ 🎴 CREADOR DE PESTAÑAS (TAB SYSTEM) ]]
local tabs = {}
local activeTab = nil

local function CreateTab(name)
    local f = Instance.new("ScrollingFrame", Content)
    f.Size = UDim2.new(1, 0, 1, 0)
    f.Visible = false
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 2
    f.ScrollBarImageColor3 = VisualConfig.Colors.CardBg
    local scrollLayout = Instance.new("UIListLayout", f); scrollLayout.Padding = UDim.new(0, 8)
    
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
    
    -- Indicador visual izquierdo estilo Windows 11 Fluent
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

-- [[ 🎛️ COMPONENTES FLUENT (BOTONES Y SWITCHES GRANDES) ]]

-- Función para Toggles de Encendido/Apagado estilo Switch Cápsula
local function AddFluentToggle(parent, text)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(0.96, 0, 0, 42) -- Más alto, más cómodo para dedos
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
    
    -- El switch exterior (Fondo de la píldora)
    local switch = Instance.new("TextButton", card)
    switch.Size = UDim2.new(0, 36, 0, 20)
    switch.Position = UDim2.new(1, -46, 0.5, -10)
    switch.Text = ""
    switch.BackgroundColor3 = VisualConfig.Colors.ToggleOff
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    -- El círculo interior del switch
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local state = false
    switch.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and VisualConfig.Colors.ToggleOn or VisualConfig.Colors.ToggleOff
        local targetPos = state and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        
        TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end)
end

-- Función para Botones Simples de Acción (Teleports)
local function AddFluentButton(parent, text)
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
    
    btn.MouseButton1Click:Connect(function()
        -- Aquí irá la acción visual al presionarse más adelante
    end)
end

-- [[ 📝 AGREGANDO LOS NOMBRES DE LAS FUNCIONES DIRECTO AL MAQUETADO ]]
AddFluentToggle(t1, "NOCLIP")
AddFluentToggle(t1, "SPEED HACK")
AddFluentToggle(t1, "INFJUMP")
AddFluentToggle(t1, "FOV")

AddFluentToggle(t2, "ESP INOCENTE")
AddFluentToggle(t2, "ESP SHERIFF")
AddFluentToggle(t2, "ESP ASESINO")
AddFluentToggle(t2, "TRACES")

AddFluentToggle(t3, "AIM/SHOOT")
AddFluentToggle(t3, "HITBOX")
AddFluentToggle(t3, "AURAKILL")

AddFluentButton(t4, "TP GUN 🔫")
AddFluentButton(t4, "TP SHERIFF 👮")

-- [[ ⚡ ACCIONES DE APERTURA Y CIERRE CON ANIMACIÓN ]]
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

LockBtn.MouseButton1Click:Connect(function()
    VisualConfig.States.UILocked = not VisualConfig.States.UILocked
    LockBtn.Text = VisualConfig.States.UILocked and "UNLOCK" or "LOCK"
    LockBtn.TextColor3 = VisualConfig.States.UILocked and VisualConfig.Colors.Murd or Color3.new(1,1,1)
    strokeL.Color = VisualConfig.States.UILocked and VisualConfig.Colors.Murd or Color3.fromRGB(80, 80, 100)
end)
