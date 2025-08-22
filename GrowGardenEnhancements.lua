-- Grow Garden Game Enhancements - ویژگی‌های پیشرفته
-- نویسنده: AI Assistant
-- تاریخ: 2024

-- این فایل شامل ویژگی‌های اضافی برای بازی گرو گاردنم است

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- سیستم آبیاری پیشرفته
local WateringSystem = {}

function WateringSystem.createWateringCan()
    local wateringCan = Instance.new("TextButton")
    wateringCan.Name = "WateringCan"
    wateringCan.Size = UDim2.new(0, 60, 0, 60)
    wateringCan.Position = UDim2.new(1, -80, 0, 20)
    wateringCan.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    wateringCan.BorderSizePixel = 0
    wateringCan.Text = "💧"
    wateringCan.TextSize = 30
    wateringCan.Font = Enum.Font.FredokaOne
    wateringCan.Parent = game.Parent -- باید به mainFrame متصل شود
    
    local canCorner = Instance.new("UICorner")
    canCorner.CornerRadius = UDim2.new(0, 10)
    canCorner.Parent = wateringCan
    
    local canShadow = Instance.new("UIStroke")
    canShadow.Color = Color3.fromRGB(0, 100, 200)
    canShadow.Thickness = 2
    canShadow.Transparency = 0.2
    canShadow.Parent = wateringCan
    
    return wateringCan
end

function WateringSystem.waterPlant(cell, plant)
    if not cell.watered then
        cell.watered = true
        plant.growthSpeed = plant.growthSpeed * 1.5 -- رشد 50% سریع‌تر
        
        -- انیمیشن آبیاری
        local waterEffect = Instance.new("TextLabel")
        waterEffect.Text = "💧"
        waterEffect.TextSize = 40
        waterEffect.BackgroundTransparency = 1
        waterEffect.Position = UDim2.new(0.5, -20, 0.5, -20)
        waterEffect.Parent = cell.frame
        
        local waterTween = TweenService:Create(waterEffect, 
            TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {Position = UDim2.new(0.5, -20, 0, -40), TextTransparency = 1, TextSize = 20}
        )
        waterTween:Play()
        
        waterTween.Completed:Connect(function()
            waterEffect:Destroy()
        end)
        
        return true
    end
    return false
end

-- سیستم کوددهی
local FertilizerSystem = {}

local fertilizerTypes = {
    basic = {
        name = "کود پایه",
        price = 100,
        effect = 1.2,
        duration = 60,
        color = Color3.fromRGB(139, 69, 19)
    },
    premium = {
        name = "کود پریمیوم",
        price = 300,
        effect = 1.5,
        duration = 120,
        color = Color3.fromRGB(255, 215, 0)
    },
    legendary = {
        name = "کود افسانه‌ای",
        price = 1000,
        effect = 2.0,
        duration = 300,
        color = Color3.fromRGB(138, 43, 226)
    }
}

