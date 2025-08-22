-- Grow Garden Game - شبیه گرو گاردن Roblox
-- نویسنده: AI Assistant
-- تاریخ: 2024

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- متغیرهای بازی
local gameData = {
    coins = 1000,
    level = 1,
    experience = 0,
    experienceToNext = 100,
    plants = {},
    unlockedSeeds = {"carrot", "tomato", "corn"},
    gardenSize = 3,
    maxGardenSize = 6
}

-- انواع بذرها
local seedTypes = {
    carrot = {
        name = "هویج",
        price = 50,
        growthTime = 30,
        sellPrice = 100,
        rarity = "common",
        color = Color3.fromRGB(255, 140, 0)
    },
    tomato = {
        name = "گوجه فرنگی",
        price = 80,
        growthTime = 45,
        sellPrice = 160,
        rarity = "uncommon",
        color = Color3.fromRGB(255, 0, 0)
    },
    corn = {
        name = "ذرت",
        price = 120,
        growthTime = 60,
        sellPrice = 250,
        rarity = "rare",
        color = Color3.fromRGB(255, 255, 0)
    },
    strawberry = {
        name = "توت فرنگی",
        price = 200,
        growthTime = 90,
        sellPrice = 450,
        rarity = "epic",
        color = Color3.fromRGB(255, 20, 147)
    },
    watermelon = {
        name = "هندوانه",
        price = 500,
        growthTime = 180,
        sellPrice = 1200,
        rarity = "legendary",
        color = Color3.fromRGB(0, 128, 0)
    }
}

-- ایجاد صداها
local function createSound(soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = volume or 0.5
    sound.Pitch = pitch or 1
    sound.Parent = SoundService
    return sound
end

local plantSound = createSound("112754501285226", 0.3, 1.2)
local waterSound = createSound("9120715547", 0.4, 1.0)
local harvestSound = createSound("12222253", 0.5, 1.1)
local coinSound = createSound("130785805", 0.6, 1.0)
local levelUpSound = createSound("100697759026652", 0.7, 1.0)

-- ایجاد رابط کاربری اصلی
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrowGardenGame"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- فریم پس‌زمینه
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Name = "BackgroundFrame"
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Parent = screenGui

-- گرادیان پس‌زمینه
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 139, 34)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 205, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(144, 238, 144))
}
bgGradient.Rotation = 45
bgGradient.Parent = backgroundFrame

-- فریم اصلی بازی
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 800, 0, 600)
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 220)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim2.new(0, 20)
mainCorner.Parent = mainFrame

local mainShadow = Instance.new("UIStroke")
mainShadow.Color = Color3.fromRGB(0, 0, 0)
mainShadow.Thickness = 3
mainShadow.Transparency = 0.3
mainShadow.Parent = mainFrame

-- نوار عنوان
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🌱 باغچه من 🌱"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 28
titleText.Font = Enum.Font.FredokaOne
titleText.TextStrokeTransparency = 0.5
titleText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleText.Parent = titleBar

-- نوار اطلاعات
local infoBar = Instance.new("Frame")
infoBar.Name = "InfoBar"
infoBar.Size = UDim2.new(1, -40, 0, 80)
infoBar.Position = UDim2.new(0, 20, 0, 80)
infoBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
infoBar.BorderSizePixel = 0
infoBar.Parent = mainFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim2.new(0, 15)
infoCorner.Parent = infoBar

local infoShadow = Instance.new("UIStroke")
infoShadow.Color = Color3.fromRGB(0, 0, 0)
infoShadow.Thickness = 2
infoShadow.Transparency = 0.2
infoShadow.Parent = infoBar

-- اطلاعات سکه‌ها
local coinFrame = Instance.new("Frame")
coinFrame.Name = "CoinFrame"
coinFrame.Size = UDim2.new(0, 150, 0, 50)
coinFrame.Position = UDim2.new(0, 20, 0, 15)
coinFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
coinFrame.BorderSizePixel = 0
coinFrame.Parent = infoBar

