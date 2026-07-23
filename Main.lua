-- CONFLICTO DE BALAS 
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character
if not Character then
    LocalPlayer.CharacterAdded:Wait()
    Character = LocalPlayer.Character
end

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)
local Camera = workspace.CurrentCamera
-- Construcción del FOV Circle 
local FOVCircle
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1.5
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Filled = false
end)




-- Configuración de Estado General
local Config = {
    -- Player Cheats
    SpeedValue = 16, 
    SpeedEnabled = false, 
    InfJump = false, 
    Noclip = false, 
    Fly = false, 
    SpinBot = false,      
    SpinSpeed = 30,       
    HideName = false,     
    
    -- Combat
    AimbotEnabled = false,
    SilentAim = false,
    FOVEnabled = false, 
    FOVRadius = 100,
    WallCheck = true,
    TargetPart ="HumanoidRootPart",
    
    -- Visuals 
    ESPBox = false, 
    ESPName = false, 
    ESPDist = false, 
    ESPHealth = false, 
    Traces = false,
    ESPGun = false, 
    ESPGunDist = false,
    
    -- Misc
    LockUI = false
}







-- Paleta de Colores por Sección
local Theme = {
    Main = Color3.fromRGB(160, 80, 255), 
    Combat = Color3.fromRGB(160, 80, 255),
    Visuals = Color3.fromRGB(160, 80, 255),
    Misc = Color3.fromRGB(160, 80, 255)
}
 
--  Función de arrastrar 
local function MakeSmoothDrag(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    local targetPos = frame.Position

    dragHandle.InputBegan:Connect(function(input)
    
        if Config.LockUI then return end 

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
        if not Config.LockUI and dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput and not Config.LockUI then
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
local MainFrame
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
IntroText.Text = "CONFLICT BULLET"
IntroText.Font = Enum.Font.GothamBlack
IntroText.TextSize = 35 
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.TextTransparency = 0 
IntroText.ZIndex = 103
IntroText.Parent = IntroFrame

local TextStroke = Instance.new("UIStroke")
TextStroke.Thickness = 3.5
TextStroke.Transparency = 0 
TextStroke.Parent = IntroText

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, 0, 0, 50)
SubText.Position = UDim2.new(0, 0, 0.56, 0)
SubText.BackgroundTransparency = 1
SubText.Text = "C A R G A N D O   S I S T E M A . . ."
SubText.TextColor3 = Color3.fromRGB(200, 200, 200)
SubText.Font = Enum.Font.Gotham
SubText.TextSize = 13
SubText.TextTransparency = 0 
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


-- SECUENCIA DE CIERRE DE LA INTRODUCCIÓN
task.spawn(function()
    task.wait(3.5) 

    if IntroText and SubText then
        
        TweenService:Create(IntroText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextSize = 35,
            TextTransparency = 1
        }):Play()
        
        TweenService:Create(TextStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1
        }):Play()

        TweenService:Create(SubText, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            TextTransparency = 1
        }):Play()
        
        task.wait(0.5)
    end

    
    if IntroFrame then
        local fadeTween = TweenService:Create(IntroFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1
        })
        fadeTween:Play()
        
        fadeTween.Completed:Connect(function()
            
            IntroFrame:Destroy()
            if rgbConnection then rgbConnection:Disconnect() end
            
    if MainFrame then
        MainFrame.Visible = true
        if Pages["Main"] and TabButtons["Main"] then
            Pages["Main"].Visible = true
            TabButtons["Main"].TextColor3 = Theme.Main
        end
    end
end)
    end
end)
                    



--   CONSTRUCCIÓN DEL MENÚ EN SEGUNDO PLANO 
MainFrame = Instance.new("Frame")
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
Title.Text = "CONFLICT BULLET👾"
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

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 14)
TabCorner.Parent = TabPanel

local TabFixLeft = Instance.new("Frame")
TabFixLeft.Size = UDim2.new(1, 0, 0, 15)
TabFixLeft.Position = UDim2.new(0, 0, 0, 0)
TabFixLeft.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
TabFixLeft.BorderSizePixel = 0
TabFixLeft.ZIndex = 2
TabFixLeft.Parent = TabPanel


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