function FertilizerSystem.createFertilizerShop()
    local shopFrame = Instance.new("Frame")
    shopFrame.Name = "FertilizerShop"
    shopFrame.Size = UDim2.new(0, 300, 0, 200)
    shopFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    shopFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shopFrame.BorderSizePixel = 0
    shopFrame.Parent = game.Parent
    shopFrame.ZIndex = 200
    shopFrame.Visible = false
    
    local shopCorner = Instance.new("UICorner")
    shopCorner.CornerRadius = UDim.new(0, 15)
    shopCorner.Parent = shopFrame
    
    local shopShadow = Instance.new("UIStroke")
    shopShadow.Color = Color3.fromRGB(0, 0, 0)
    shopShadow.Thickness = 3
    shopShadow.Transparency = 0.2
    shopShadow.Parent = shopFrame
    
    local shopTitle = Instance.new("TextLabel")
    shopTitle.Name = "ShopTitle"
    shopTitle.Size = UDim2.new(1, 0, 0, 50)
    shopTitle.Position = UDim2.new(0, 0, 0, 0)
    shopTitle.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    shopTitle.BorderSizePixel = 0
    shopTitle.Text = "🌱 فروشگاه کود"
    shopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    shopTitle.TextSize = 18
    shopTitle.Font = Enum.Font.FredokaOne
    shopTitle.Parent = shopFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = shopTitle
    
    -- ایجاد آیتم‌های کود
    local yOffset = 60
    for fertilizerName, fertilizerData in pairs(fertilizerTypes) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = "FertilizerItem_" .. fertilizerName
        itemFrame.Size = UDim2.new(1, -20, 0, 40)
        itemFrame.Position = UDim2.new(0, 10, 0, yOffset)
        itemFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        itemFrame.BorderSizePixel = 0
        itemFrame.Parent = shopFrame
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = itemFrame
        
        local itemBorder = Instance.new("UIStroke")
        itemBorder.Color = fertilizerData.color
        itemBorder.Thickness = 2
        itemBorder.Transparency = 0.3
        itemBorder.Parent = itemFrame
        
        local itemText = Instance.new("TextLabel")
        itemText.Name = "ItemText"
        itemText.Size = UDim2.new(1, -80, 1, 0)
        itemText.Position = UDim2.new(0, 10, 0, 0)
        itemText.BackgroundTransparency = 1
        itemText.Text = fertilizerData.name .. " (+" .. ((fertilizerData.effect - 1) * 100) .. "%)"
        itemText.TextColor3 = Color3.fromRGB(0, 0, 0)
        itemText.TextSize = 14
        itemText.Font = Enum.Font.GothamBold
        itemText.TextXAlignment = Enum.TextXAlignment.Left
        itemText.Parent = itemFrame
        
        local priceText = Instance.new("TextLabel")
        priceText.Name = "PriceText"
        priceText.Size = UDim2.new(0, 60, 1, 0)
        priceText.Position = UDim2.new(1, -70, 0, 0)
        priceText.BackgroundTransparency = 1
        priceText.Text = fertilizerData.price .. " 🪙"
        priceText.TextColor3 = Color3.fromRGB(100, 100, 100)
        priceText.TextSize = 12
        priceText.Font = Enum.Font.Gotham
        priceText.TextXAlignment = Enum.TextXAlignment.Right
        priceText.Parent = itemFrame
        
        local buyButton = Instance.new("TextButton")
        buyButton.Name = "BuyButton"
        buyButton.Size = UDim2.new(0, 50, 0, 25)
        buyButton.Position = UDim2.new(1, -55, 0, 7.5)
        buyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        buyButton.BorderSizePixel = 0
        buyButton.Text = "خرید"
        buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        buyButton.TextSize = 12
        buyButton.Font = Enum.Font.GothamBold
        buyButton.Parent = itemFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = buyButton
        
        buyButton.MouseButton1Click:Connect(function()
            FertilizerSystem.buyFertilizer(fertilizerName)
        end)
        
        yOffset = yOffset + 50
    end
    
    -- دکمه بستن
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 100, 0, 30)
    closeButton.Position = UDim2.new(0.5, -50, 1, -40)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "بستن"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = shopFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        shopFrame.Visible = false
    end)
    
    return shopFrame
end

function FertilizerSystem.buyFertilizer(fertilizerName)
    local fertilizerData = fertilizerTypes[fertilizerName]
    if gameData.coins >= fertilizerData.price then
        gameData.coins = gameData.coins - fertilizerData.price
        
        -- اضافه کردن کود به موجودی
        if not gameData.fertilizers then
            gameData.fertilizers = {}
        end
        if not gameData.fertilizers[fertilizerName] then
            gameData.fertilizers[fertilizerName] = 0
        end
        gameData.fertilizers[fertilizerName] = gameData.fertilizers[fertilizerName] + 1
        
        updateUI()
        showNotification("کود " .. fertilizerData.name .. " خریداری شد!")
    else
        showNotification("سکه کافی ندارید!")
    end
end

