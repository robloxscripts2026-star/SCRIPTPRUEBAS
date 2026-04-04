-- [[ 🌌 FLOURITE SUPREME V29.0 - STABLE CORE 🌌 ]]
-- [[ DEVELOPERS: CODEX SCRIPTS & CHRIXUS ]]
-- [[ STATUS: CLEANED & OPTIMIZED FOR MOBILE ]]

task.wait(0.5)

-- [[ 🛠️ SERVICIOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 DATABASE: 25 KEYS ]]
local MANUAL_KEYS = {"CHKEY-2a7d9f3b1c", "CHKEY-5g1h4j6k8l", "CHKEY-9m2n0p5q3r", "CHKEY-4s6t8u1v7w", "CHKEY-3x5y9z2a4b", "CHKEY-7c1d3e6f8g", "CHKEY-2h5i7j9k1l", "CHKEY-6m8n3p0q2r", "CHKEY-1s4t6u9v3w", "CHKEY-5x2y7z4a6b", "CHKEY-8c3d5e1f9g", "CHKEY-4h9i2j5k7l", "CHKEY-7m1n6p8q4r", "CHKEY-3s5t9u2v6w", "CHKEY-6x8y3z1a5b", "CHKEY-9c2d7e4f1g", "CHKEY-5h3i8j2k6l", "CHKEY-2m7n4p1q9r", "CHKEY-8s1t5u7v3w", "CHKEY-4x6y2z9a3b", "CHKEY-1c9d4e7f2g", "CHKEY-6h7i1j8k4l", "CHKEY-3m5n9p2q6r", "CHKEY-7s3t8u4v9w", "CHKEY-2x9y5z6a8b"}

-- [[ ⚙️ CONFIGURACIÓN ]]
local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false, FOV_Toggle = false,
        Hitbox = false, ESP_Inno = false, ESP_Sheriff = false, ESP_Murd = false,
        Traces = false, UILocked = false
    },
    Values = {
        Speed = 65, FOV_Max = 120, FOV_Min = 70, HitboxSize = 25,
        LastSheriffPos = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 35, 35), Sher = Color3.fromRGB(0, 180, 255),
        Inno = Color3.fromRGB(0, 255, 140), Accent = Color3.fromRGB(0, 230, 255), Bg = Color3.fromRGB(15, 15, 20)
    }
}

-- [[ 🖱️ DRAGGABLE ENGINE (RE-BUILT) ]]
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
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then dragging = false end
    end)
end

-- [[ 🎯 HITBOX MAINTAINER ]]
RunService.RenderStepped:Connect(function()
    if Config.Toggles.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- [[ 👁️ ESP V2 (REPARADO) ]]
local active_esp = {}
local function CreateESP(p)
    if p == lp or active_esp[p] then return end
    local h = Instance.new("Highlight", CoreGui); h.OutlineTransparency = 0; h.FillTransparency = 0.5
    active_esp[p] = h
    local conn; conn = RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
            local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
            local role = isM and "M" or isS and "S" or "I"
            local col = (role == "M" and Config.Colors.Murd) or (role == "S" and Config.Colors.Sher) or Config.Colors.Inno
            local ena = (role == "M" and Config.Toggles.ESP_Murd) or (role == "S" and Config.Toggles.ESP_Sheriff) or (role == "I" and Config.Toggles.ESP_Inno)
            
            h.Enabled = ena; h.Adornee = p.Character; h.FillColor = col
            if role == "S" then Config.Values.LastSheriffPos = p.Character.HumanoidRootPart.CFrame end
        else h.Enabled = false end
        if not Players:FindFirstChild(p.Name) then h:Destroy(); active_esp[p] = nil; conn:Disconnect() end
    end)
end

