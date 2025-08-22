-- ========================================
-- 🌱 GROWTOPIA CLONE - بازی کامل
-- ========================================
-- نویسنده: AI Assistant
-- تاریخ: 2024
-- ========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- 🎵 سیستم صدا
-- ========================================
local function createSound(soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = volume or 0.5
    sound.Pitch = pitch or 1
    sound.Parent = SoundService
    return sound
end

local sounds = {
    plant = createSound("112754501285226", 0.3, 1.2),
    harvest = createSound("12222253", 0.4, 1),
    build = createSound("9120715547", 0.3, 1.1),
    coin = createSound("130785805", 0.5, 1.3),
    levelUp = createSound("100697759026652", 0.6, 1.2)
}

-- ========================================
-- 🎮 متغیرهای اصلی بازی
-- ========================================
local gameData = {
    level = 1,
    experience = 0,
    coins = 1000,
    gems = 50,
    inventory = {},
    farmPlots = {},
    buildings = {},
    friends = {},
    currentPlot = 1
}

-- ========================================
-- 🌱 سیستم کشاورزی
-- ========================================
local crops = {
    wheat = {
        name = "گندم",
        growthTime = 30,
        price = 25,
        experience = 10,
        stages = {"seed", "sprout", "growing", "ready"}
    },
    corn = {
        name = "ذرت", 
        growthTime = 45,
        price = 40,
        experience = 15,
        stages = {"seed", "sprout", "growing", "ready"}
    },
    tomato = {
        name = "گوجه فرنگی",
        growthTime = 60,
        price = 60,
        experience = 20,
        stages = {"seed", "sprout", "growing", "ready"}
    }
}

local function plantCrop(plotId, cropType)
    if gameData.coins >= crops[cropType].price then
        gameData.coins = gameData.coins - crops[cropType].price
        gameData.farmPlots[plotId] = {
            type = cropType,
            stage = 1,
            plantedAt = tick(),
            watered = false
        }
        sounds.plant:Play()
        updateUI()
        return true
    end
    return false
end

local function waterCrop(plotId)
    if gameData.farmPlots[plotId] and not gameData.farmPlots[plotId].watered then
        gameData.farmPlots[plotId].watered = true
        gameData.farmPlots[plotId].growthTime = crops[gameData.farmPlots[plotId].type].growthTime * 0.7
        updateUI()
        return true
    end
    return false
end

local function harvestCrop(plotId)
    local plot = gameData.farmPlots[plotId]
    if plot and plot.stage >= 4 then
        local crop = crops[plot.type]
        gameData.coins = gameData.coins + crop.price
        gameData.experience = gameData.experience + crop.experience
        gameData.farmPlots[plotId] = nil
        sounds.harvest:Play()
        checkLevelUp()
        updateUI()
        return true
    end
    return false
end

-- ========================================
-- 🏠 سیستم ساختمان
-- ========================================
local buildings = {
    house = {
        name = "خانه",
        price = 500,
        size = Vector2.new(4, 3),
        description = "خانه زیبا برای زندگی"
    },
    shop = {
        name = "فروشگاه",
        price = 1000,
        size = Vector2.new(5, 4),
        description = "فروشگاه برای تجارت"
    },
    farm = {
        name = "مزرعه",
        price = 800,
        size = Vector2.new(6, 4),
        description = "مزرعه بزرگ برای کشاورزی"
    }
}

local function buildStructure(buildingType, position)
    if gameData.coins >= buildings[buildingType].price then
        gameData.coins = gameData.coins - buildings[buildingType].price
        table.insert(gameData.buildings, {
            type = buildingType,
            position = position,
            builtAt = tick()
        })
        sounds.build:Play()
        updateUI()
        return true
    end
    return false
end

-- ========================================
-- 📈 سیستم پیشرفت
-- ========================================
local function checkLevelUp()
    local requiredExp = gameData.level * 100
    if gameData.experience >= requiredExp then
        gameData.level = gameData.level + 1
        gameData.experience = gameData.experience - requiredExp
        gameData.coins = gameData.coins + (gameData.level * 50)
        gameData.gems = gameData.gems + 5
        sounds.levelUp:Play()
        showLevelUpNotification()
    end
end

local function showLevelUpNotification()
    -- نمایش اعلان سطح بالا
    local notification = Instance.new("TextLabel")
    notification.Text = "🎉 سطح " .. gameData.level .. " شدید!"
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 0.3, 0)
    notification.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Font = Enum.Font.GothamBold
    notification.TextSize = 20
    notification.Parent = playerGui
    
    local tween = TweenService:Create(notification, TweenInfo.new(2), {
        Position = UDim2.new(0.5, -150, 0.2, 0),
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- ========================================
-- 🎨 رابط کاربری اصلی
-- ========================================
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "GrowtopiaGame"
mainGui.Parent = playerGui
mainGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 800, 0, 600)
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = mainGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🌱 GROWTOPIA CLONE"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 24
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- ========================================
-- 📊 پنل اطلاعات بازیکن
-- ========================================
local statsPanel = Instance.new("Frame")
statsPanel.Name = "StatsPanel"
statsPanel.Size = UDim2.new(0, 200, 0, 150)
statsPanel.Position = UDim2.new(0, 20, 0, 70)
statsPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statsPanel.BorderSizePixel = 0
statsPanel.Parent = mainFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 10)
statsCorner.Parent = statsPanel