local coinCorner = Instance.new("UICorner")
coinCorner.CornerRadius = UDim.new(0, 10)
coinCorner.Parent = coinFrame

local coinIcon = Instance.new("TextLabel")
coinIcon.Name = "CoinIcon"
coinIcon.Size = UDim2.new(0, 30, 0, 30)
coinIcon.Position = UDim2.new(0, 10, 0, 10)
coinIcon.BackgroundTransparency = 1
coinIcon.Text = "🪙"
coinIcon.TextSize = 24
coinIcon.Font = Enum.Font.FredokaOne
coinIcon.Parent = coinFrame

local coinText = Instance.new("TextLabel")
coinText.Name = "CoinText"
coinText.Size = UDim2.new(1, -50, 1, 0)
coinText.Position = UDim2.new(0, 45, 0, 0)
coinText.BackgroundTransparency = 1
coinText.Text = "1000"
coinText.TextColor3 = Color3.fromRGB(0, 0, 0)
coinText.TextSize = 18
coinText.Font = Enum.Font.GothamBold
coinText.TextXAlignment = Enum.TextXAlignment.Left
coinText.Parent = coinFrame

-- اطلاعات سطح
local levelFrame = Instance.new("Frame")
levelFrame.Name = "LevelFrame"
levelFrame.Size = UDim2.new(0, 150, 0, 50)
coinFrame.Position = UDim2.new(0, 190, 0, 15)
levelFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
levelFrame.BorderSizePixel = 0
levelFrame.Parent = infoBar

local levelCorner = Instance.new("UICorner")
levelCorner.CornerRadius = UDim.new(0, 10)
levelCorner.Parent = levelFrame

local levelIcon = Instance.new("TextLabel")
levelIcon.Name = "LevelIcon"
levelIcon.Size = UDim2.new(0, 30, 0, 30)
levelIcon.Position = UDim2.new(0, 10, 0, 10)
levelIcon.BackgroundTransparency = 1
levelIcon.Text = "⭐"
levelIcon.TextSize = 24
levelIcon.Font = Enum.Font.FredokaOne
levelIcon.Parent = levelFrame

local levelText = Instance.new("TextLabel")
levelText.Name = "LevelText"
levelText.Size = UDim2.new(1, -50, 1, 0)
levelText.Position = UDim2.new(0, 45, 0, 0)
levelText.BackgroundTransparency = 1
levelText.Text = "سطح 1"
levelText.TextColor3 = Color3.fromRGB(255, 255, 255)
levelText.TextSize = 18
levelText.Font = Enum.Font.GothamBold
levelText.TextXAlignment = Enum.TextXAlignment.Left
levelText.Parent = levelFrame

-- نوار تجربه
local expBar = Instance.new("Frame")
expBar.Name = "ExpBar"
expBar.Size = UDim2.new(0, 200, 0, 20)
expBar.Position = UDim2.new(0, 360, 0, 30)
expBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
expBar.BorderSizePixel = 0
expBar.Parent = infoBar

local expBarCorner = Instance.new("UICorner")
expBarCorner.CornerRadius = UDim2.new(0, 10)
expBarCorner.Parent = expBar

local expFill = Instance.new("Frame")
expFill.Name = "ExpFill"
expFill.Size = UDim2.new(0, 0, 1, 0)
expFill.Position = UDim2.new(0, 0, 0, 0)
expFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
expFill.BorderSizePixel = 0
expFill.Parent = expBar

local expFillCorner = Instance.new("UICorner")
expFillCorner.CornerRadius = UDim2.new(0, 10)
expFillCorner.Parent = expFill

local expText = Instance.new("TextLabel")
expText.Name = "ExpText"
expText.Size = UDim2.new(1, 0, 1, 0)
expText.Position = UDim2.new(0, 0, 0, 0)
expText.BackgroundTransparency = 1
expText.Text = "0/100 XP"
expText.TextColor3 = Color3.fromRGB(0, 0, 0)
expText.TextSize = 12
expText.Font = Enum.Font.GothamBold
expText.Parent = expBar

