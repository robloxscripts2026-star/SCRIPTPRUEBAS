--  VICE CITY HUB V2 👻
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Configuración de Estado General
local Config = {
    SpeedValue = 16, SpeedEnabled = false, InfJump = false, Noclip = false, Fly = false,
    SilentAim = false, FOVEnabled = false, FOVRadius = 100,
    ESPBox = false, ESPName = false, ESPDist = false, ESPHealth = false, Traces = false
}

-- Paleta de Colores por Sección
local Theme = {
    Main = Color3.fromRGB(0, 255, 230),    -- Cian Neón Eléctrico
    Combat = Color3.fromRGB(255, 60, 80),  -- Rojo Carmesí
    Visuals = Color3.fromRGB(255, 210, 0), -- Amarillo Oro Neón
    Misc = Color3.fromRGB(160, 80, 255)    -- Morado Cyberpunk
}

--  Función de arrastrar 
local function MakeSmoothDrag(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    local targetPos = frame.Position

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        frame.Position = frame.Position:Lerp(targetPos, 0.15)
    end)
end

--  Contenedor Principal
local ScreenGui;
local success, err = pcall(function()
    ScreenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui"):FindFirstChild("Modules") 
        and Instance.new("ScreenGui", game:GetService("CoreGui"):FindFirstChild("RobloxGui"))
        or Instance.new("ScreenGui", game:GetService("CoreGui"))
end)
if not success or not ScreenGui then
    ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
end
ScreenGui.Name = "ViceCityV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true


--  MOSTRAR INTRO INMEDIATAMENTE 
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12) 
IntroFrame.ZIndex = 100
IntroFrame.Parent = ScreenGui

local TopBarIntro = Instance.new("Frame")
TopBarIntro.Size = UDim2.new(1, 0, 0, 0)
TopBarIntro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopBarIntro.BorderSizePixel = 0
TopBarIntro.ZIndex = 105
TopBarIntro.Parent = IntroFrame

local BottomBarIntro = Instance.new("Frame")
BottomBarIntro.Size = UDim2.new(1, 0, 0, 0)
BottomBarIntro.Position = UDim2.new(0, 0, 1, 0)
BottomBarIntro.AnchorPoint = Vector2.new(0, 1)
BottomBarIntro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BottomBarIntro.BorderSizePixel = 0
BottomBarIntro.ZIndex = 105
BottomBarIntro.Parent = IntroFrame

local ParticlesFolder = Instance.new("Folder", IntroFrame)
local activeTweens = {}

for i = 1, 20 do
    local square = Instance.new("Frame")
    local size = math.random(15, 55)
    square.Size = UDim2.new(0, size, 0, size)
    square.Position = UDim2.new(math.random(5, 95) / 100, 0, math.random(100, 140) / 100, 0)
    square.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    square.BackgroundTransparency = math.random(88, 97) / 100 
    square.Rotation = math.random(0, 360)
    square.BorderSizePixel = 0
    square.ZIndex = 101
    square.Parent = ParticlesFolder

    local pTween = TweenService:Create(square, TweenInfo.new(math.random(5, 9), Enum.EasingStyle.Linear), {
        Position = UDim2.new(square.Position.X.Scale, 0, -0.2, 0),
        Rotation = square.Rotation + math.random(90, 360) 
    })
    pTween:Play()
    table.insert(activeTweens, pTween)
end

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(1, 0, 1, 0)
IntroText.Position = UDim2.new(0, 0, -0.04, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "VICE CITY HUB"
IntroText.Font = Enum.Font.GothamBlack
IntroText.TextSize = 1 
IntroText.TextTransparency = 1 
IntroText.ZIndex = 103
IntroText.Parent = IntroFrame

local TextStroke = Instance.new("UIStroke")
TextStroke.Thickness = 3.5
TextStroke.Transparency = 1
TextStroke.Parent = IntroText

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, 0, 0, 50)
SubText.Position = UDim2.new(0, 0, 0.56, 0)
SubText.BackgroundTransparency = 1
SubText.Text = "C A R G A N D O   S I S T E M A . . ."
SubText.TextColor3 = Color3.fromRGB(200, 200, 200)
SubText.Font = Enum.Font.Gotham
SubText.TextSize = 13
SubText.TextTransparency = 1
SubText.ZIndex = 103
SubText.Parent = IntroFrame

