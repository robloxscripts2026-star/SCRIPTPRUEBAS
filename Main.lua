-- [[ 🌌 FLOURITE VERSIÓN ]]

task.wait(0.5)

-- [[ 🛠️ SERVICIOS PRINCIPALES ]]
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
local mouse = lp:GetMouse()

-- [[ 🔑 BASE DE DATOS DE LLAVES (25 KEYS) ]]
local MANUAL_KEYS = {
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
        Aimbot = false, KillAura = false, Hitbox = false,
        ESP_Inno = false, ESP_Sheriff = false, ESP_Murd = false,
        Traces = false
    },
    Values = {
        Speed = 50, FOV_Max = 120, FOV_Min = 70, 
        HitboxSize = 12, AuraRange = 45, Smoothness = 0.11,
        LastSheriffPos = nil, GunPart = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 0, 0),
        Sher = Color3.fromRGB(0, 160, 255),
        Inno = Color3.fromRGB(0, 255, 120),
        Accent = Color3.fromRGB(0, 220, 255),
        Bg = Color3.fromRGB(12, 12, 22)
    }
}

-- [[ 🛰️ SISTEMA DE NOTIFICACIONES SUPREME ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 260, 0, 75); f.Position = UDim2.new(1, 10, 0.15, 0); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = color; s.Thickness = 2
    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1; tl.TextSize = 14
    local dl = Instance.new("TextLabel", f); dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = Enum.Font.Gotham; dl.BackgroundTransparency = 1; dl.TextSize = 12
    f:TweenPosition(UDim2.new(1, -275, 0.15, 0), "Out", "Back", 0.5)
    task.delay(3, function() if f then f:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5); task.wait(0.6); sg:Destroy() end end)
end

-- [[ 🖱️ MOTOR DE ARRASTRE (DRAGGABLE) ]]
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

-- [[ 🔍 IDENTIFICADOR DE ROLES ]]
local function GetPlayerRole(p)
    if not p or not p.Character then return "Inno" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murd" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sher" end
    return "Inno"
end

-- [[ 👾 APARTADO VISUAL: ESP ENGINE ]]
local active_esp = {}
local function ApplyESP(p)
    if active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui)
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if p and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetPlayerRole(p)
            highlight.Enabled = Config.Toggles["ESP_"..role]
            highlight.Adornee = p.Character
            highlight.FillColor = Config.Colors[role]
            highlight.OutlineColor = Color3.new(1,1,1)
        else
            highlight:Destroy(); connection:Disconnect(); active_esp[p] = nil
        end
    end)
    active_esp[p] = connection
end

-- [[ ⚔️ APARTADO COMBAT: LÓGICA MAESTRA ]]
local function StartCombatMotors()
    -- KILL AURA (45 STUDS)
    RunService.Stepped:Connect(function()
        if Config.Toggles.KillAura and GetPlayerRole(lp) == "Murd" then
            local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if knife then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if mag < Config.Values.AuraRange then
                            firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 0)
                            firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 1)
                        end
                    end
                end
            end
        end
    end)

    -- AIMBOT & HITBOX NEON
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart; local role = GetPlayerRole(p)
                
                -- Aimbot al Murderer
                if role == "Murd" and Config.Toggles.Aimbot then
                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, hrp.Position), Config.Values.Smoothness)
                end

                -- Hitbox Roja Neon al Murderer
                if role == "Murd" and Config.Toggles.Hitbox then
                    hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                    hrp.Transparency = 0.6; hrp.Color = Color3.new(1, 0, 0); hrp.Material = Enum.Material.Neon; hrp.CanCollide = false
                else
                    if hrp.Size ~= Vector3.new(2,2,1) then hrp.Size = Vector3.new(2,2,1); hrp.Material = Enum.Material.Plastic; hrp.Transparency = 1 end
                end
                
                -- Guardar posición del Sheriff para TP
                if role == "Sher" then Config.Values.LastSheriffPos = hrp.CFrame end
            end
        end
        
        -- FOV Dinámico
        camera.FieldOfView = Config.Toggles.Noclip and Config.Values.FOV_Max or Config.Values.FOV_Min
        
        -- Noclip
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        
        -- Speed Hack
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
    end)
end

-- [[ ⚙️ APARTADO GENERAL: INFINITE JUMP ]]
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- [[ 🔮 APARTADO TELEPORTS: FUNCIONES ]]
local function TeleportToGun()
    local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("GunPart") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop"))
    if gun then
        lp.Character.HumanoidRootPart.CFrame = gun.CFrame + Vector3.new(0, 3, 0)
        Notify("TELEPORT", "Has recogido el arma satisfactoriame.", Config.Colors.Accent)
    else
        Notify("ERROR", "funcion próximamente usuario.", Color3.new(1,0,0))
    end
end

local function TeleportToSheriff()
    if Config.Values.LastSheriffPos then
        lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos
        Notify("TELEPORT", "Teletransportado a la ubicación del Sheriff.", Config.Colors.Sher)
    else
        Notify("ERROR", "No se detecta al Sheriff en la partida.", Color3.new(1,0,0))
    end
end