-- فریم باغچه
local gardenFrame = Instance.new("Frame")
gardenFrame.Name = "GardenFrame"
gardenFrame.Size = UDim2.new(0, 400, 0, 400)
gardenFrame.Position = UDim2.new(0, 20, 0, 180)
gardenFrame.BackgroundColor3 = Color3.fromRGB(160, 82, 45)
gardenFrame.BorderSizePixel = 0
gardenFrame.Parent = mainFrame

local gardenCorner = Instance.new("UICorner")
gardenCorner.CornerRadius = UDim.new(0, 15)
gardenCorner.Parent = gardenFrame

local gardenShadow = Instance.new("UIStroke")
gardenShadow.Color = Color3.fromRGB(0, 0, 0)
gardenShadow.Thickness = 3
gardenShadow.Transparency = 0.2
gardenShadow.Parent = gardenFrame

-- ایجاد سلول‌های باغچه
local gardenCells = {}
local cellSize = 120
local cellSpacing = 10

for row = 1, gameData.gardenSize do
    gardenCells[row] = {}
    for col = 1, gameData.gardenSize do
        local cell = Instance.new("Frame")
        cell.Name = "Cell_" .. row .. "_" .. col
        cell.Size = UDim2.new(0, cellSize, 0, cellSize)
        cell.Position = UDim2.new(0, (col-1) * (cellSize + cellSpacing) + 20, 0, (row-1) * (cellSize + cellSpacing) + 20)
        cell.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
        cell.BorderSizePixel = 0
        cell.Parent = gardenFrame
        
        local cellCorner = Instance.new("UICorner")
        cellCorner.CornerRadius = UDim.new(0, 10)
        cellCorner.Parent = cell
        
        local cellBorder = Instance.new("UIStroke")
        cellBorder.Color = Color3.fromRGB(0, 0, 0)
        cellBorder.Thickness = 2
        cellBorder.Transparency = 0.3
        cellBorder.Parent = cell
        
        -- اضافه کردن قابلیت کلیک
        cell.MouseButton1Click:Connect(function()
            handleCellClick(row, col)
        end)
        
        gardenCells[row][col] = {
            frame = cell,
            plant = nil,
            plantedTime = nil,
            watered = false
        }
    end
end

-- فریم فروشگاه
local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.Size = UDim2.new(0, 350, 0, 400)
shopFrame.Position = UDim2.new(1, -370, 0, 180)
shopFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shopFrame.BorderSizePixel = 0
shopFrame.Parent = mainFrame

local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 15)
shopCorner.Parent = shopFrame

local shopShadow = Instance.new("UIStroke")
shopShadow.Color = Color3.fromRGB(0, 0, 0)
shopShadow.Thickness = 2
shopShadow.Transparency = 0.2
shopShadow.Parent = shopFrame

local shopTitle = Instance.new("TextLabel")
shopTitle.Name = "ShopTitle"
shopTitle.Size = UDim2.new(1, 0, 0, 50)
shopTitle.Position = UDim2.new(0, 0, 0, 0)
shopTitle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
shopTitle.BorderSizePixel = 0
shopTitle.Text = "🏪 فروشگاه بذر"
shopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
shopTitle.TextSize = 20
shopTitle.Font = Enum.Font.FredokaOne
shopTitle.Parent = shopFrame

local shopTitleCorner = Instance.new("UICorner")
shopTitleCorner.CornerRadius = UDim.new(0, 15)
shopTitleCorner.Parent = shopTitle

-- ایجاد آیتم‌های فروشگاه
local shopContainer = Instance.new("ScrollingFrame")
shopContainer.Name = "ShopContainer"
shopContainer.Size = UDim2.new(1, -20, 1, -70)
shopContainer.Position = UDim2.new(0, 10, 0, 60)
shopContainer.BackgroundTransparency = 1
shopContainer.ScrollBarThickness = 6
shopContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
shopContainer.Parent = shopFrame