-- [[ 🏙️ UI SUPREME V29 ]]
local function BuildUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "FLOURITE_V29"
    
    -- FLOATING FRAME (BOTONES MÁS GRANDES PARA TUS DEDOS)
    local FloatingFrame = Instance.new("Frame", sg); FloatingFrame.Name = "FloatingFrame"; FloatingFrame.Size = UDim2.new(0, 180, 0, 45); FloatingFrame.Position = UDim2.new(0, 20, 0.5, 0); FloatingFrame.BackgroundColor3 = Config.Colors.Bg; MakeDraggable(FloatingFrame); Instance.new("UICorner", FloatingFrame)
    
    local ToggleBtn = Instance.new("TextButton", FloatingFrame); ToggleBtn.Size = UDim2.new(0, 85, 1, 0); ToggleBtn.Text = "MENU"; ToggleBtn.BackgroundTransparency = 1; ToggleBtn.TextColor3 = Config.Colors.Accent; ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 14
    local LockBtn = Instance.new("TextButton", FloatingFrame); LockBtn.Size = UDim2.new(0, 85, 1, 0); LockBtn.Position = UDim2.new(0, 90, 0, 0); LockBtn.Text = "LOCK"; LockBtn.BackgroundTransparency = 1; LockBtn.TextColor3 = Color3.new(1,1,1); LockBtn.Font = Enum.Font.GothamBold; LockBtn.TextSize = 14

    -- PANEL PRINCIPAL
    local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 370, 0, 240); Main.Position = UDim2.new(0.5, -185, 0.5, -120); Main.BackgroundColor3 = Config.Colors.Bg; Main.Visible = false; Instance.new("UICorner", Main); local s = Instance.new("UIStroke", Main); s.Color = Config.Colors.Accent; MakeDraggable(Main)
    
    local X = Instance.new("TextButton", Main); X.Size = UDim2.new(0, 30, 0, 30); X.Position = UDim2.new(1, -35, 0, 5); X.Text = "X"; X.BackgroundColor3 = Color3.new(0.8, 0, 0); X.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", X)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 95, 1, -10); Sidebar.Position = UDim2.new(0, 5, 0, 5); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -110, 1, -10); Content.Position = UDim2.new(0, 105, 0, 5); Content.BackgroundTransparency = 1

    local function Tab(n)
        local f = Instance.new("ScrollingFrame", Content); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 2; Instance.new("UIListLayout", f).Padding = UDim.new(0, 5)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(25,25,30); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 9; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end); return f
    end

    local t1 = Tab("GENERAL ⚙️"); t1.Visible = true; local t2 = Tab("VISUAL 👾"); local t3 = Tab("COMBAT ⚔️"); local t4 = Tab("TELEPORT 🔮")

    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 35); b.Text = t .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 10; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() Config.Toggles[k] = not Config.Toggles[k]; b.Text = t .. (Config.Toggles[k] and " [ON]" or " [OFF]"); b.BackgroundColor3 = Config.Toggles[k] and Config.Colors.Accent or Color3.fromRGB(35, 35, 45); b.TextColor3 = Config.Toggles[k] and Color3.new(0,0,0) or Color3.new(1,1,1) end)
    end

    Toggle(t1, "NOCLIP", "Noclip"); Toggle(t1, "SPEED", "WalkSpeed"); Toggle(t1, "INF JUMP", "InfJump"); Toggle(t1, "FOV 120", "FOV_Toggle")
    Toggle(t2, "INNO ESP", "ESP_Inno"); Toggle(t2, "SHER ESP", "ESP_Sheriff"); Toggle(t2, "MURD ESP", "ESP_Murd")
    Toggle(t3, "HITBOX", "Hitbox")

    local function Btn(p, t, f) local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 35); b.Text = t; b.BackgroundColor3 = Color3.fromRGB(50,50,70); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 10; Instance.new("UICorner", b); b.MouseButton1Click:Connect(f) end
    Btn(t4, "TP GUN 🔫", function() local g = workspace:FindFirstChild("Gun") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("Gun")); if g then lp.Character.HumanoidRootPart.CFrame = g.CFrame end end)
    Btn(t4, "TP SHERIFF 👮", function() if Config.Values.LastSheriffPos then lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos else print("No Sheriff detectado") end end)

    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
    LockBtn.MouseButton1Click:Connect(function() Config.Toggles.UILocked = not Config.Toggles.UILocked; LockBtn.Text = Config.Toggles.UILocked and "UNLOCK" or "LOCK"; LockBtn.TextColor3 = Config.Toggles.UILocked and Config.Colors.Murd or Color3.new(1,1,1) end)
    X.MouseButton1Click:Connect(function() Main.Visible = false end)

    for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
    Players.PlayerAdded:Connect(CreateESP)
end

-- [[ 🚀 FÍSICAS ]]
UserInputService.JumpRequest:Connect(function() if Config.Toggles.InfJump and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid:ChangeState(3) end end)
RunService.Stepped:Connect(function()
    if Config.Toggles.Noclip and lp.Character then for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16 end
    camera.FieldOfView = Config.Toggles.FOV_Toggle and Config.Values.FOV_Max or Config.Values.FOV_Min
end)

-- [[ SISTEMA DE LLAVES ]]
local function RunLogin()
    local sg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 300, 0, 220); f.Position = UDim2.new(0.5, -150, 0.5, -110); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = Config.Colors.Accent; MakeDraggable(f)
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,0.3,0); t.Text = "FLOURITE SUPREME V29"; t.TextColor3 = Config.Colors.Accent; t.Font = Enum.Font.GothamBold; t.TextSize = 16; t.BackgroundTransparency = 1
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8,0,0,45); box.Position = UDim2.new(0.1,0,0.35,0); box.PlaceholderText = "KEY"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(25,25,35); Instance.new("UICorner", box)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8,0,0,45); btn.Position = UDim2.new(0.1,0,0.7,0); btn.Text = "LOGIN"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() for _, k in pairs(MANUAL_KEYS) do if box.Text == k then sg:Destroy(); BuildUI() return end end box.Text = "KEY INVÁLIDA" end)
end

RunLogin()