-- [[ 🏙️ SISTEMA DE INTERFAZ (UI) ]]
local function CreateMainUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "Flourite_Supreme_V12"
    
    -- CÍRCULO FLOTANTE (BOTÓN DE APERTURA)
    local Circle = Instance.new("ImageButton", sg); Circle.Size = UDim2.new(0, 60, 0, 60); Circle.Position = UDim2.new(0, 30, 0.5, -30); Circle.BackgroundColor3 = Config.Colors.Bg; Circle.Image = "rbxassetid://6031068433"; Circle.Visible = false; Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Circle).Color = Config.Colors.Accent; MakeDraggable(Circle)

    -- CONTENEDOR PRINCIPAL
    local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 500, 0, 380); Main.Position = UDim2.new(0.5, -250, 0.5, -190); Main.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Config.Colors.Accent; MakeDraggable(Main)

    -- BOTÓN X (CERRAR)
    local X = Instance.new("TextButton", Main); X.Size = UDim2.new(0, 35, 0, 35); X.Position = UDim2.new(1, -42, 0, 7); X.Text = "X"; X.BackgroundColor3 = Color3.fromRGB(200, 0, 0); X.TextColor3 = Color3.new(1,1,1); X.Font = Enum.Font.GothamBold; Instance.new("UICorner", X)
    X.MouseButton1Click:Connect(function() Main.Visible = false; Circle.Visible = true; Notify("MENÚ", "Interfaz minimizada al círculo.", Config.Colors.Accent) end)
    Circle.MouseButton1Click:Connect(function() Main.Visible = true; Circle.Visible = false end)

    -- ESTRUCTURA DE PESTAÑAS
    local TabsFrame = Instance.new("Frame", Main); TabsFrame.Size = UDim2.new(0, 140, 1, -10); TabsFrame.Position = UDim2.new(0, 5, 0, 5); TabsFrame.BackgroundTransparency = 1; local layout = Instance.new("UIListLayout", TabsFrame); layout.Padding = UDim.new(0, 5)
    local ContentFrame = Instance.new("Frame", Main); ContentFrame.Size = UDim2.new(1, -155, 1, -60); ContentFrame.Position = UDim2.new(0, 150, 0, 50); ContentFrame.BackgroundTransparency = 1

    local function NewTab(name, icon)
        local f = Instance.new("ScrollingFrame", ContentFrame); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 2; Instance.new("UIListLayout", f).Padding = UDim.new(0, 6)
        local b = Instance.new("TextButton", TabsFrame); b.Size = UDim2.new(1, 0, 0, 42); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentFrame:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabsFrame:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(25, 25, 35) end end
            f.Visible = true; b.BackgroundColor3 = Config.Colors.Accent; b.TextColor3 = Color3.new(0,0,0)
        end)
        return f
    end

    local gTab = NewTab("GENERAL ⚙️"); gTab.Visible = true; local vTab = NewTab("VISUAL 👾"); local cTab = NewTab("COMBAT ⚔️"); local tTab = NewTab("TELEPORT 🔮")

    -- COMPONENTES: TOGGLES
    local function AddToggle(p, text, key)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 40); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 35, 50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]; b.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(35, 35, 50)
            b.TextColor3 = Config.Toggles[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    -- Llenado de Pestañas
    AddToggle(gTab, "NOCLIP", "Noclip"); AddToggle(gTab, "SPEED HACK", "WalkSpeed"); AddToggle(gTab, "INFINITE JUMP", "InfJump")
    AddToggle(vTab, "ESP INOCENTES", "ESP_Inno"); AddToggle(vTab, "ESP SHERIFF", "ESP_Sheriff"); AddToggle(vTab, "ESP ASESINO", "ESP_Murd")
    AddToggle(cTab, "AIMBOT (AUTO-LOCK)", "Aimbot"); AddToggle(cTab, "HITBOX ", "Hitbox"); AddToggle(cTab, "KILL AURA", "KillAura")

    -- COMPONENTES: BOTONES
    local function AddBtn(p, text, func)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 40); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(50, 50, 70); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(func)
    end
    AddBtn(tTab, "TP TO GUN 🔫", TeleportToGun); AddBtn(tTab, "TP TO SHERIFF 👮", TeleportToSheriff)

    Notify("BIENVENIDO USUARIO", "script cargado con éxito✅.", Config.Colors.Accent)
    StartCombatMotors()
end

-- [[ 🔑 SISTEMA DE ACCESO (LOGIN) ]]
local function RunLoginSystem()
    local sg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 320, 0, 240); f.Position = UDim2.new(0.5, -160, 0.5, -120); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = Config.Colors.Accent; s.Thickness = 2; MakeDraggable(f)
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0.3, 0); t.Text = "FLOURITE SUPREME"; t.TextColor3 = Config.Colors.Accent; t.Font = Enum.Font.GothamBold; t.TextSize = 20; t.BackgroundTransparency = 1
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8, 0, 0, 45); box.Position = UDim2.new(0.1, 0, 0.35, 0); box.PlaceholderText = "INGRESA TU KEY"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(20,20,30); Instance.new("UICorner", box)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8, 0, 0, 45); btn.Position = UDim2.new(0.1, 0, 0.65, 0); btn.Text = "LOGUEARSE"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if table.find(MANUAL_KEYS, box.Text) then
            sg:Destroy(); CreateMainUI()
            for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
            Players.PlayerAdded:Connect(function(p) task.wait(1); ApplyESP(p) end)
        else
            box.Text = ""; box.PlaceholderText = "LLAVE INCORRECTA"; box.PlaceholderColor3 = Color3.new(1,0,0)
        end
    end)
end

RunLoginSystem()
-- [[ FIN DEL CÓDIGO SUPREME - MÁS DE 500 LÍNEAS ]]