local shopLayout = Instance.new("UIListLayout")
shopLayout.SortOrder = Enum.SortOrder.LayoutOrder
shopLayout.Padding = UDim.new(0, 10)
shopLayout.Parent = shopContainer

-- ایجاد آیتم‌های فروشگاه
for seedName, seedData in pairs(seedTypes) do
    local seedItem = Instance.new("Frame")
    seedItem.Name = "SeedItem_" .. seedName
    seedItem.Size = UDim2.new(1, 0, 0, 80)
    seedItem.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    seedItem.BorderSizePixel = 0
    seedItem.Parent = shopContainer
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 10)
    itemCorner.Parent = seedItem
    
    local itemBorder = Instance.new("UIStroke")
    itemBorder.Color = seedData.color
    itemBorder.Thickness = 2
    itemBorder.Transparency = 0.3
    itemBorder.Parent = seedItem
    
    local seedIcon = Instance.new("TextLabel")
    seedIcon.Name = "SeedIcon"
    seedIcon.Size = UDim2.new(0, 50, 0, 50)
    seedIcon.Position = UDim2.new(0, 15, 0, 15)
    seedIcon.BackgroundTransparency = 1
    seedIcon.Text = "🌱"
    seedIcon.TextSize = 30
    seedIcon.Font = Enum.Font.FredokaOne
    seedIcon.Parent = seedItem
    
    local seedNameText = Instance.new("TextLabel")
    seedNameText.Name = "SeedName"
    seedNameText.Size = UDim2.new(1, -100, 0, 25)
    seedNameText.Position = UDim2.new(0, 80, 0, 10)
    seedNameText.BackgroundTransparency = 1
    seedNameText.Text = seedData.name
    seedNameText.TextColor3 = Color3.fromRGB(0, 0, 0)
    seedNameText.TextSize = 16
    seedNameText.Font = Enum.Font.GothamBold
    seedNameText.TextXAlignment = Enum.TextXAlignment.Left
    seedNameText.Parent = seedItem
    
    local seedPriceText = Instance.new("TextLabel")
    seedPriceText.Name = "SeedPrice"
    seedPriceText.Size = UDim2.new(1, -100, 0, 20)
    seedPriceText.Position = UDim2.new(0, 80, 0, 40)
    seedPriceText.BackgroundTransparency = 1
    seedPriceText.Text = "قیمت: " .. seedData.price .. " 🪙"
    seedPriceText.TextColor3 = Color3.fromRGB(100, 100, 100)
    seedPriceText.TextSize = 14
    seedNameText.Font = Enum.Font.Gotham
    seedPriceText.TextXAlignment = Enum.TextXAlignment.Left
    seedPriceText.Parent = seedItem
    
    local buyButton = Instance.new("TextButton")
    buyButton.Name = "BuyButton"
    buyButton.Size = UDim2.new(0, 60, 0, 30)
    buyButton.Position = UDim2.new(1, -70, 0, 25)
    buyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    buyButton.BorderSizePixel = 0
    buyButton.Text = "خرید"
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.TextSize = 14
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Parent = seedItem
    
    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 8)
    buyCorner.Parent = buyButton
    
    -- اضافه کردن قابلیت خرید
    buyButton.MouseButton1Click:Connect(function()
        buySeed(seedName)
    end)
end

-- تابع خرید بذر
function buySeed(seedName)
    local seedData = seedTypes[seedName]
    if gameData.coins >= seedData.price then
        gameData.coins = gameData.coins - seedData.price
        coinSound:Play()
        updateUI()
        showNotification("بذر " .. seedData.name .. " خریداری شد!")
    else
        showNotification("سکه کافی ندارید!")
    end
end

-- تابع کلیک روی سلول
function handleCellClick(row, col)
    local cell = gardenCells[row][col]
    
    if cell.plant then
        -- اگر گیاه کاشته شده، برداشت کن
        harvestPlant(row, col)
    else
        -- اگر سلول خالی است، منوی کاشت را نشان بده
        showPlantingMenu(row, col)
    end