local levelText = Instance.new("TextLabel")
levelText.Name = "LevelText"
levelText.Size = UDim2.new(1, 0, 0, 30)
levelText.Position = UDim2.new(0, 10, 0, 10)
levelText.BackgroundTransparency = 1
levelText.Text = "سطح: 1"
levelText.TextColor3 = Color3.fromRGB(255, 255, 255)
levelText.TextSize = 16
levelText.Font = Enum.Font.Gotham
levelText.Parent = statsPanel

local coinsText = Instance.new("TextLabel")
coinsText.Name = "CoinsText"
coinsText.Size = UDim2.new(1, 0, 0, 30)
coinsText.Position = UDim2.new(0, 10, 0, 50)
coinsText.BackgroundTransparency = 1
coinsText.Text = "سکه: 1000"
coinsText.TextColor3 = Color3.fromRGB(255, 215, 0)
coinsText.TextSize = 16
coinsText.Font = Enum.Font.Gotham
coinsText.Parent = statsPanel

local gemsText = Instance.new("TextLabel")
gemsText.Name = "GemsText"
gemsText.Size = UDim2.new(1, 0, 0, 30)
gemsText.Position = UDim2.new(0, 10, 0, 90)
gemsText.BackgroundTransparency = 1
gemsText.Text = "جواهر: 50"
gemsText.TextColor3 = Color3.fromRGB(138, 43, 226)
gemsText.TextSize = 16
gemsText.Font = Enum.Font.Gotham
gemsText.Parent = statsPanel

-- ========================================
-- 🌱 پنل کشاورزی
-- ========================================
local farmPanel = Instance.new("Frame")
farmPanel.Name = "FarmPanel"
farmPanel.Size = UDim2.new(0, 300, 0, 200)
farmPanel.Position = UDim2.new(0, 240, 0, 70)
farmPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
farmPanel.BorderSizePixel = 0
farmPanel.Parent = mainFrame

local farmCorner = Instance.new("UICorner")
farmCorner.CornerRadius = UDim.new(0, 10)
farmCorner.Parent = farmPanel

local farmTitle = Instance.new("TextLabel")
farmTitle.Name = "FarmTitle"
farmTitle.Size = UDim2.new(1, 0, 0, 30)
farmTitle.BackgroundTransparency = 1
farmTitle.Text = "🌾 مزرعه"
farmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
farmTitle.TextSize = 18
farmTitle.Font = Enum.Font.GothamBold
farmTitle.Parent = farmPanel

-- دکمه‌های کشاورزی
local plantButton = Instance.new("TextButton")
plantButton.Name = "PlantButton"
plantButton.Size = UDim2.new(0, 80, 0, 30)
plantButton.Position = UDim2.new(0, 10, 0, 40)
plantButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
plantButton.Text = "کاشت گندم"
plantButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plantButton.Font = Enum.Font.Gotham
plantButton.Parent = farmPanel

local waterButton = Instance.new("TextButton")
waterButton.Name = "WaterButton"
waterButton.Size = UDim2.new(0, 80, 0, 30)
waterButton.Position = UDim2.new(0, 100, 0, 40)
waterButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
waterButton.Text = "آبیاری"
waterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
waterButton.Font = Enum.Font.Gotham
waterButton.Parent = farmPanel