local themeColors = {Theme.Main, Theme.Combat, Theme.Visuals, Theme.Misc}
local rgbConnection = RunService.RenderStepped:Connect(function()
    if IntroText and IntroText.Parent then
        local t = os.clock() * 1.5
        local index = math.floor(t % #themeColors) + 1
        local nextIndex = (index % #themeColors) + 1
        local alpha = t % 1
        local currentColor = themeColors[index]:Lerp(themeColors[nextIndex], alpha)
        IntroText.TextColor3 = currentColor
        TextStroke.Color = currentColor
    end
end)


--   CONSTRUCCIÓN DEL MENÚ EN SEGUNDO PLANO 
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 270)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true 
MainFrame.Visible = false 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Main
MainStroke.Thickness = 1.6
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "VICE CITY HUB V2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 5)
CloseBtn.Text = "×" 
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar

MakeSmoothDrag(MainFrame, TopBar)

local TabPanel = Instance.new("Frame")
TabPanel.Size = UDim2.new(0, 110, 1, -42)
TabPanel.Position = UDim2.new(0, 0, 0, 42)
TabPanel.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
TabPanel.BorderSizePixel = 0
TabPanel.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 4)
TabList.Parent = TabPanel

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.Parent = TabPanel

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -110, 1, -42)
PageContainer.Position = UDim2.new(0, 110, 0, 42)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 50, 0, 50) 
OpenBtn.Position = UDim2.new(0.03, 0, 0.5, -25) 
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
OpenBtn.Text = "🌪️"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 24
OpenBtn.Visible = false 
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Theme.Main
OpenStroke.Thickness = 1.6
OpenStroke.Parent = OpenBtn

MakeSmoothDrag(OpenBtn, OpenBtn)

RunService.RenderStepped:Connect(function(dt)
    if OpenBtn.Visible then
        OpenBtn.Rotation = OpenBtn.Rotation + (dt * 120)
    end
end)

-- Estructuras de control necesarias para las animaciones
local Pages = {}
local TabButtons = {}
local isTweening = false

--  ANIMACIÓNESDE APERTURA Y CIERRE 
CloseBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    isTweening = true
    
    local closeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    local mainClose = TweenService:Create(MainFrame, closeInfo, {
        Size = UDim2.new(0, 300, 0, 180),
        BackgroundTransparency = 1
    })
    
    local strokeClose = TweenService:Create(MainStroke, closeInfo, {
        Transparency = 1
    })
    
    pcall(function()
        TweenService:Create(TopBar, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Title, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        TweenService:Create(TabPanel, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        
        for _, p in pairs(Pages) do p.Visible = false end
        for _, btn in pairs(TabButtons) do
            TweenService:Create(btn, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        end
    end)
    
    mainClose:Play()
    strokeClose:Play()
    
    mainClose.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
        OpenBtn.Size = UDim2.new(0, 0, 0, 0)
        local openAnim = TweenService:Create(OpenBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 50, 0, 50)})
        openAnim:Play()
        openAnim.Completed:Connect(function() isTweening = false end)
    end)
end)

OpenBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    isTweening = true
    
    local hideTween = TweenService:Create(OpenBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    hideTween:Play()
    
    hideTween.Completed:Connect(function()
        OpenBtn.Visible = false
        
        MainFrame.BackgroundTransparency = 0
        MainStroke.Transparency = 0
        pcall(function()
            TopBar.BackgroundTransparency = 0
            Title.TextTransparency = 0
            CloseBtn.TextTransparency = 0
            TabPanel.BackgroundTransparency = 0
            for _, btn in pairs(TabButtons) do
                TweenService:Create(btn, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
            end
        end)
        
        if Pages["Main"] then
            Pages["Main"].Visible = true
        end
        
        MainFrame.Size = UDim2.new(0, 10, 0, 10) 
        MainFrame.BackgroundTransparency = 1
        MainStroke.Transparency = 1
        MainFrame.Visible = true
        
        local openInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        local mainOpen = TweenService:Create(MainFrame, openInfo, {
            Size = UDim2.new(0, 460, 0, 270),
            BackgroundTransparency = 0
        })
        
        local strokeOpen = TweenService:Create(MainStroke, openInfo, {
            Transparency = 0
        })
        
        mainOpen:Play()
        strokeOpen:Play()
        mainOpen.Completed:Connect(function() isTweening = false end)
    end)
end)


-- COMPONENTES COLOREADOS
local function CreateTab(name, sectionColor)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.Text = name:upper()
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 11
    TabBtn.TextColor3 = Color3.fromRGB(100, 105, 115)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Parent = TabPanel

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = sectionColor
    Page.Parent = PageContainer

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 6)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Parent = Page

    local PagePad = Instance.new("UIPadding")
    PagePad.PaddingTop = UDim.new(0, 10)
    PagePad.PaddingBottom = UDim.new(0, 10)
    PagePad.Parent = Page
    
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = false end
        for btnName, btnObj in pairs(TabButtons) do 
            TweenService:Create(btnObj, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(100, 105, 115)}):Play()
        end
        Page.Visible = true
        TweenService:Create(MainStroke, TweenInfo.new(0.25), {Color = sectionColor}):Play()
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = sectionColor}):Play()
    end)

    Pages[name] = Page
    TabButtons[name] = TabBtn
    return Page