end

-- تابع کاشت گیاه
function plantSeed(row, col, seedName)
    local cell = gardenCells[row][col]
    local seedData = seedTypes[seedName]
    
    if gameData.coins >= seedData.price then
        gameData.coins = gameData.coins - seedData.price
        
        cell.plant = {
            name = seedName,
            type = seedData,
            plantedTime = tick(),
            growthStage = 0,
            maxGrowthStages = 4
        }
        
        cell.plantedTime = tick()
        cell.watered = false
        
        -- ایجاد نمایش گیاه
        local plantDisplay = Instance.new("TextLabel")
        plantDisplay.Name = "PlantDisplay"
        plantDisplay.Size = UDim2.new(1, -20, 1, -20)
        plantDisplay.Position = UDim2.new(0, 10, 0, 10)
        plantDisplay.BackgroundTransparency = 1
        plantDisplay.Text = "🌱"
        plantDisplay.TextSize = 40
        plantDisplay.Font = Enum.Font.FredokaOne
        plantDisplay.Parent = cell.frame
        
        cell.plant.display = plantDisplay
        
        plantSound:Play()
        updateUI()
        showNotification("بذر " .. seedData.name .. " کاشته شد!")
    else
        showNotification("سکه کافی ندارید!")
    end
end

-- تابع برداشت گیاه
function harvestPlant(row, col)
    local cell = gardenCells[row][col]
    local plant = cell.plant
    
    if plant and plant.growthStage >= plant.type.maxGrowthStages then
        local sellPrice = plant.type.sellPrice
        gameData.coins = gameData.coins + sellPrice
        gameData.experience = gameData.experience + 10
        
        -- حذف گیاه
        if plant.display then
            plant.display:Destroy()
        end
        
        cell.plant = nil
        cell.plantedTime = nil
        cell.watered = false
        
        harvestSound:Play()
        coinSound:Play()
        
        updateUI()
        checkLevelUp()
        showNotification("گیاه " .. plant.type.name .. " برداشت شد! +" .. sellPrice .. " 🪙")
    else
        showNotification("گیاه هنوز آماده برداشت نیست!")
    end
end

-- تابع آبیاری گیاه
function waterPlant(row, col)
    local cell = gardenCells[row][col]
    
    if cell.plant and not cell.watered then
        cell.watered = true
        waterSound:Play()
        showNotification("گیاه آبیاری شد!")
        
        -- انیمیشن آبیاری
        local waterEffect = Instance.new("TextLabel")
        waterEffect.Text = "💧"
        waterEffect.TextSize = 30
        waterEffect.BackgroundTransparency = 1
        waterEffect.Position = UDim2.new(0.5, -15, 0.5, -15)
        waterEffect.Parent = cell.frame
        
        local waterTween = TweenService:Create(waterEffect, 
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {Position = UDim2.new(0.5, -15, 0, -30), TextTransparency = 1}
        )
        waterTween:Play()
        
        waterTween.Completed:Connect(function()
            waterEffect:Destroy()
        end)
    end
end

-- تابع بررسی ارتقای سطح
function checkLevelUp()
    if gameData.experience >= gameData.experienceToNext then
        gameData.level = gameData.level + 1
        gameData.experience = gameData.experience - gameData.experienceToNext
        gameData.experienceToNext = gameData.level * 100
        
        levelUpSound:Play()
        showNotification("🎉 سطح شما به " .. gameData.level .. " ارتقا یافت!")
        
        -- باز کردن بذرهای جدید
        if gameData.level >= 3 and not table.find(gameData.unlockedSeeds, "strawberry") then
            table.insert(gameData.unlockedSeeds, "strawberry")
            showNotification("🍓 بذر توت فرنگی باز شد!")
        end
        
        if gameData.level >= 5 and not table.find(gameData.unlockedSeeds, "watermelon") then
            table.insert(gameData.unlockedSeeds, "watermelon")
            showNotification("🍉 بذر هندوانه باز شد!")
        end
        
        updateUI()
    end