local harvestButton = Instance.new("TextButton")
harvestButton.Name = "HarvestButton"
harvestButton.Size = UDim2.new(0, 80, 0, 30)
harvestButton.Position = UDim2.new(0, 190, 0, 40)
harvestButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
harvestButton.Text = "برداشت"
harvestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
harvestButton.Font = Enum.Font.Gotham
harvestButton.Parent = farmPanel

-- ========================================
-- 🏠 پنل ساختمان
-- ========================================
local buildPanel = Instance.new("Frame")
buildPanel.Name = "BuildPanel"
buildPanel.Size = UDim2.new(0, 250, 0, 150)
buildPanel.Position = UDim2.new(0, 20, 0, 240)
buildPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buildPanel.BorderSizePixel = 0
buildPanel.Parent = mainFrame

local buildCorner = Instance.new("UICorner")
buildCorner.CornerRadius = UDim.new(0, 10)
buildCorner.Parent = buildPanel

local buildTitle = Instance.new("TextLabel")
buildTitle.Name = "BuildTitle"
buildTitle.Size = UDim2.new(1, 0, 0, 30)
buildTitle.BackgroundTransparency = 1
buildTitle.Text = "🏗️ ساختمان"
buildTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
buildTitle.TextSize = 18
buildTitle.Font = Enum.Font.GothamBold
buildTitle.Parent = buildPanel

local houseButton = Instance.new("TextButton")
houseButton.Name = "HouseButton"
houseButton.Size = UDim2.new(0, 70, 0, 30)
houseButton.Position = UDim2.new(0, 10, 0, 40)
houseButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
houseButton.Text = "خانه"
houseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
houseButton.Font = Enum.Font.Gotham
houseButton.Parent = buildPanel

local shopButton = Instance.new("TextButton")
shopButton.Name = "ShopButton"
shopButton.Size = UDim2.new(0, 70, 0, 30)
shopButton.Position = UDim2.new(0, 90, 0, 40)
shopButton.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
shopButton.Text = "فروشگاه"
shopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
shopButton.Font = Enum.Font.Gotham
shopButton.Parent = buildPanel

local farmButton = Instance.new("TextButton")
farmButton.Name = "FarmButton"
farmButton.Size = UDim2.new(0, 70, 0, 30)
farmButton.Position = UDim2.new(0, 170, 0, 40)
farmButton.BackgroundColor3 = Color3.fromRGB(100, 150, 50)
farmButton.Text = "مزرعه"
farmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
farmButton.Font = Enum.Font.Gotham
farmButton.Parent = buildPanel

-- ========================================
-- 📱 پنل چت و اجتماعی
-- ========================================
local socialPanel = Instance.new("Frame")
socialPanel.Name = "SocialPanel"
socialPanel.Size = UDim2.new(0, 300, 0, 200)
socialPanel.Position = UDim2.new(0, 240, 0, 290)
socialPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
socialPanel.BorderSizePixel = 0
socialPanel.Parent = mainFrame

local socialCorner = Instance.new("UICorner")
socialCorner.CornerRadius = UDim.new(0, 10)
socialCorner.Parent = socialPanel

local socialTitle = Instance.new("TextLabel")
socialTitle.Name = "SocialTitle"
socialTitle.Size = UDim2.new(1, 0, 0, 30)
socialTitle.BackgroundTransparency = 1
socialTitle.Text = "💬 چت"
socialTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
socialTitle.TextSize = 18
socialTitle.Font = Enum.Font.GothamBold
socialTitle.Parent = socialPanel

local chatBox = Instance.new("TextBox")
chatBox.Name = "ChatBox"
chatBox.Size = UDim2.new(1, -20, 0, 30)
chatBox.Position = UDim2.new(0, 10, 0, 40)
chatBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
chatBox.Text = ""
chatBox.PlaceholderText = "پیام خود را بنویسید..."
chatBox.TextColor3 = Color3.fromRGB(255, 255, 255)
chatBox.Font = Enum.Font.Gotham
chatBox.Parent = socialPanel

local chatCorner = Instance.new("UICorner")
chatCorner.CornerRadius = UDim.new(0, 5)
chatCorner.Parent = chatBox

local sendButton = Instance.new("TextButton")
sendButton.Name = "SendButton"
sendButton.Size = UDim2.new(0, 60, 0, 30)
sendButton.Position = UDim2.new(1, -70, 0, 40)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
sendButton.Text = "ارسال"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Font = Enum.Font.Gotham
sendButton.Parent = socialPanel

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 5)
sendCorner.Parent = sendButton

