local screenW, screenH = guiGetScreenSize()
local windowWidth, windowHeight = 700, 500
local x = (screenW - windowWidth) / 2
local y = (screenH - windowHeight) / 2

local weaponShopWindow = nil
local tabPanel = nil
local tabs = {}
local selectedWeapon = nil
local weaponButtons = {}
local buyButton = nil
local closeButton = nil
local selectedWeaponLabel = nil
local selectedWeaponImage = nil

-- รายการปืนแยกตามหมวดหมู่
local weaponCategories = {
    {
        name = "Handguns",
        weapons = {
            { 22, "Colt 45", 100 },
            { 23, "Silenced Colt 45", 100 },
            { 24, "Desert Eagle", 100 }
        }
    },
    {
        name = "Shotguns",
        weapons = {
            { 25, "Shotgun", 100 },
            { 26, "Sawed-off Shotgun", 100 },
            { 27, "Combat Shotgun", 100 }
        }
    },
    {
        name = "SMGs",
        weapons = {
            { 28, "Uzi", 100 },
            { 29, "MP5", 100 },
            { 32, "Tec-9", 100 }
        }
    },
    {
        name = "Assault Rifles",
        weapons = {
            { 30, "AK-47", 100 },
            { 31, "M4", 100 }
        }
    },
    {
        name = "Rifles",
        weapons = {
            { 33, "Rifle", 100 },
            { 34, "Sniper Rifle", 100 }
        }
    },
    {
        name = "Heavy Weapons",
        weapons = {
            { 35, "Rocket Launcher", 1000 },
            { 36, "HS Rocket Launcher", 1000 },
            { 37, "Flamethrower", 1000 },
            { 38, "Minigun", 1000 }
        }
    }
}

function createWeaponShopGUI()
    if weaponShopWindow and isElement(weaponShopWindow) then return end

    weaponShopWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Weapon Shop", false)
    guiWindowSetSizable(weaponShopWindow, false)

    -- สร้าง TabPanel
    tabPanel = guiCreateTabPanel(10, 30, 480, 420, false, weaponShopWindow)
    
    -- สร้าง Tab สำหรับแต่ละหมวดหมู่
    for categoryIndex, category in ipairs(weaponCategories) do
        local tab = guiCreateTab(category.name, tabPanel)
        tabs[categoryIndex] = tab
        
        -- สร้างปุ่มรูปปืนในแต่ละ Tab
        local col = 0
        local row = 0
        local buttonSize = 100
        local spacing = 20
        local startX = 20
        local startY = 20
        
        for weaponIndex, weaponData in ipairs(category.weapons) do
            local weaponID = weaponData[1]
            local weaponName = weaponData[2]
            local weaponPrice = weaponData[3]
            
            local btnX = startX + (col * (buttonSize + spacing))
            local btnY = startY + (row * (buttonSize + spacing + 30))
            
            -- สร้าง StaticImage สำหรับรูปปืน
            local weaponImg = guiCreateStaticImage(btnX, btnY, buttonSize, buttonSize, "images/weapons/" .. weaponID .. ".png", false, tab)
            
            -- สร้าง Label แสดงชื่อและราคา
            local label = guiCreateLabel(btnX, btnY + buttonSize + 2, buttonSize, 25, weaponName .. "\n$" .. weaponPrice, false, tab)
            guiSetFont(label, "default-small")
            guiLabelSetHorizontalAlign(label, "center", false)
            guiLabelSetVerticalAlign(label, "top")
            
            -- เก็บข้อมูลปืนไว้ใน element data
            setElementData(weaponImg, "weaponID", weaponID)
            setElementData(weaponImg, "weaponName", weaponName)
            setElementData(weaponImg, "weaponPrice", weaponPrice)
            
            -- เพิ่ม Event Handler สำหรับคลิกรูปปืน
            addEventHandler("onClientGUIClick", weaponImg, onWeaponImageClick, false)
            
            table.insert(weaponButtons, weaponImg)
            
            col = col + 1
            if col >= 4 then
                col = 0
                row = row + 1
            end
        end
    end
    
    -- สร้างพื้นที่แสดงอาวุธที่เลือก (ด้านขวา)
    local infoX = 500
    local infoY = 30
    
    guiCreateLabel(infoX, infoY, 180, 25, "Selected Weapon:", false, weaponShopWindow)
    guiSetFont(guiGetScreenSize() > 1024 and "default-bold-small" or "default-small")
    
    selectedWeaponImage = guiCreateStaticImage(infoX + 40, infoY + 30, 100, 100, "images/item_bg.jpg", false, weaponShopWindow)
    
    selectedWeaponLabel = guiCreateLabel(infoX, infoY + 140, 180, 60, "Please select\na weapon", false, weaponShopWindow)
    guiSetFont(selectedWeaponLabel, "default-bold-small")
    guiLabelSetHorizontalAlign(selectedWeaponLabel, "center", false)
    
    -- ปุ่ม Buy และ Close
    buyButton = guiCreateButton(infoX + 10, infoY + 220, 160, 35, "Buy Weapon", false, weaponShopWindow)
    guiSetEnabled(buyButton, false)
    guiSetProperty(buyButton, "NormalTextColour", "FF90EE90")
    
    closeButton = guiCreateButton(infoX + 10, infoY + 265, 160, 35, "Close", false, weaponShopWindow)
    guiSetProperty(closeButton, "NormalTextColour", "FFFF6B6B")

    -- Event Handlers
    addEventHandler("onClientGUIClick", buyButton, onBuyButtonClick, false)
    addEventHandler("onClientGUIClick", closeButton, hideGUI, false)
    
    showCursor(true)