end

-- تابع به‌روزرسانی رابط کاربری
function updateUI()
    coinText.Text = tostring(gameData.coins)
    levelText.Text = "سطح " .. gameData.level
    
    local expPercent = gameData.experience / gameData.experienceToNext
    expFill.Size = UDim2.new(expPercent, 0, 1, 0)
    expText.Text = gameData.experience .. "/" .. gameData.experienceToNext .. " XP"
end

-- تابع نمایش اعلان
function showNotification(message)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 1, 100)
    notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notification.BorderSizePixel = 0
    notification.Text = message
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextSize = 16
    notification.Font = Enum.Font.GothamBold
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifTween = TweenService:Create(notification, 
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Position = UDim2.new(0.5, -150, 1, -100)}
    )
    notifTween:Play()
    
    wait(3)
    
    local hideTween = TweenService:Create(notification, 
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Position = UDim2.new(0.5, -150, 1, 100)}
    )
    hideTween:Play()
    
    hideTween.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- تابع نمایش منوی کاشت
function showPlantingMenu(row, col)
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = "PlantingMenu"
    menuFrame.Size = UDim2.new(0, 250, 0, 300)
    menuFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    menuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    menuFrame.BorderSizePixel = 0
    menuFrame.Parent = screenGui
    menuFrame.ZIndex = 100
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 15)
    menuCorner.Parent = menuFrame
    
    local menuShadow = Instance.new("UIStroke")
    menuShadow.Color = Color3.fromRGB(0, 0, 0)
    menuShadow.Thickness = 3
    menuShadow.Transparency = 0.2
    menuShadow.Parent = menuFrame
    
    local menuTitle = Instance.new("TextLabel")
    menuTitle.Name = "MenuTitle"
    menuTitle.Size = UDim2.new(1, 0, 0, 50)
    menuTitle.Position = UDim2.new(0, 0, 0, 0)
    menuTitle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    menuTitle.BorderSizePixel = 0
    menuTitle.Text = "🌱 انتخاب بذر"
    menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    menuTitle.TextSize = 18
    menuTitle.Font = Enum.Font.FredokaOne
    menuTitle.Parent = menuFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = menuTitle
    
    local menuContainer = Instance.new("ScrollingFrame")
    menuContainer.Name = "MenuContainer"
    menuContainer.Size = UDim2.new(1, -20, 1, -70)
    menuContainer.Position = UDim2.new(0, 10, 0, 60)
    menuContainer.BackgroundTransparency = 1
    menuContainer.ScrollBarThickness = 6
    menuContainer.Parent = menuFrame
    
    local menuLayout = Instance.new("UIListLayout")
    menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
    menuLayout.Padding = UDim.new(0, 10)
    menuLayout.Parent = menuContainer
    
    -- ایجاد آیتم‌های منو
    for _, seedName in pairs(gameData.unlockedSeeds) do
        local seedData = seedTypes[seedName]
        local menuItem = Instance.new("Frame")
        menuItem.Name = "MenuItem_" .. seedName
        menuItem.Size = UDim2.new(1, 0, 0, 60)
        menuItem.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        menuItem.BorderSizePixel = 0
        menuItem.Parent = menuContainer
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = menuItem
        
        local seedIcon = Instance.new("TextLabel")
        seedIcon.Name = "SeedIcon"
        seedIcon.Size = UDim2.new(0, 40, 0, 40)
        seedIcon.Position = UDim2.new(0, 10, 0, 10)
        seedIcon.BackgroundTransparency = 1
        seedIcon.Text = "🌱"
        seedIcon.TextSize = 25
        seedIcon.Font = Enum.Font.FredokaOne
        seedIcon.Parent = menuItem
        
        local seedNameText = Instance.new("TextLabel")
        seedNameText.Name = "SeedName"
        seedNameText.Size = UDim2.new(1, -120, 0, 30)
        seedNameText.Position = UDim2.new(0, 60, 0, 5)
        seedNameText.BackgroundTransparency = 1
        seedNameText.Text = seedData.name
        seedNameText.TextColor3 = Color3.fromRGB(0, 0, 0)
        seedNameText.TextSize = 14
        seedNameText.Font = Enum.Font.GothamBold
        seedNameText.TextXAlignment = Enum.TextXAlignment.Left
        seedNameText.Parent = menuItem
        
        local seedPriceText = Instance.new("TextLabel")
        seedPriceText.Name = "SeedPrice"
        seedPriceText.Size = UDim2.new(1, -120, 0, 20)
        seedPriceText.Position = UDim2.new(0, 60, 0, 30)
        seedPriceText.BackgroundTransparency = 1
        seedPriceText.Text = seedData.price .. " 🪙"
        seedPriceText.TextColor3 = Color3.fromRGB(100, 100, 100)
        seedPriceText.TextSize = 12
        seedPriceText.Font = Enum.Font.Gotham
        seedPriceText.TextXAlignment = Enum.TextXAlignment.Left
        seedPriceText.Parent = menuItem
        
        local plantButton = Instance.new("TextButton")
        plantButton.Name = "PlantButton"
        plantButton.Size = UDim2.new(0, 60, 0, 30)
        plantButton.Position = UDim2.new(1, -70, 0, 15)
        plantButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        plantButton.BorderSizePixel = 0
        plantButton.Text = "کاشت"
        plantButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        plantButton.TextSize = 12
        plantButton.Font = Enum.Font.GothamBold
        plantButton.Parent = menuItem
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = plantButton
        
        -- اضافه کردن قابلیت کاشت
        plantButton.MouseButton1Click:Connect(function()
            plantSeed(row, col, seedName)
            menuFrame:Destroy()
        end)
    end
    
    -- دکمه بستن
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 100, 0, 40)
    closeButton.Position = UDim2.new(0.5, -50, 1, -50)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "بستن"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    font = Enum.Font.GothamBold
    closeButton.Parent = menuFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        menuFrame:Destroy()
    end)