function FertilizerSystem.applyFertilizer(cell, plant, fertilizerName)
    local fertilizerData = fertilizerTypes[fertilizerName]
    
    if gameData.fertilizers and gameData.fertilizers[fertilizerName] and gameData.fertilizers[fertilizerName] > 0 then
        gameData.fertilizers[fertilizerName] = gameData.fertilizers[fertilizerName] - 1
        
        -- اعمال اثر کود
        plant.fertilizerEffect = fertilizerData.effect
        plant.fertilizerEndTime = tick() + fertilizerData.duration
        
        -- انیمیشن کوددهی
        local fertilizerEffect = Instance.new("TextLabel")
        fertilizerEffect.Text = "✨"
        fertilizerEffect.TextSize = 35
        fertilizerEffect.BackgroundTransparency = 1
        fertilizerEffect.Position = UDim2.new(0.5, -17.5, 0.5, -17.5)
        fertilizerEffect.Parent = cell.frame
        
        local effectTween = TweenService:Create(fertilizerEffect, 
            TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {Position = UDim2.new(0.5, -17.5, 0, -35), TextTransparency = 1, TextSize = 15}
        )
        effectTween:Play()
        
        effectTween.Completed:Connect(function()
            fertilizerEffect:Destroy()
        end)
        
        updateUI()
        showNotification("کود " .. fertilizerData.name .. " اعمال شد!")
        return true
    else
        showNotification("کود " .. fertilizerData.name .. " در دسترس نیست!")
        return false
    end
end

-- سیستم چالش‌ها و ماموریت‌ها
local ChallengeSystem = {}

local dailyChallenges = {
    {
        id = "plant_10_seeds",
        name = "کاشت 10 بذر",
        description = "در یک روز 10 بذر بکارید",
        target = 10,
        reward = 500,
        type = "planting"
    },
    {
        id = "harvest_5_plants",
        name = "برداشت 5 گیاه",
        description = "5 گیاه بالغ را برداشت کنید",
        target = 5,
        reward = 300,
        type = "harvesting"
    },
    {
        id = "earn_1000_coins",
        name = "کسب 1000 سکه",
        description = "در یک روز 1000 سکه کسب کنید",
        target = 1000,
        reward = 200,
        type = "earning"
    }
}

function ChallengeSystem.initializeChallenges()
    if not gameData.challenges then
        gameData.challenges = {}
        gameData.challengeProgress = {}
        
        for _, challenge in pairs(dailyChallenges) do
            gameData.challenges[challenge.id] = challenge
            gameData.challengeProgress[challenge.id] = 0
        end
    end
end

function ChallengeSystem.updateProgress(challengeType, amount)
    for challengeId, challenge in pairs(gameData.challenges) do
        if challenge.type == challengeType then
            gameData.challengeProgress[challengeId] = gameData.challengeProgress[challengeId] + amount
            
            -- بررسی تکمیل چالش
            if gameData.challengeProgress[challengeId] >= challenge.target then
                ChallengeSystem.completeChallenge(challengeId)
            end
        end
    end
end

function ChallengeSystem.completeChallenge(challengeId)
    local challenge = gameData.challenges[challengeId]
    if challenge and not gameData.challengeCompleted[challengeId] then
        gameData.coins = gameData.coins + challenge.reward
        gameData.experience = gameData.experience + 50
        
        if not gameData.challengeCompleted then
            gameData.challengeCompleted = {}
        end
        gameData.challengeCompleted[challengeId] = true
        
        showNotification("🎉 چالش '" .. challenge.name .. "' تکمیل شد!")
        showNotification("پاداش: +" .. challenge.reward .. " 🪙 و +50 XP")
        
        updateUI()
        checkLevelUp()
    end
end

-- سیستم آمار و دستاوردها
local StatisticsSystem = {}

function StatisticsSystem.initializeStats()
    if not gameData.statistics then
        gameData.statistics = {
            totalPlantsPlanted = 0,
            totalPlantsHarvested = 0,
            totalCoinsEarned = 0,
            totalCoinsSpent = 0,
            totalExperienceGained = 0,
            playTime = 0,
            favoritePlant = "هیچ‌کدام"
        }
    end
end

function StatisticsSystem.updateStat(statName, value)
    if gameData.statistics and gameData.statistics[statName] then
        gameData.statistics[statName] = gameData.statistics[statName] + value
    end
end

function StatisticsSystem.getStats()
    return gameData.statistics
end

-- سیستم ذخیره‌سازی
local SaveSystem = {}