-- BOTÓN FLOTANTE 
local OpenBtnFrame = Instance.new("Frame")
OpenBtnFrame.Name = "OpenBtnFrame"
OpenBtnFrame.Size = UDim2.new(0, 56, 0, 56) 
OpenBtnFrame.Position = UDim2.new(0.03, 0, 0.5, -28) 
OpenBtnFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
OpenBtnFrame.Visible = false 
OpenBtnFrame.ClipsDescendants = true
OpenBtnFrame.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(1, 0)
OpenBtnCorner.Parent = OpenBtnFrame

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Theme.Main
OpenStroke.Thickness = 1.8
OpenStroke.Parent = OpenBtnFrame

local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(1, -6, 1, -6)
OpenBtn.Position = UDim2.new(0, 3, 0, 3)
OpenBtn.Image = "rbxassetid://122763495406604"
OpenBtn.BackgroundTransparency = 1
OpenBtn.AutoButtonColor = true
OpenBtn.Active = true
OpenBtn.Parent = OpenBtnFrame

local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(1, 0)
ImageCorner.Parent = OpenBtn


MakeSmoothDrag(OpenBtnFrame, OpenBtn)

RunService.RenderStepped:Connect(function(dt)
    if OpenBtnFrame.Visible then
        OpenBtn.Rotation = OpenBtn.Rotation + (dt * 120)
    end
end)


local Pages = {}
local TabButtons = {}
local isTweening = false

-- ANIMACIÓNES DE APERTURA Y CIERRE 
CloseBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    isTweening = true
    
    local closeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    local mainClose = TweenService:Create(MainFrame, closeInfo, {
        Size = UDim2.new(0, 430, 0, 250),
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
        OpenBtnFrame.Visible = true
        OpenBtnFrame.Size = UDim2.new(0, 56, 0, 56)
        OpenBtn.Size = UDim2.new(0, 0, 0, 0)
        
        local openAnim = TweenService:Create(OpenBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -6, 1, -6)
        })
        openAnim:Play()
        openAnim.Completed:Connect(function() isTweening = false end)
    end)
end)


OpenBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    isTweening = true
    
    local hideTween = TweenService:Create(OpenBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    hideTween:Play()
    
    hideTween.Completed:Connect(function()
        OpenBtnFrame.Visible = false
        
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
return Button
end

--  INICIALIZACIÓN DE CATEGORÍAS 
local TabMain = CreateTab("Main", Theme.Main)
local TabCheats = CreateTab("Player Cheats", Theme.Main) 
local TabCombat = CreateTab("Combat", Theme.Combat)
local TabVisuals = CreateTab("Visuals", Theme.Visuals)
local TabMisc = CreateTab("Misc", Theme.Misc)

if Pages["Main"] then
    Pages["Main"].Visible = true
    if TabButtons["Main"] then TabButtons["Main"].TextColor3 = Theme.Main end
end


-- TAB MAIN


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- TARJETA DE PERFIL 
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(0.94, 0, 0, 70)
ProfileCard.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
ProfileCard.BorderSizePixel = 0
ProfileCard.Parent = TabMain

local pc_corner = Instance.new("UICorner")
pc_corner.CornerRadius = UDim.new(0, 10)
pc_corner.Parent = ProfileCard

local pc_stroke = Instance.new("UIStroke")
pc_stroke.Color = Color3.fromRGB(45, 50, 62)
pc_stroke.Thickness = 1.2
pc_stroke.Parent = ProfileCard

-- Avatar Círculo Perfecto
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 48, 0, 48)
AvatarImage.Position = UDim2.new(0, 12, 0, 11)
AvatarImage.BackgroundColor3 = Color3.fromRGB(28, 31, 38)
AvatarImage.Parent = ProfileCard

local avatar_corner = Instance.new("UICorner")
avatar_corner.CornerRadius = UDim.new(1, 0)
avatar_corner.Parent = AvatarImage

task.spawn(function()
    local content, isReady = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId, 
        Enum.ThumbnailType.HeadShot, 
        Enum.ThumbnailSize.Size100x100
    )
    if isReady then AvatarImage.Image = content end
end)

