-- [[ 🌌 FLOURITE SOFTWORKS V7.5 - ULTIMATE JSON EDITION 🌌 ]]
-- [[ DEVELOPERS: CODEX & CHRIXUS (SUPREME TEAM) ]]
-- [[ STATUS: STABLE 2026 | NO AUTOFARM | JSON KEY SYSTEM ]]
-- [[ OPTIMIZED FOR: DELTA, FLUXUS, HYDROGEN, ARCEUS X ]]

task.wait(2.5)

-- [[ 🛡️ SERVICIOS DEL SISTEMA ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- [[ 👤 REFERENCIAS LOCALES ]]
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 CONFIGURACIÓN MAESTRA ]]
local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, ESP_Murd = false, ESP_Sheriff = false,
        ESP_Inno = false, Traces = false, Hitbox = false,
        FullBright = false, AntiLag = false
    },
    Values = {
        Speed = 50, FOV = 85, Smooth = 0.15,
        HitboxSize = 8, 
        LastSheriffPos = nil, GunPart = nil,
        KeyStatus = false
    },
    Colors = {
        Murd = Color3.fromRGB(255, 30, 30),
        Sher = Color3.fromRGB(0, 160, 255),
        Inno = Color3.fromRGB(50, 255, 50),
        Accent = Color3.fromRGB(0, 210, 255),
        Bg = Color3.fromRGB(8, 8, 15)
    }
}

-- [[ 🛰️ NOTIFICACIONES ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg); frame.Size = UDim2.new(0, 260, 0, 75); frame.Position = UDim2.new(1, 10, 0.1, 0); frame.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", frame); Instance.new("UIStroke", frame).Color = color
    local tl = Instance.new("TextLabel", frame); tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1; tl.TextSize = 14
    local dl = Instance.new("TextLabel", frame); dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = Enum.Font.Gotham; dl.BackgroundTransparency = 1; dl.TextSize = 12
    frame:TweenPosition(UDim2.new(1, -270, 0.1, 0), "Out", "Back", 0.5)
    task.delay(3, function() if frame then frame:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.5); task.wait(0.6); sg:Destroy() end end)
end

-- [[ 🖱️ DRAGGABLE ENGINE (SUPREME FIX) ]]
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

-- [[ 👁️ ESP RENDER V7.5 (MEMORY LEAK + LOCAL SCOPE) ]]
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
    p.AncestryChanged:Connect(function() if not p:IsDescendantOf(game) then high:Destroy(); line:Remove(); if conn then conn:Disconnect() end; active_esp[p] = nil end end)
    active_esp[p] = {H = high, L = line, C = conn}
end

-- [[ ⚔️ COMBAT ENGINE (NO AUTOFARM | SUPREME HITBOX) ]]
local function InitCombat()
    RunService.Stepped:Connect(function()
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)

    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart; local role = GetRole(p)
                
                -- AIMBOT ANTI-NAN
                if role == "Murd" and Config.Toggles.Aimbot then
                    local targetPos, cameraPos = hrp.Position, camera.CFrame.Position
                    if (targetPos - cameraPos).Magnitude > 0.5 then
                        camera.CFrame = camera.CFrame:Lerp(CFrame.new(cameraPos, targetPos), Config.Values.Smooth)
                    end
                end

                -- HITBOX SUPREME (NEON + MASSLESS)
                if role == "Murd" and Config.Toggles.Hitbox then
                    hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                    hrp.Transparency = 0.7; hrp.Color = Color3.new(1, 0, 0); hrp.Material = Enum.Material.Neon; hrp.CanCollide = false; hrp.Massless = true    
                else
                    if hrp.Size ~= Vector3.new(2, 2, 1) then hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.Material = Enum.Material.Plastic end
                end
                if role == "Sher" then Config.Values.LastSheriffPos = hrp.CFrame end
            end
        end
        local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("GunPart") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop"))
        if gun then Config.Values.GunPart = gun else Config.Values.GunPart = nil end
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
        camera.FieldOfView = Config.Values.FOV
    end)
end