end

function onWeaponImageClick(button)
    if button == "left" then
        local weaponID = getElementData(source, "weaponID")
        local weaponName = getElementData(source, "weaponName")
        local weaponPrice = getElementData(source, "weaponPrice")
        
        if weaponID then
            selectedWeapon = {
                id = weaponID,
                name = weaponName,
                price = weaponPrice
            }
            
            -- อัพเดตข้อมูลด้านขวา
            guiStaticImageLoadImage(selectedWeaponImage, "images/weapons/" .. weaponID .. ".png")
            guiSetText(selectedWeaponLabel, weaponName .. "\n$" .. weaponPrice)
            guiSetEnabled(buyButton, true)
        end
    end
end

function hideGUI()
    if weaponShopWindow and isElement(weaponShopWindow) then
        -- ลบ Event Handlers
        removeEventHandler("onClientGUIClick", buyButton, onBuyButtonClick, false)
        removeEventHandler("onClientGUIClick", closeButton, hideGUI, false)
        
        for _, btn in ipairs(weaponButtons) do
            if isElement(btn) then
                removeEventHandler("onClientGUIClick", btn, onWeaponImageClick, false)
            end
        end
        
        destroyElement(weaponShopWindow)
        weaponShopWindow = nil
        selectedWeapon = nil
        weaponButtons = {}
        showCursor(false)
    end
end

function onBuyButtonClick()
    if selectedWeapon and selectedWeapon.id then
        -- ส่งข้อมูลไปให้ server ทำการซื้อ
        triggerServerEvent("shop_weapons:buyWeapon", localPlayer, selectedWeapon.id)
        -- ไม่ปิด GUI แล้ว เพื่อให้ซื้อได้ต่อเนื่อง
        -- แสดงข้อความแจ้งเตือนการซื้อสำเร็จ
        outputChatBox("Purchasing " .. selectedWeapon.name .. " for $" .. selectedWeapon.price, 0, 255, 0)
    end
end

-- รับ event จาก server เพื่อแสดง GUI
addEvent("shop_weapons:showGUI", true)
addEventHandler("shop_weapons:showGUI", root, createWeaponShopGUI)

-- รับ event จาก server เพื่อซ่อน GUI
addEvent("shop_weapons:hideGUI", true)
addEventHandler("shop_weapons:hideGUI", root, hideGUI)