-- Nombre de Usuario
local UserNameLabel = Instance.new("TextLabel")
UserNameLabel.Size = UDim2.new(1, -75, 0, 20)
UserNameLabel.Position = UDim2.new(0, 68, 0, 15)
UserNameLabel.Text = "@" .. LocalPlayer.Name
UserNameLabel.Font = Enum.Font.GothamBold
UserNameLabel.TextSize = 13
UserNameLabel.TextColor3 = Theme.Main
UserNameLabel.TextXAlignment = Enum.TextXAlignment.Left
UserNameLabel.BackgroundTransparency = 1
UserNameLabel.Parent = ProfileCard

local AccountAgeLabel = Instance.new("TextLabel")
AccountAgeLabel.Size = UDim2.new(1, -75, 0, 18)
AccountAgeLabel.Position = UDim2.new(0, 68, 0, 35)
AccountAgeLabel.Text = "📅 Cuenta: " .. tostring(LocalPlayer.AccountAge) .. " días"
AccountAgeLabel.Font = Enum.Font.Gotham
AccountAgeLabel.TextSize = 11
AccountAgeLabel.TextColor3 = Color3.fromRGB(170, 175, 185)
AccountAgeLabel.TextXAlignment = Enum.TextXAlignment.Left
AccountAgeLabel.BackgroundTransparency = 1
AccountAgeLabel.Parent = ProfileCard


--TARJETA DE RENDIMIENTO  -
local PerfCard = Instance.new("Frame")
PerfCard.Size = UDim2.new(0.94, 0, 0, 60)
PerfCard.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
PerfCard.BorderSizePixel = 0
PerfCard.Parent = TabMain

local perf_corner = Instance.new("UICorner")
perf_corner.CornerRadius = UDim.new(0, 10)
perf_corner.Parent = PerfCard

local perf_stroke = Instance.new("UIStroke")
perf_stroke.Color = Color3.fromRGB(45, 50, 62)
perf_stroke.Thickness = 1.2
perf_stroke.Parent = PerfCard

local PerfTitle = Instance.new("TextLabel")
PerfTitle.Size = UDim2.new(1, -20, 0, 18)
PerfTitle.Position = UDim2.new(0, 12, 0, 8)
PerfTitle.Text = "ESTADO Y RENDIMIENTO ⚡"
PerfTitle.Font = Enum.Font.GothamBold
PerfTitle.TextSize = 11
PerfTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
PerfTitle.TextXAlignment = Enum.TextXAlignment.Left
PerfTitle.BackgroundTransparency = 1
PerfTitle.Parent = PerfCard

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 0, 22)
StatsLabel.Position = UDim2.new(0, 12, 0, 28)
StatsLabel.Text = "FPS: -- | Ping: -- ms | Status: 🟢 ACTIVO"
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextSize = 11
StatsLabel.TextColor3 = Color3.fromRGB(50, 255, 140)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.BackgroundTransparency = 1
StatsLabel.Parent = PerfCard

-- Script 
local lastUpdate = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastUpdate >= 1 then
        local fps = frameCount
        frameCount = 0
        lastUpdate = tick()
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        StatsLabel.Text = "FPS: " .. tostring(fps) .. "  |  Ping: " .. tostring(ping) .. "ms  |  Status: 🟢 ACTIVO"
    end
end)

-- TARJETA DE COMUNIDAD 
local SocialCard = Instance.new("Frame")
SocialCard.Size = UDim2.new(0.94, 0, 0, 110)
SocialCard.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
SocialCard.BorderSizePixel = 0
SocialCard.Parent = TabMain

local sc_corner = Instance.new("UICorner")
sc_corner.CornerRadius = UDim.new(0, 10)
sc_corner.Parent = SocialCard

local sc_stroke = Instance.new("UIStroke")
sc_stroke.Color = Color3.fromRGB(45, 50, 62)
sc_stroke.Thickness = 1.2
sc_stroke.Parent = SocialCard