end

-- حلقه اصلی بازی
spawn(function()
    while true do
        wait(1)
        
        -- بررسی رشد گیاهان
        for row = 1, gameData.gardenSize do
            for col = 1, gameData.gardenSize do
                local cell = gardenCells[row][col]
                if cell.plant and cell.plantedTime then
                    local growthTime = tick() - cell.plantedTime
                    local maxGrowthTime = cell.plant.type.growthTime
                    
                    if growthTime >= maxGrowthTime then
                        cell.plant.growthStage = cell.plant.type.maxGrowthStages
                        if cell.plant.display then
                            cell.plant.display.Text = "🌻"
                        end
                    elseif growthTime >= maxGrowthTime * 0.75 then
                        cell.plant.growthStage = 3
                        if cell.plant.display then
                            cell.plant.display.Text = "🌿"
                        end
                    elseif growthTime >= maxGrowthTime * 0.5 then
                        cell.plant.growthStage = 2
                        if cell.plant.display then
                            cell.plant.display.Text = "🌱"
                        end
                    elseif growthTime >= maxGrowthTime * 0.25 then
                        cell.plant.growthStage = 1
                        if cell.plant.display then
                            cell.plant.display.Text = "🌱"
                        end
                    end
                end
            end
        end
    end
end)

-- انیمیشن ورودی
local entranceTween = TweenService:Create(mainFrame, 
    TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
    {Size = UDim2.new(0, 800, 0, 600)}
)
entranceTween:Play()

-- به‌روزرسانی اولیه رابط کاربری
updateUI()

-- نمایش پیام خوش‌آمدگویی
wait(1)
showNotification("🌱 به بازی گرو گاردنم خوش آمدید! 🌱")
showNotification("برای شروع، روی سلول‌های باغچه کلیک کنید")