function SaveSystem.saveGame()
    local saveData = {
        coins = gameData.coins,
        level = gameData.level,
        experience = gameData.experience,
        experienceToNext = gameData.experienceToNext,
        unlockedSeeds = gameData.unlockedSeeds,
        gardenSize = gameData.gardenSize,
        plants = gameData.plants,
        fertilizers = gameData.fertilizers,
        challenges = gameData.challenges,
        challengeProgress = gameData.challengeProgress,
        challengeCompleted = gameData.challengeCompleted,
        statistics = gameData.statistics
    }
    
    local encodedData = HttpService:JSONEncode(saveData)
    
    -- ذخیره در LocalStorage (در Roblox از طریق DataStore استفاده کنید)
    if pcall then
        pcall(function()
            writefile("GrowGardenSave.json", encodedData)
        end)
    end
    
    showNotification("بازی ذخیره شد!")
end

function SaveSystem.loadGame()
    local success, data = pcall(function()
        if readfile then
            local fileData = readfile("GrowGardenSave.json")
            return HttpService:JSONDecode(fileData)
        end
    end)
    
    if success and data then
        for key, value in pairs(data) do
            gameData[key] = value
        end
        
        showNotification("بازی بارگذاری شد!")
        updateUI()
        return true
    end
    
    return false
end

-- سیستم موسیقی و صدا
local MusicSystem = {}

local backgroundTracks = {
    "100697759026652", -- موسیقی آرام
    "9120715547",      -- موسیقی شاد
    "12222253"         -- موسیقی طبیعت
}

local currentTrack = 1
local musicVolume = 0.3

function MusicSystem.playBackgroundMusic()
    if not gameData.backgroundMusic then
        gameData.backgroundMusic = createSound(backgroundTracks[currentTrack], musicVolume, 1)
        gameData.backgroundMusic.Looped = true
        gameData.backgroundMusic:Play()
    end
end

function MusicSystem.changeTrack()
    if gameData.backgroundMusic then
        gameData.backgroundMusic:Stop()
        currentTrack = (currentTrack % #backgroundTracks) + 1
        gameData.backgroundMusic = createSound(backgroundTracks[currentTrack], musicVolume, 1)
        gameData.backgroundMusic.Looped = true
        gameData.backgroundMusic:Play()
        
        showNotification("موسیقی تغییر کرد!")
    end
end

function MusicSystem.toggleMusic()
    if gameData.backgroundMusic then
        if gameData.backgroundMusic.IsPlaying then
            gameData.backgroundMusic:Pause()
            showNotification("موسیقی متوقف شد")
        else
            gameData.backgroundMusic:Resume()
            showNotification("موسیقی ادامه یافت")
        end
    end
end

-- تابع راه‌اندازی ویژگی‌های پیشرفته
function initializeAdvancedFeatures()
    -- راه‌اندازی سیستم‌های مختلف
    ChallengeSystem.initializeChallenges()
    StatisticsSystem.initializeStats()
    MusicSystem.playBackgroundMusic()
    
    -- ایجاد دکمه‌های کنترل
    local controlPanel = Instance.new("Frame")
    controlPanel.Name = "ControlPanel"
    controlPanel.Size = UDim2.new(0, 200, 0, 150)
    controlPanel.Position = UDim2.new(1, -220, 0, 20)
    controlPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    controlPanel.BorderSizePixel = 0
    controlPanel.Parent = game.Parent -- باید به mainFrame متصل شود
    
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0, 15)
    controlCorner.Parent = controlPanel
    
    local controlShadow = Instance.new("UIStroke")
    controlShadow.Color = Color3.fromRGB(0, 0, 0)
    controlShadow.Thickness = 2
    controlShadow.Transparency = 0.2
    controlShadow.Parent = controlPanel
    
    -- دکمه‌های کنترل
    local musicButton = Instance.new("TextButton")
    musicButton.Name = "MusicButton"
    musicButton.Size = UDim2.new(0, 80, 0, 30)
    musicButton.Position = UDim2.new(0, 10, 0, 10)
    musicButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    musicButton.BorderSizePixel = 0
    musicButton.Text = "🎵 موسیقی"
    musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicButton.TextSize = 12
    musicButton.Font = Enum.Font.GothamBold
    musicButton.Parent = controlPanel
    
    local musicCorner = Instance.new("UICorner")
    musicCorner.CornerRadius = UDim.new(0, 8)
    musicCorner.Parent = musicButton
    
    musicButton.MouseButton1Click:Connect(function()
        MusicSystem.toggleMusic()
    end)
    
    local saveButton = Instance.new("TextButton")
    saveButton.Name = "SaveButton"
    saveButton.Size = UDim2.new(0, 80, 0, 30)
    saveButton.Position = UDim2.new(1, -90, 0, 10)
    saveButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    saveButton.BorderSizePixel = 0
    saveButton.Text = "💾 ذخیره"
    saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveButton.TextSize = 12
    saveButton.Font = Enum.Font.GothamBold
    saveButton.Parent = controlPanel
    
    local saveCorner = Instance.new("UICorner")
    saveCorner.CornerRadius = UDim.new(0, 8)
    saveCorner.Parent = saveButton
    
    saveButton.MouseButton1Click:Connect(function()
        SaveSystem.saveGame()
    end)
    
    local statsButton = Instance.new("TextButton")
    statsButton.Name = "StatsButton"
    statsButton.Size = UDim2.new(0, 80, 0, 30)
    statsButton.Position = UDim2.new(0, 10, 0, 50)
    statsButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    statsButton.BorderSizePixel = 0
    statsButton.Text = "📊 آمار"
    statsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsButton.TextSize = 12
    statsButton.Font = Enum.Font.GothamBold
    statsButton.Parent = controlPanel
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = statsButton
    
    statsButton.MouseButton1Click:Connect(function()
        showStatistics()
    end)
    
    local challengeButton = Instance.new("TextButton")
    challengeButton.Name = "ChallengeButton"
    challengeButton.Size = UDim2.new(0, 80, 0, 30)
    challengeButton.Position = UDim2.new(1, -90, 0, 50)
    challengeButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    challengeButton.BorderSizePixel = 0
    challengeButton.Text = "🎯 چالش"
    challengeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    challengeButton.TextSize = 12
    challengeButton.Font = Enum.Font.GothamBold
    challengeButton.Parent = controlPanel
    
    local challengeCorner = Instance.new("UICorner")
    challengeCorner.CornerRadius = UDim.new(0, 8)
    challengeCorner.Parent = challengeButton
    
    challengeButton.MouseButton1Click:Connect(function()
        showChallenges()
    end)
    
    showNotification("ویژگی‌های پیشرفته فعال شدند!")