end

local function AddToggle(page, text, configKey, sectionColor)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.92, 0, 0, 38)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = page

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 6)
    tc.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12.5
    Label.TextColor3 = Color3.fromRGB(220, 225, 235)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = ToggleFrame

    local OuterSwitch = Instance.new("TextButton")
    OuterSwitch.Size = UDim2.new(0, 38, 0, 20)
    OuterSwitch.Position = UDim2.new(1, -50, 0.5, -10)
    OuterSwitch.BackgroundColor3 = Config[configKey] and sectionColor or Color3.fromRGB(45, 48, 58)
    OuterSwitch.Text = ""
    OuterSwitch.Parent = ToggleFrame
    
    local osc = Instance.new("UICorner")
    osc.CornerRadius = UDim.new(1, 0)
    osc.Parent = OuterSwitch

    local InnerCircle = Instance.new("Frame")
    InnerCircle.Size = UDim2.new(0, 14, 0, 14)
    InnerCircle.Position = Config[configKey] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    InnerCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InnerCircle.BorderSizePixel = 0
    InnerCircle.Parent = OuterSwitch

    local icc = Instance.new("UICorner")
    icc.CornerRadius = UDim.new(1, 0)
    icc.Parent = InnerCircle

    OuterSwitch.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        TweenService:Create(OuterSwitch, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Config[configKey] and sectionColor or Color3.fromRGB(45, 48, 58)}):Play()
        TweenService:Create(InnerCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = Config[configKey] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
    end)
end

local function AddSlider(page, text, min, max, default, configKey, sectionColor)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.92, 0, 0, 48)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = page
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 6)
    sc.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 4)
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(220, 225, 235)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = SliderFrame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.3, 0, 0, 22)
    ValLabel.Position = UDim2.new(1, -48, 0, 4)
    ValLabel.Text = tostring(default)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 12
    ValLabel.TextColor3 = sectionColor
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.BackgroundTransparency = 1
    ValLabel.Parent = SliderFrame

    local SlideBar = Instance.new("TextButton")
    SlideBar.Size = UDim2.new(1, -24, 0, 5)
    SlideBar.Position = UDim2.new(0, 12, 0.72, -2)
    SlideBar.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    SlideBar.Text = ""
    SlideBar.Parent = SliderFrame
    
    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(1, 0)
    sbc.Parent = SlideBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = sectionColor
    Fill.BorderSizePixel = 0
    Fill.Parent = SlideBar
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

    local function UpdateSlider(input)
        local percentage = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        TweenService:Create(Fill, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        local value = math.floor(min + (percentage * (max - min)))
        ValLabel.Text = tostring(value)
        Config[configKey] = value
    end

    local sliding = false
    SlideBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
end

local function AddButton(page, text, sectionColor)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.92, 0, 0, 36)
    Button.BackgroundColor3 = Color3.fromRGB(24, 27, 34)
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.TextColor3 = sectionColor
    Button.Parent = page
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = Button
    
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(34, 38, 48)}):Play()
        end
    end)
    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(24, 27, 34)}):Play()
        end
    end)
end

--  INICIALIZACIÓN DE CATEGORÍAS 
local TabMain = CreateTab("Main", Theme.Main)
local TabCombat = CreateTab("Combat", Theme.Combat)
local TabVisuals = CreateTab("Visuals", Theme.Visuals)
local TabMisc = CreateTab("Misc", Theme.Misc)

if Pages["Main"] then
    Pages["Main"].Visible = true
    if TabButtons["Main"] then TabButtons["Main"].TextColor3 = Theme.Main end
end

-- Añadir Elementos del Menú
AddToggle(TabMain, "Speed Hack", "SpeedEnabled", Theme.Main)
AddSlider(TabMain, "Speed Power", 16, 300, 16, "SpeedValue", Theme.Main)
AddToggle(TabMain, "Infinity Jump", "InfJump", Theme.Main)
AddToggle(TabMain, "Noclip", "Noclip", Theme.Main)
AddToggle(TabMain, "Fly (Vuelo)", "Fly", Theme.Main)