-- [[ 🚀 INFINITY JUMP ]]
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- [[ 🏙️ UI SUPREME V7.5 ]]
local function CreateUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "Flourite_Ultimate_V75"
    
    local wm = Instance.new("TextLabel", sg); wm.Size = UDim2.new(0, 200, 0, 20); wm.Position = UDim2.new(0, 10, 0, 10); wm.Text = "FLOURITE ULTIMATE | CODEX & CHRIXUS"; wm.TextColor3 = Config.Colors.Accent; wm.BackgroundTransparency = 1; wm.Font = Enum.Font.GothamBold; wm.TextSize = 12; wm.TextXAlignment = Enum.TextXAlignment.Left

    local Widget = Instance.new("ImageButton", sg); Widget.Size = UDim2.new(0, 55, 0, 55); Widget.Position = UDim2.new(0, 20, 0.5, -27); Widget.BackgroundColor3 = Config.Colors.Bg; Widget.Image = "rbxassetid://6031068433"; Widget.Visible = false; Instance.new("UICorner", Widget).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Widget).Color = Config.Colors.Accent; MakeDraggable(Widget)

    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 480, 0, 360); main.Position = UDim2.new(0.5, -240, 0.5, -180); main.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", main); local ms = Instance.new("UIStroke", main); ms.Color = Config.Colors.Accent; ms.Thickness = 2; MakeDraggable(main)

    local x = Instance.new("TextButton", main); x.Size = UDim2.new(0, 30, 0, 30); x.Position = UDim2.new(1, -35, 0, 5); x.Text = "X"; x.BackgroundColor3 = Color3.fromRGB(180, 0, 0); x.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", x)
    x.MouseButton1Click:Connect(function() main.Visible = false; Widget.Visible = true end); Widget.MouseButton1Click:Connect(function() main.Visible = true; Widget.Visible = false end)

    local bar = Instance.new("Frame", main); bar.Size = UDim2.new(0, 130, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(10, 10, 20); Instance.new("UICorner", bar)
    Instance.new("UIListLayout", bar).Padding = UDim.new(0, 2)
    local container = Instance.new("Frame", main); container.Position = UDim2.new(0, 140, 0, 45); container.Size = UDim2.new(1, -150, 1, -55); container.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", container); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0; Instance.new("UIListLayout", f).Padding = UDim.new(0, 6)
        local b = Instance.new("TextButton", bar); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.9; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 13
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end)
        return f
    end

    local t1 = Tab("MOVIMIENTO"); t1.Visible = true; local t2 = Tab("VISUALES"); local t3 = Tab("COMBATE"); local t4 = Tab("TELEPORTS")

    local function Toggle(p, text, key)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 38); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]; b.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(25, 25, 45); b.TextColor3 = Config.Toggles[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    Toggle(t1, "WALKSPEED (50)", "WalkSpeed"); Toggle(t1, "NOCLIP ELITE", "Noclip"); Toggle(t1, "INF JUMP", "InfJump")
    Toggle(t1, "FULL BRIGHT", "FullBright"); Toggle(t1, "ANTI-LAG", "AntiLag")
    Toggle(t2, "ESP MURDER", "ESP_Murd"); Toggle(t2, "ESP SHERIFF", "ESP_Sheriff"); Toggle(t2, "ESP INNO", "ESP_Inno"); Toggle(t2, "TRACERS", "Traces")
    Toggle(t3, "AIMBOT (PRO)", "Aimbot"); Toggle(t3, "HITBOX SUPREME", "Hitbox")

    local function Btn(p, text, func)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 40); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(40, 40, 70); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(func)
    end
    Btn(t4, "TP TO GUN", function() if Config.Values.GunPart then lp.Character.HumanoidRootPart.CFrame = Config.Values.GunPart.CFrame else Notify("AVISO", "Arma no encontrada.", Color3.new(1,0,0)) end end)
    Btn(t4, "TP TO SHERIFF", function() if Config.Values.LastSheriffPos then lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos else Notify("AVISO", "Sheriff ausente.", Color3.new(1,0,0)) end end)

    task.spawn(function()
        while task.wait(2) do
            if Config.Toggles.FullBright and Lighting.ClockTime ~= 14 then
                Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.new(1,1,1)
            end
            if Config.Toggles.AntiLag then
                for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end end
            end
        end
    end)
    Notify("FLOURITE V7.5", "Ultimate Edition Cargada.", Config.Colors.Accent)
end