end

-- تابع نمایش آمار
function showStatistics()
    local stats = StatisticsSystem.getStats()
    if not stats then return end
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.Size = UDim2.new(0, 400, 0, 500)
    statsFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    statsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = game.Parent
    statsFrame.ZIndex = 300
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 15)
    statsCorner.Parent = statsFrame
    
    local statsShadow = Instance.new("UIStroke")
    statsShadow.Color = Color3.fromRGB(0, 0, 0)
    statsShadow.Thickness = 3
    statsShadow.Transparency = 0.2
    statsShadow.Parent = statsFrame
    
    local statsTitle = Instance.new("TextLabel")
    statsTitle.Name = "StatsTitle"
    statsTitle.Size = UDim2.new(1, 0, 0, 50)
    statsTitle.Position = UDim2.new(0, 0, 0, 0)
    statsTitle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    statsTitle.BorderSizePixel = 0
    statsTitle.Text = "📊 آمار بازی"
    statsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsTitle.TextSize = 20
    statsTitle.Font = Enum.Font.FredokaOne
    statsTitle.Parent = statsFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = statsTitle
    
    local statsContainer = Instance.new("ScrollingFrame")
    statsContainer.Name = "StatsContainer"
    statsContainer.Size = UDim2.new(1, -20, 1, -70)
    statsContainer.Position = UDim2.new(0, 10, 0, 60)
    statsContainer.BackgroundTransparency = 1
    statsContainer.ScrollBarThickness = 6
    statsContainer.Parent = statsFrame
    
    local statsLayout = Instance.new("UIListLayout")
    statsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    statsLayout.Padding = UDim.new(0, 10)
    statsLayout.Parent = statsContainer
    
    -- نمایش آمار
    local statItems = {
        {name = "کل گیاهان کاشته شده", value = stats.totalPlantsPlanted, icon = "🌱"},
        {name = "کل گیاهان برداشت شده", value = stats.totalPlantsHarvested, icon = "🌻"},
        {name = "کل سکه‌های کسب شده", value = stats.totalCoinsEarned, icon = "🪙"},
        {name = "کل سکه‌های خرج شده", value = stats.totalCoinsSpent, icon = "💸"},
        {name = "کل تجربه کسب شده", value = stats.totalExperienceGained, icon = "⭐"},
        {name = "زمان بازی", value = math.floor(stats.playTime / 60) .. " دقیقه", icon = "⏰"},
        {name = "گیاه مورد علاقه", value = stats.favoritePlant, icon = "❤️"}
    }
    
    for _, statItem in pairs(statItems) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = "StatItem_" .. statItem.name
        itemFrame.Size = UDim2.new(1, 0, 0, 50)
        itemFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        itemFrame.BorderSizePixel = 0
        itemFrame.Parent = statsContainer
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = itemFrame
        
        local itemIcon = Instance.new("TextLabel")
        itemIcon.Name = "ItemIcon"
        itemIcon.Size = UDim2.new(0, 40, 0, 40)
        itemIcon.Position = UDim2.new(0, 10, 0, 5)
        itemIcon.BackgroundTransparency = 1
        itemIcon.Text = statItem.icon
        itemIcon.TextSize = 25
        itemIcon.Font = Enum.Font.FredokaOne
        itemIcon.Parent = itemFrame
        
        local itemName = Instance.new("TextLabel")
        itemName.Name = "ItemName"
        itemName.Size = UDim2.new(1, -120, 0, 25)
        itemName.Position = UDim2.new(0, 60, 0, 5)
        itemName.BackgroundTransparency = 1
        itemName.Text = statItem.name
        itemName.TextColor3 = Color3.fromRGB(0, 0, 0)
        itemName.TextSize = 14
        itemName.Font = Enum.Font.GothamBold
        itemName.TextXAlignment = Enum.TextXAlignment.Left
        itemName.Parent = itemFrame
        
        local itemValue = Instance.new("TextLabel")
        itemValue.Name = "ItemValue"
        itemValue.Size = UDim2.new(0, 100, 0, 25)
        itemValue.Position = UDim2.new(1, -110, 0, 5)
        itemValue.BackgroundTransparency = 1
        itemValue.Text = tostring(statItem.value)
        itemValue.TextColor3 = Color3.fromRGB(100, 100, 100)
        itemValue.TextSize = 14
        itemValue.Font = Enum.Font.Gotham
        itemValue.TextXAlignment = Enum.TextXAlignment.Right
        itemValue.Parent = itemFrame
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
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = statsFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        statsFrame:Destroy()
    end)