local SocialTitle = Instance.new("TextLabel")
SocialTitle.Size = UDim2.new(1, -20, 0, 20)
SocialTitle.Position = UDim2.new(0, 12, 0, 8)
SocialTitle.Text = "REDES OFICIALES 🌐"
SocialTitle.Font = Enum.Font.GothamBold
SocialTitle.TextSize = 11
SocialTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
SocialTitle.TextXAlignment = Enum.TextXAlignment.Left
SocialTitle.BackgroundTransparency = 1
SocialTitle.Parent = SocialCard

-- Botón WhatsApp
local WhatsAppBtn = Instance.new("TextButton")
WhatsAppBtn.Size = UDim2.new(1, -24, 0, 32)
WhatsAppBtn.Position = UDim2.new(0, 12, 0, 32)
WhatsAppBtn.BackgroundColor3 = Color3.fromRGB(26, 30, 38)
WhatsAppBtn.Text = "📲 CANAL DE WHATSAPP (COPIAR)"
WhatsAppBtn.Font = Enum.Font.GothamBold
WhatsAppBtn.TextSize = 10.5
WhatsAppBtn.TextColor3 = Theme.Main
WhatsAppBtn.Parent = SocialCard

local wbc = Instance.new("UICorner")
wbc.CornerRadius = UDim.new(0, 6)
wbc.Parent = WhatsAppBtn

WhatsAppBtn.MouseButton1Click:Connect(function()
    setclipboard("https://whatsapp.com/channel/0029VbC12x4GufIzNYfrPh3R")
    WhatsAppBtn.Text = "¡LINK COPIADO! ✅"
    task.wait(2)
    WhatsAppBtn.Text = "📲 CANAL DE WHATSAPP (COPIAR)"
end)

-- Botón TikTok
local TikTokBtn = Instance.new("TextButton")
TikTokBtn.Size = UDim2.new(1, -24, 0, 32)
TikTokBtn.Position = UDim2.new(0, 12, 0, 68)
TikTokBtn.BackgroundColor3 = Color3.fromRGB(26, 30, 38)
TikTokBtn.Text = "🎵 TIKTOK OFICIAL (COPIAR)"
TikTokBtn.Font = Enum.Font.GothamBold
TikTokBtn.TextSize = 10.5
TikTokBtn.TextColor3 = Theme.Main
TikTokBtn.Parent = SocialCard

local tkc = Instance.new("UICorner")
tkc.CornerRadius = UDim.new(0, 6)
tkc.Parent = TikTokBtn

TikTokBtn.MouseButton1Click:Connect(function()
    setclipboard("softworks32")
    TikTokBtn.Text = "¡USUARIO COPIADO! ✅"
    task.wait(2)
    TikTokBtn.Text = "🎵 TIKTOK OFICIAL (COPIAR)"
end)


--  NOVEDADES DEL SCRIPT 
local NewsCard = Instance.new("Frame")
NewsCard.Size = UDim2.new(0.94, 0, 0, 75)
NewsCard.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
NewsCard.BorderSizePixel = 0
NewsCard.Parent = TabMain

local news_corner = Instance.new("UICorner")
news_corner.CornerRadius = UDim.new(0, 10)
news_corner.Parent = NewsCard

local news_stroke = Instance.new("UIStroke")
news_stroke.Color = Color3.fromRGB(45, 50, 62)
news_stroke.Thickness = 1.2
news_stroke.Parent = NewsCard

local NewsTitle = Instance.new("TextLabel")
NewsTitle.Size = UDim2.new(1, -20, 0, 18)
NewsTitle.Position = UDim2.new(0, 12, 0, 8)
NewsTitle.Text = "NOVEDADES V1.0 📢"
NewsTitle.Font = Enum.Font.GothamBold
NewsTitle.TextSize = 11
NewsTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
NewsTitle.TextXAlignment = Enum.TextXAlignment.Left
NewsTitle.BackgroundTransparency = 1
NewsTitle.Parent = NewsCard

local NewsBody = Instance.new("TextLabel")
NewsBody.Size = UDim2.new(1, -24, 0, 42)
NewsBody.Position = UDim2.new(0, 12, 0, 28)
NewsBody.Text = "• Se corrigió el error del aimbot\n• Se añadió la función Hide Name\n• Próximamente Canal de Discord"
NewsBody.Font = Enum.Font.Gotham
NewsBody.TextSize = 10
NewsBody.TextColor3 = Color3.fromRGB(160, 165, 175)
NewsBody.TextXAlignment = Enum.TextXAlignment.Left
NewsBody.TextYAlignment = Enum.TextYAlignment.Top
NewsBody.BackgroundTransparency = 1
NewsBody.Parent = NewsCard