-- ========================================
-- 🔄 تابع به‌روزرسانی UI
-- ========================================
local function updateUI()
    levelText.Text = "سطح: " .. gameData.level
    coinsText.Text = "سکه: " .. gameData.coins
    gemsText.Text = "جواهر: " .. gameData.gems
end

-- ========================================
-- 🎯 اتصال دکمه‌ها
-- ========================================
plantButton.MouseButton1Click:Connect(function()
    if plantCrop(gameData.currentPlot, "wheat") then
        showNotification("✅ گندم کاشته شد!")
    else
        showNotification("❌ سکه کافی نیست!")
    end
end)

waterButton.MouseButton1Click:Connect(function()
    if waterCrop(gameData.currentPlot) then
        showNotification("💧 محصول آبیاری شد!")
    else
        showNotification("❌ محصولی برای آبیاری نیست!")
    end
end)

harvestButton.MouseButton1Click:Connect(function()
    if harvestCrop(gameData.currentPlot) then
        showNotification("🌾 محصول برداشت شد!")
    else
        showNotification("❌ محصول آماده برداشت نیست!")
    end
end)

houseButton.MouseButton1Click:Connect(function()
    if buildStructure("house", Vector2.new(0, 0)) then
        showNotification("🏠 خانه ساخته شد!")
    else
        showNotification("❌ سکه کافی نیست!")
    end
end)

shopButton.MouseButton1Click:Connect(function()
    if buildStructure("shop", Vector2.new(0, 0)) then
        showNotification("🏪 فروشگاه ساخته شد!")
    else
        showNotification("❌ سکه کافی نیست!")
    end
end)

farmButton.MouseButton1Click:Connect(function()
    if buildStructure("farm", Vector2.new(0, 0)) then
        showNotification("🌾 مزرعه ساخته شد!")
    else
        showNotification("❌ سکه کافی نیست!")
    end
end)

sendButton.MouseButton1Click:Connect(function()
    local message = chatBox.Text
    if message ~= "" then
        showChatMessage(player.Name .. ": " .. message)
        chatBox.Text = ""
    end
end)

-- ========================================
-- 📢 سیستم اعلان‌ها
-- ========================================
local function showNotification(text)
    local notification = Instance.new("TextLabel")
    notification.Text = text
    notification.Size = UDim2.new(0, 300, 0, 40)
    notification.Position = UDim2.new(0.5, -150, 0.8, 0)
    notification.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Font = Enum.Font.Gotham
    notification.TextSize = 16
    notification.Parent = playerGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    local tween = TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(0.5, -150, 0.7, 0)
    })
    tween:Play()
    
    wait(2)
    
    local fadeTween = TweenService:Create(notification, TweenInfo.new(0.5), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        notification:Destroy()
    end)
end

local function showChatMessage(message)
    local chatMessage = Instance.new("TextLabel")
    chatMessage.Text = message
    chatMessage.Size = UDim2.new(1, -20, 0, 25)
    chatMessage.Position = UDim2.new(0, 10, 0, 80)
    chatMessage.BackgroundTransparency = 1
    chatMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
    chatMessage.Font = Enum.Font.Gotham
    chatMessage.TextSize = 14
    chatMessage.Parent = socialPanel
    chatMessage.TextXAlignment = Enum.TextXAlignment.Left
    
    wait(5)
    chatMessage:Destroy()
end

-- ========================================
-- ⚡ سیستم رشد محصولات
-- ========================================
spawn(function()
    while wait(1) do
        for plotId, plot in pairs(gameData.farmPlots) do
            if plot.watered then
                local crop = crops[plot.type]
                local timeSincePlanted = tick() - plot.plantedAt
                local growthProgress = timeSincePlanted / plot.growthTime
                
                if growthProgress >= 1 then
                    plot.stage = 4 -- آماده برداشت
                elseif growthProgress >= 0.7 then
                    plot.stage = 3 -- در حال رشد
                elseif growthProgress >= 0.3 then
                    plot.stage = 2 -- جوانه
                end
            end
        end
    end
end)

-- ========================================
-- 🎮 راه‌اندازی اولیه
-- ========================================
updateUI()
showNotification("🎮 به Growtopia Clone خوش آمدید!")

-- ========================================
-- 🎯 پایان کد
-- ========================================
print("🌱 Growtopia Clone با موفقیت بارگذاری شد!")
print("🎮 سطح: " .. gameData.level)
print("💰 سکه: " .. gameData.coins)
print("💎 جواهر: " .. gameData.gems)