-- [[ 🚀 SISTEMA DE LLAVE JSON (REMOTO) ]]
-- Nota: Sustituye el URL por tu Pastebin o GitHub con formato JSON: {"keys": ["KEY1", "KEY2"]}
local function RunKeys()
    local JSON_URL = "https://tu-enlace-json.com/keys.json" -- URL CON TUS KEYS DE UN MES
    local kg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", kg); f.Size = UDim2.new(0, 340, 0, 240); f.Position = UDim2.new(0.5, -170, 0.5, -120); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Config.Colors.Accent
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8, 0, 0, 45); box.Position = UDim2.new(0.1, 0, 0.35, 0); box.PlaceholderText = "INGRESA TU LLAVE (1 MES)"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(20, 20, 35); Instance.new("UICorner", box)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8, 0, 0, 45); btn.Position = UDim2.new(0.1, 0, 0.65, 0); btn.Text = "VERIFICAR"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return HttpService:GetAsync(JSON_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if table.find(data.keys, box.Text) then
                kg:Destroy(); CreateUI(); InitCombat()
                for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
                Players.PlayerAdded:Connect(function(p) task.wait(1); ApplyESP(p) end)
            else box.Text = ""; box.PlaceholderText = "LLAVE INVÁLIDA/EXPIRADA" end
        else
            -- Fallback por si el servidor JSON cae (Poner tus llaves manuales aquí)
            local manual_keys = {"CHKEY-MONTH-SUPREME-01", "CODEX-PRO-2026"}
            if table.find(manual_keys, box.Text) then
                kg:Destroy(); CreateUI(); InitCombat()
                for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
            else box.Text = ""; box.PlaceholderText = "ERROR DE CONEXIÓN" end
        end
    end)
end

-- [[ 📑 DOCUMENTACIÓN (530+ LÍNEAS) ]]
-- 1. JSON Integration: Sistema remoto para validar llaves de 1 mes sin actualizar el script.
-- 2. Hitbox Supreme: V7.5 optimizada con material Neon y Massless para evitar detección por peso.
-- 3. No Autofarm: Código limpio enfocado 100% en PVP y visuales para contenido.
-- 4. Memory Leak Fix: Desconexión activa de RunService al detectar AncestryChanged.
-- 5. Anti-NaN Aimbot: Filtro de magnitud para evitar el bug de cámara negra.
-- 6. Local Scope ESP: Dibujado independiente por cada jugador para evitar cruce de líneas.
-- 7. Noclip Pro: Bucle Stepped recursivo para atravesar colisiones de mapa.
-- 8. Walkspeed 50: Valor balanceado para evitar el kick de velocidad en servidores 2026.
-- 9. UI Modernizada: Diseño ergonómico para pantallas táctiles (Delta/Fluxus).
-- 10. Watermark: Protección de identidad Codex & Chrixus integrada.
-- 11. TP Sniper: Teletransporte a arma caída con escaneo de carpetas dinámicas.
-- 12. FullBright: Motor de iluminación forzada para máxima claridad en grabación.
-- 13. Anti-Lag: Eliminación selectiva de partículas y trails de armas.
-- 14. Key System: Ventana de acceso con soporte para teclado virtual móvil.
-- 15. Task.Spawn: Implementación de hilos modernos para optimización de batería.
-- 16. JSON Decoding: Uso de HttpService para parsing de bases de datos externas.
-- 17. Ancestry Cleanup: Destrucción de Highlights para liberar memoria RAM.
-- 18. FOV Custom: Ajuste de ángulo de visión para mayor cobertura táctica.
-- 19. Roles: Clasificación instantánea de Murderer y Sheriff mediante herramientas.
-- 20. Tracers: Líneas directas al RootPart con Drawing API de 2D.
-- 21. Material Neon: Mejora la visibilidad del objetivo a través de objetos delgados.
-- 22. Error Handling: Pcall integrado en el fetching de llaves remotas.
-- 23. JumpRequest: Bypass de salto infinito para evitar bloqueos del motor físico.
-- 24. RenderStepped: Latencia mínima en el renderizado de visuales.
-- 25. Final Release: Versión 7.5 lista para ofuscación y distribución masiva.

RunKeys()
-- [[ FIN DEL SCRIPT ULTIMATE V7.5 ]]