AddToggle(TabCheats, "Speed Hack", "SpeedEnabled", Theme.Main)
AddSlider(TabCheats, "Speed Power", 16, 300, 16, "SpeedValue", Theme.Main)
AddToggle(TabCheats, "Infinity Jump", "InfJump", Theme.Main)
AddToggle(TabCheats, "Noclip", "Noclip", Theme.Main)
AddToggle(TabCheats, "Fly (Vuelo)", "Fly", Theme.Main)
AddToggle(TabCheats, "Hide Name 👤", "HideName", Theme.Main)
AddToggle(TabCheats, "Spin Bot 🌀", "SpinBot", Theme.Main)
AddSlider(TabCheats, "Spin Speed", 10, 150, 30, "SpinSpeed", Theme.Main)

  
AddToggle(TabCombat, "Aimbot", "AimbotEnabled", Theme.Combat)
AddSlider(TabCombat, "FOV Radio", 30, 300, 100, "FOVRadius", Theme.Combat)
AddToggle(TabCombat, "Show FOV Anillo", "FOVEnabled", Theme.Combat)
AddToggle(TabCombat, "Silent Aim", "SilentAim", Theme.Combat)


-- VISOR CHECK 
local function VerificarParedVisibilidad(objetivoParte)
    if not Config.WallCheck then return true end 
    
    local origen = Camera.CFrame.Position
    local destino = objetivoParte.Position
    local raycastParams = RaycastParams.new()
    

    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, objetivoParte.Parent}

    local resultado = workspace:Raycast(origen, destino - origen, raycastParams)
    return resultado == nil 
end

-- 3. BUSCADOR DE ENEMIGOS 
local function ObtenerEnemigoMasCercano()
    local objetivoCercano = nil
    local distanciaMinima = Config.FOVRadius
    local centroPantalla = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, jugador in ipairs(Players:GetPlayers()) do
        if jugador ~= LocalPlayer and jugador.Character and jugador.Character:FindFirstChild("Humanoid") and jugador.Character.Humanoid.Health > 0 then
            
        
            local parteObjetivo = jugador.Character:FindFirstChild(Config.TargetPart) or jugador.Character:FindFirstChild("Head")
            
            if parteObjetivo then
                local vector2, enPantalla = Camera:WorldToViewportPoint(parteObjetivo.Position)
                
                if enPantalla then
                    local distancia = (Vector2.new(vector2.X, vector2.Y) - centroPantalla).Magnitude
                    
                    if distancia < distanciaMinima and VerificarParedVisibilidad(parteObjetivo) then
                        distanciaMinima = distancia
                        objetivoCercano = parteObjetivo
                    end
                end
            end
        end
    end
    
    return objetivoCercano
end


-- MOTOR PRINCIPAL 
RunService.RenderStepped:Connect(function()
    if not Camera or not workspace.CurrentCamera then
        Camera = workspace.CurrentCamera
        return
    end
    
    local centroPantalla = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    if Config.FOVEnabled then
        FOVCircle.Visible = true
        FOVCircle.Radius = Config.FOVRadius
        FOVCircle.Position = centroPantalla
    else
        FOVCircle.Visible = false
    end
    
    if Config.AimbotEnabled or Config.FOVEnabled then
        local objetivo = ObtenerEnemigoMasCercano()
        
        if objetivo then
            FOVCircle.Color = Color3.fromRGB(0, 255, 0) 
            
            
            if Config.AimbotEnabled then
                
                local currentPos = Camera.CFrame.Position
                local targetCFrame = CFrame.new(currentPos, objetivo.Position)
                
                
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1.0)
            end
        else
            FOVCircle.Color = Color3.fromRGB(255, 0, 0) 
        end
    end
end)