AddToggle(TabCombat, "Silent Aim", "SilentAim", Theme.Combat)
AddToggle(TabCombat, "Show FOV Anillo", "FOVEnabled", Theme.Combat)
AddSlider(TabCombat, "FOV Radio", 30, 300, 100, "FOVRadius", Theme.Combat)

AddToggle(TabVisuals, "ESP Box", "ESPBox", Theme.Visuals)
AddToggle(TabVisuals, "ESP Name", "ESPName", Theme.Visuals)
AddToggle(TabVisuals, "ESP Distancia", "ESPDist", Theme.Visuals)
AddToggle(TabVisuals, "ESP Health", "ESPHealth", Theme.Visuals)
AddToggle(TabVisuals, "Traces", "Traces", Theme.Visuals)

AddButton(TabMisc, "Server Hop", Theme.Misc)
AddButton(TabMisc, "Rejoin Server", Theme.Misc)


--  EJECUCIÓN CRONOMETRADA 
task.spawn(function()
    TweenService:Create(TopBarIntro, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0.14, 0)}):Play()
    TweenService:Create(BottomBarIntro, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0.14, 0)}):Play()
    task.wait(0.4)

    TweenService:Create(IntroText, TweenInfo.new(1.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {TextSize = 55, TextTransparency = 0}):Play()
    TweenService:Create(TextStroke, TweenInfo.new(1.5), {Transparency = 0.4}):Play()
    task.wait(0.6)

    TweenService:Create(SubText, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {TextTransparency = 0.2}):Play()
    task.wait(2.0)

    TweenService:Create(TopBarIntro, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)}):Play()
    TweenService:Create(BottomBarIntro, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)}):Play()

    local fadeInfo = TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    TweenService:Create(IntroText, fadeInfo, {TextTransparency = 1, TextSize = 85}):Play()
    TweenService:Create(TextStroke, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(SubText, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(IntroFrame, fadeInfo, {BackgroundTransparency = 1}):Play()

    for _, p in pairs(ParticlesFolder:GetChildren()) do
        TweenService:Create(p, fadeInfo, {BackgroundTransparency = 1}):Play()
    end

    task.wait(1.0)
    
    if rgbConnection then rgbConnection:Disconnect() end
    for _, t in pairs(activeTweens) do pcall(function() t:Cancel() end) end
    IntroFrame:Destroy()
    
    OpenBtn.Size = UDim2.new(0, 0, 0, 0)
    OpenBtn.Visible = true
    TweenService:Create(OpenBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)


-- ==========================================
-- SISTEMA DE ESP COMPLETO (ULTRA-ALTA CALIDAD & FIABLE)
-- ==========================================

local function CreateESP(player)
    -- Inicialización de librerías nativas de alta velocidad
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1.8
    box.Color = Theme.Visuals
    box.Filled = false

    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Center = true
    nameText.Outline = true
    nameText.Size = 13
    nameText.Font = 2
    nameText.Color = Color3.fromRGB(255, 255, 255)

    local distText = Drawing.new("Text")
    distText.Visible = false
    distText.Center = true
    distText.Outline = true
    distText.Size = 11
    distText.Font = 2
    distText.Color = Color3.fromRGB(220, 220, 220)

    local healthBar = Drawing.new("Line")
    healthBar.Visible = false
    healthBar.Thickness = 2

    local traceLine = Drawing.new("Line")
    traceLine.Visible = false
    traceLine.Thickness = 1
    traceLine.Color = Theme.Visuals

    local connection
    connection = RunService.RenderStepped:Connect(function()
        -- SISTEMA SEGURO: Verificamos minuciosamente que el personaje esté cargado por completo
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local head = character.Head
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local camera = workspace.CurrentCamera

            -- Filtro de renderizado en pantalla (Frustum Check de alta fidelidad)
            local vector, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                -- Cálculo geométrico de alta fidelidad basado en distancias entre articulaciones reales
                -- Esto previene fallos si el BoundingBox da nulo por lag de accesorios
                local distance = (camera.CFrame.Position - rootPart.Position).Magnitude
                
                -- Proyectamos la posición exacta por encima de la cabeza y por debajo de los pies
                local topPos, topOnScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.8, 0))
                local bottomPos, bottomOnScreen = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))

                if topOnScreen and bottomOnScreen then
                    -- Ajuste dinámico de escala impecable
                    local boxHeight = math.abs(topPos.Y - bottomPos.Y)
                    local boxWidth = boxHeight * 0.60 

                    -- === CONTROL DE ESP BOX ===
                    if Config.ESPBox then
                        box.Visible = true
                        box.Position = Vector2.new(vector.X - (boxWidth / 2), topPos.Y)
                        box.Size = Vector2.new(boxWidth, boxHeight)
                    else
                        box.Visible = false
                    end

                    -- === CONTROL DE ESP NAME ===
                    if Config.ESPName then
                        nameText.Visible = true
                        nameText.Position = Vector2.new(vector.X, topPos.Y - 16)
                        nameText.Text = player.Name
                    else
                        nameText.Visible = false
                    end

                    -- === CONTROL DE ESP DISTANCIA ===
                    if Config.ESPDist then
                        distText.Visible = true
                        distText.Position = Vector2.new(vector.X, bottomPos.Y + 4)
                        distText.Text = string.format("[%d studs]", math.floor(distance))
                    else
                        distText.Visible = false
                    end

                    -- === CONTROL DE ESP HEALTH ===
                    if Config.ESPHealth then
                        healthBar.Visible = true
                        local healthPercentage = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        local barX = vector.X - (boxWidth / 2) - 6
                        
                        healthBar.From = Vector2.new(barX, bottomPos.Y)
                        healthBar.To = Vector2.new(barX, bottomPos.Y - (boxHeight * healthPercentage))
                        -- Interpolación de color premium de verde a rojo líquida
                        healthBar.Color = Color3.fromHSV((healthPercentage * 120) / 360, 1, 1)
                    else
                        healthBar.Visible = false
                    end

                    -- === CONTROL DE TRACES (LÍNEAS DESDE ARRIBA COREGIDAS) ===
                    if Config.Traces then
                        traceLine.Visible = true
                        -- Coordenada Y puesta en 0 para que nazcan desde la parte superior central de tu pantalla
                        traceLine.From = Vector2.new(camera.ViewportSize.X / 2, 0)
                        traceLine.To = Vector2.new(vector.X, topPos.Y)
                    else
                        traceLine.Visible = false
                    end
                end
            else
                -- Ocultar elementos de dibujo de forma segura si el jugador sale de foco
                box.Visible = false
                nameText.Visible = false
                distText.Visible = false
                healthBar.Visible = false
                traceLine.Visible = false
            end
        else
            -- Limpieza de memoria (Anti-Crash y Cero Lag)
            box:Destroy()
            nameText:Destroy()
            distText:Destroy()
            healthBar:Destroy()
            traceLine:Destroy()
            connection:Disconnect()
        end
    end)