end

-- تابع نمایش چالش‌ها
function showChallenges()
    local challengeFrame = Instance.new("Frame")
    challengeFrame.Name = "ChallengeFrame"
    challengeFrame.Size = UDim2.new(0, 400, 0, 500)
    challengeFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    challengeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    challengeFrame.BorderSizePixel = 0
    challengeFrame.Parent = game.Parent
    challengeFrame.ZIndex = 300
    
    local challengeCorner = Instance.new("UICorner")
    challengeCorner.CornerRadius = UDim.new(0, 15)
    challengeCorner.Parent = challengeFrame
    
    local challengeShadow = Instance.new("UIStroke")
    challengeShadow.Color = Color3.fromRGB(0, 0, 0)
    challengeShadow.Thickness = 3
    challengeShadow.Transparency = 0.2
    challengeShadow.Parent = challengeFrame
    
    local challengeTitle = Instance.new("TextLabel")
    challengeTitle.Name = "ChallengeTitle"
    challengeTitle.Size = UDim2.new(1, 0, 0, 50)
    challengeTitle.Position = UDim2.new(0, 0, 0, 0)
    challengeTitle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    challengeTitle.BorderSizePixel = 0
    challengeTitle.Text = "🎯 چالش‌های روزانه"
    challengeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    challengeTitle.TextSize = 20
    challengeTitle.Font = Enum.Font.FredokaOne
    challengeTitle.Parent = challengeFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = challengeTitle
    
    local challengeContainer = Instance.new("ScrollingFrame")
    challengeContainer.Name = "ChallengeContainer"
    challengeContainer.Size = UDim2.new(1, -20, 1, -70)
    challengeContainer.Position = UDim2.new(0, 10, 0, 60)
    challengeContainer.BackgroundTransparency = 1
    challengeContainer.ScrollBarThickness = 6
    challengeContainer.Parent = challengeFrame
    
    local challengeLayout = Instance.new("UIListLayout")
    challengeLayout.SortOrder = Enum.SortOrder.LayoutOrder
    challengeLayout.Padding = UDim.new(0, 10)
    challengeLayout.Parent = challengeContainer
    
    -- نمایش چالش‌ها
    for challengeId, challenge in pairs(gameData.challenges) do
        local progress = gameData.challengeProgress[challengeId] or 0
        local isCompleted = gameData.challengeCompleted and gameData.challengeCompleted[challengeId]
        
        local challengeItem = Instance.new("Frame")
        challengeItem.Name = "ChallengeItem_" .. challengeId
        challengeItem.Size = UDim2.new(1, 0, 0, 80)
        challengeItem.BackgroundColor3 = isCompleted and Color3.fromRGB(200, 255, 200) or Color3.fromRGB(240, 240, 240)
        challengeItem.BorderSizePixel = 0
        challengeItem.Parent = challengeContainer
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = challengeItem
        
        local itemBorder = Instance.new("UIStroke")
        itemBorder.Color = isCompleted and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        itemBorder.Thickness = 2
        itemBorder.Transparency = 0.3
        itemBorder.Parent = challengeItem
        
        local challengeName = Instance.new("TextLabel")
        challengeName.Name = "ChallengeName"
        challengeName.Size = UDim2.new(1, -20, 0, 25)
        challengeName.Position = UDim2.new(0, 10, 0, 5)
        challengeName.BackgroundTransparency = 1
        challengeName.Text = challenge.name
        challengeName.TextColor3 = Color3.fromRGB(0, 0, 0)
        challengeName.TextSize = 16
        challengeName.Font = Enum.Font.GothamBold
        challengeName.TextXAlignment = Enum.TextXAlignment.Left
        challengeName.Parent = challengeItem
        
        local challengeDesc = Instance.new("TextLabel")
        challengeDesc.Name = "ChallengeDesc"
        challengeDesc.Size = UDim2.new(1, -20, 0, 20)
        challengeDesc.Position = UDim2.new(0, 10, 0, 30)
        challengeDesc.BackgroundTransparency = 1
        challengeDesc.Text = challenge.description
        challengeDesc.TextColor3 = Color3.fromRGB(100, 100, 100)
        challengeDesc.TextSize = 12
        challengeDesc.Font = Enum.Font.Gotham
        challengeDesc.TextXAlignment = Enum.TextXAlignment.Left
        challengeDesc.Parent = challengeItem
        
        local progressText = Instance.new("TextLabel")
        progressText.Name = "ProgressText"
        progressText.Size = UDim2.new(1, -20, 0, 20)
        progressText.Position = UDim2.new(0, 10, 0, 55)
        progressText.BackgroundTransparency = 1
        progressText.Text = "پیشرفت: " .. progress .. "/" .. challenge.target
        progressText.TextColor3 = Color3.fromRGB(70, 130, 180)
        progressText.TextSize = 12
        progressText.Font = Enum.Font.GothamBold
        progressText.TextXAlignment = Enum.TextXAlignment.Left
        progressText.Parent = challengeItem
        
        if isCompleted then
            local completedIcon = Instance.new("TextLabel")
            completedIcon.Name = "CompletedIcon"
            completedIcon.Size = UDim2.new(0, 30, 0, 30)
            completedIcon.Position = UDim2.new(1, -40, 0, 25)
            completedIcon.BackgroundTransparency = 1
            completedIcon.Text = "✅"
            completedIcon.TextSize = 20
            completedIcon.Font = Enum.Font.FredokaOne
            completedIcon.Parent = challengeItem
        end
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
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = challengeFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        challengeFrame:Destroy()
    end)
end

-- راه‌اندازی خودکار ویژگی‌های پیشرفته
spawn(function()
    wait(5) -- صبر کنید تا بازی اصلی کاملاً بارگذاری شود
    initializeAdvancedFeatures()
end)

return {
    WateringSystem = WateringSystem,
    FertilizerSystem = FertilizerSystem,
    ChallengeSystem = ChallengeSystem,
    StatisticsSystem = StatisticsSystem,
    SaveSystem = SaveSystem,
    MusicSystem = MusicSystem
}