AddToggle(TabVisuals, "ESP Box", "ESPBox", Theme.Visuals)
AddToggle(TabVisuals, "ESP Name", "ESPName", Theme.Visuals)
AddToggle(TabVisuals, "ESP Distancia", "ESPDist", Theme.Visuals)
AddToggle(TabVisuals, "ESP Health", "ESPHealth", Theme.Visuals)
AddToggle(TabVisuals, "Traces", "Traces", Theme.Visuals)
AddToggle(TabVisuals, "ESP Gun", "ESPGun", Theme.Visuals) -- 👈 Nuevo Toggle
AddToggle(TabVisuals, "ESP Gun Distancia", "ESPGunDist", Theme.Visuals) -- 👈 Nuevo Toggle

local BtnServerHop = AddButton(TabMisc, "Server Hop 🌐", Theme.Misc)
local BtnRejoin = AddButton(TabMisc, "Rejoin Server 🔄", Theme.Misc)
AddToggle(TabMisc, "Bloquear Menú🌪️", "LockUI", Theme.Misc)


BtnServerHop.MouseButton1Click:Connect(function()
    BtnServerHop.Text = "Buscando servidor... 🔍"
    
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result and result.data then
        local targetServer
        for _, server in ipairs(result.data) do
    
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                targetServer = server.id
                break
            end
        end
        
        if targetServer then
            TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, LocalPlayer)
        else
            BtnServerHop.Text = "No hay otros servers ❌"
            task.wait(2)
            BtnServerHop.Text = "Server Hop 🌐"
        end
    else
        BtnServerHop.Text = "Error al buscar ❌"
        task.wait(2)
        BtnServerHop.Text = "Server Hop 🌐"
    end
end)

BtnRejoin.MouseButton1Click:Connect(function()
    BtnRejoin.Text = "Reconectando... 🔄"
    local TeleportService = game:GetService("TeleportService")
    
    if #Players:GetPlayers() <= 1 then
    
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
    
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end)

-- SISTEMA ESP

local WeaponColors = {
    ["AK47"] = Color3.fromRGB(255, 215, 0),
    ["AK47-Cosmetic"] = Color3.fromRGB(255, 215, 0),
    ["Anaconda"] = Color3.fromRGB(200, 0, 0),
    ["Barbed Baseball Bat"] = Color3.fromRGB(160, 32, 240),
    ["Combat Axe"] = Color3.fromRGB(160, 32, 240),
    ["DiamondMop"] = Color3.fromRGB(160, 32, 240),
    ["Double Barrel"] = Color3.fromRGB(160, 32, 240),
    ["Draco"] = Color3.fromRGB(160, 32, 240),
    ["EnergyShot"] = Color3.fromRGB(160, 32, 240),
    ["GoldMop"] = Color3.fromRGB(0, 122, 255),
    ["M16"] = Color3.fromRGB(255, 215, 0),
    ["Mop"] = Color3.fromRGB(128, 128, 128),
    ["MP5"] = Color3.fromRGB(255, 215, 0),
    ["Remington"] = Color3.fromRGB(255, 215, 0),
    ["RightGrip"] = Color3.fromRGB(255, 215, 0),
    ["RPG"] = Color3.fromRGB(255, 215, 0),
    ["RPG-ریموٹ فونکشن اصلی"] = Color3.fromRGB(255, 215, 0),
    ["SilverMop"] = Color3.fromRGB(160, 32, 240),
    ["sledgehammer"] = Color3.fromRGB(160, 32, 240),
    ["Tactical Axe"] = Color3.fromRGB(255, 215, 0)
}

local function GetPlayerTool(player)
    if player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then return tool end
    end
    if player:FindFirstChild("Backpack") then
        local tool = player.Backpack:FindFirstChildOfClass("Tool")
        if tool then return tool end
    end
    return nil
end