end
-- ========================================================
-- APUNTADORES GLOBALES AUTOMÁTICOS (CORRECCIÓN DE INGRESO)
-- ========================================================

-- Función interna para gestionar de forma segura la aparición del personaje
local function MonitorPlayer(player)
    if player == LocalPlayer then return end

    -- Conector principal cada vez que el jugador reaparezca (Spawn o muerte)
    player.CharacterAdded:Connect(function(character)
        -- Esperas preventivas seguras para asegurar existencia física en Workspace
        local root = character:WaitForChild("HumanoidRootPart", 10)
        local head = character:WaitForChild("Head", 10)
        local humanoid = character:WaitForChild("Humanoid", 10)
        
        if root and head and humanoid then
            task.wait(0.2) -- Micro-retraso premium para evitar desajustes de accesorios y lag de red
            CreateESP(player)
        end
    end)

    -- CHEQUEO DE SEGURIDAD: Si el jugador ya entró y su personaje ya existía antes de que corriera el evento
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        CreateESP(player)
    end
end

-- 1. Escuchar de forma activa y en tiempo real a todo jugador NUEVO que se una al servidor
Players.PlayerAdded:Connect(MonitorPlayer)

-- 2. Aplicar inmediatamente el detector a todos los jugadores que YA estaban dentro del servidor
for _, player in pairs(Players:GetPlayers()) do
    MonitorPlayer(player)
end

-- Conexión robusta para jugadores actuales y futuros
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if player ~= LocalPlayer then
            -- Espera de seguridad integrada para asegurar la carga completa de las extremidades
            player.Character:WaitForChild("HumanoidRootPart", 5)
            player.Character:WaitForChild("Head", 5)
            CreateESP(player)
        end
    end)
end)