local function CreateESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1.0     
    box.Color = Color3.fromRGB(255, 0, 0)
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

    local gunText = Drawing.new("Text")
    gunText.Visible = false
    gunText.Center = true
    gunText.Outline = true
    gunText.Size = 11
    gunText.Font = 2

    local healthBar = Drawing.new("Line")
    healthBar.Visible = false
    healthBar.Thickness = 2

    local traceLine = Drawing.new("Line")
    traceLine.Visible = false
    traceLine.Thickness = 1.0 
    traceLine.Color = Color3.fromRGB(255, 0, 0)

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local head = character.Head
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local camera = workspace.CurrentCamera

            local vector, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (camera.CFrame.Position - rootPart.Position).Magnitude
                local topPos, topOnScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.8, 0))
                local bottomPos, bottomOnScreen = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))

                if topOnScreen and bottomOnScreen then
                    local boxHeight = math.abs(topPos.Y - bottomPos.Y)
                    local boxWidth = boxHeight * 0.60 

                    -- 1. ESP BOX
                    if Config.ESPBox then
                        box.Visible = true
                        box.Position = Vector2.new(vector.X - (boxWidth / 2), topPos.Y)
                        box.Size = Vector2.new(boxWidth, boxHeight)
                    else
                        box.Visible = false
                    end

                    -- 2. ESP NAME
                    if Config.ESPName then
                        nameText.Visible = true
                        nameText.Position = Vector2.new(vector.X, topPos.Y - 16)
                        nameText.Text = player.Name
                    else
                        nameText.Visible = false
                    end

                    -- 3. ESP DISTANCIA
                    local yOffset = bottomPos.Y + 4
                    if Config.ESPDist then
                        distText.Visible = true
                        distText.Position = Vector2.new(vector.X, yOffset)
                        distText.Text = string.format("[%d studs]", math.floor(distance))
                        yOffset = yOffset + 14
                    else
                        distText.Visible = false
                    end

                    -- 4. ESP GUN
                    if Config.ESPGun then
                        local currentTool = GetPlayerTool(player)
                        if currentTool then
                            local weaponName = currentTool.Name
                            gunText.Visible = true
                            gunText.Color = WeaponColors[weaponName] or Color3.fromRGB(255, 255, 255)
                            
                            if Config.ESPGunDist then
                                gunText.Text = string.format("%s [%d studs]", weaponName, math.floor(distance))
                            else
                                gunText.Text = weaponName
                            end
                            gunText.Position = Vector2.new(vector.X, yOffset)
                        else
                            gunText.Visible = false
                        end
                    else
                        gunText.Visible = false
                        end


-- 5. ESP HEALTH
                    if Config.ESPHealth then
                        healthBar.Visible = true
                        local healthPercentage = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        local barX = vector.X - (boxWidth / 2) - 6
                        
                        healthBar.From = Vector2.new(barX, bottomPos.Y)
                        healthBar.To = Vector2.new(barX, bottomPos.Y - (boxHeight * healthPercentage))
                        healthBar.Color = Color3.fromHSV((healthPercentage * 120) / 360, 1, 1)
                    else
                        healthBar.Visible = false
                    end

                    -- 6. TRACES
                    if Config.Traces then
                        traceLine.Visible = true
                        traceLine.From = Vector2.new(camera.ViewportSize.X / 2, 0)
                        traceLine.To = Vector2.new(vector.X, topPos.Y)
                    else
                        traceLine.Visible = false
                    end
                end
            else
                box.Visible = false
                nameText.Visible = false
                distText.Visible = false
                gunText.Visible = false
                healthBar.Visible = false
                traceLine.Visible = false
            end
        else
            -- Limpieza completa de memoria al morir
            box:Destroy()
            nameText:Destroy()
            distText:Destroy()
            gunText:Destroy()
            healthBar:Destroy()
            traceLine:Destroy()
            connection:Disconnect()
        end
    end)
end






--  A.P GB👀


local function MonitorPlayer(player)
    if player == LocalPlayer then return end


    player.CharacterAdded:Connect(function(character)
        
        local root = character:WaitForChild("HumanoidRootPart", 10)
        local head = character:WaitForChild("Head", 10)
        local humanoid = character:WaitForChild("Humanoid", 10)
        
        if root and head and humanoid then
            task.wait(0.2) 
            CreateESP(player)
        end
    end)


    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(MonitorPlayer)

for _, player in pairs(Players:GetPlayers()) do
    MonitorPlayer(player)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if player ~= LocalPlayer then
            
            player.Character:WaitForChild("HumanoidRootPart", 5)
            player.Character:WaitForChild("Head", 5)
            CreateESP(player)
        end
    end)
end)

-- BYPASS ULTRA MEGA PRO MAX 🗣️🔥🔥🔥


local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")


LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

task.spawn(function()
    while task.wait(0.1) do
        if Character and Humanoid and RootPart then
            if Config.Fly or Config.SpeedEnabled then
        
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                
                
                local velocity = RootPart.AssemblyLinearVelocity
                if velocity.Magnitude > 350 then
                    RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end)

-- CONTROL DEL SPEED HACK 
RunService.Heartbeat:Connect(function()
    if Character and Humanoid and RootPart and Config.SpeedEnabled then
        local MoveDirection = Humanoid.MoveDirection
        if MoveDirection.Magnitude > 0 then
            
            local speed = math.clamp(Config.SpeedValue, 60, 100)
        
            RootPart.CFrame = RootPart.CFrame + (MoveDirection * (speed / 100))
        end
    end
end)


--  CONTROL FLY
local FlyAttachment, AlignOri, LinearVel

RunService.RenderStepped:Connect(function()
    if Config.Fly and Character and RootPart and Humanoid then

        if not FlyAttachment or not FlyAttachment.Parent then
            FlyAttachment = Instance.new("Attachment")
            FlyAttachment.Name = "EnforceFlyAttachment"
            FlyAttachment.Parent = RootPart
            
            AlignOri = Instance.new("AlignOrientation")
            AlignOri.Name = "EnforceFlyAlign"
            AlignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
            AlignOri.Attachment0 = FlyAttachment
            AlignOri.MaxTorque = 9e9
            AlignOri.Responsiveness = 200 
            AlignOri.Parent = RootPart
            
            LinearVel = Instance.new("LinearVelocity")
            LinearVel.Name = "EnforceFlyVelocity"
            LinearVel.Attachment0 = FlyAttachment
            LinearVel.MaxForce = 9e9
            LinearVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            LinearVel.Parent = RootPart
        end
        
        local camera = workspace.CurrentCamera
        
        AlignOri.CFrame = camera.CFrame
        
        local moveDirection = Humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            
            local lookVector = camera.CFrame.LookVector
            local targetVelocity = moveDirection * 50 
            
            if lookVector.Y > 0.2 or lookVector.Y < -0.2 then
                targetVelocity = targetVelocity + Vector3.new(0, lookVector.Y * 40, 0)
            end
            
            LinearVel.VectorVelocity = targetVelocity
        else
            LinearVel.VectorVelocity = Vector3.new(0, 0, 0)
        end
    else
        if RootPart:FindFirstChild("EnforceFlyAttachment") then RootPart.EnforceFlyAttachment:Destroy() end
        if RootPart:FindFirstChild("EnforceFlyAlign") then RootPart.EnforceFlyAlign:Destroy() end
        if RootPart:FindFirstChild("EnforceFlyVelocity") then RootPart.EnforceFlyVelocity:Destroy() end
        FlyAttachment, AlignOri, LinearVel = nil, nil, nil
    end
end)


--  NOCLIP 
RunService.Stepped:Connect(function()
    if Config.Noclip and Character then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- INFINITY JUMP 
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and Character and Humanoid then
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)





-- LÓGICA DE SPIN BOT Y HIDE

local originalDisplayName = Humanoid and Humanoid.DisplayName or LocalPlayer.DisplayName

-- Función de Hide Name
local function UpdateHideName()
    pcall(function()
        if not Character or not Character:FindFirstChild("Head") then return end
        
        for _, v in pairs(Character.Head:GetChildren()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = not Config.HideName
            end
        end
    end)
end

local lastHideNameState = false

-- UN SOLO MOTOR PARA SPIN BOT Y HIDE NAME
RunService.RenderStepped:Connect(function()
    
    --  SPIN BOT 
    if Config.SpinBot and Character and Character:FindFirstChild("HumanoidRootPart") then
        local root = Character.HumanoidRootPart
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Config.SpinSpeed), 0)
    end

    -- HIDE NAME
    if Config.HideName ~= lastHideNameState then
        lastHideNameState = Config.HideName
        UpdateHideName()
    end
end)


LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5) 
    UpdateHideName()
end)

