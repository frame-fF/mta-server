-- ========================================
-- Weapon Shop GUI - Client Side Script
-- ========================================
-- Script สำหรับแสดง GUI ร้านขายอาวุธแบบรูปภาพพร้อม Tab แยกหมวดหมู่
-- ผู้เล่นสามารถคลิกรูปปืนเพื่อเลือกและซื้ออาวุธได้

-- ========================================
-- ตัวแปรสำหรับการจัดการหน้าจอและ GUI
-- ========================================

-- ดึงขนาดหน้าจอของผู้เล่น
local screenW, screenH = guiGetScreenSize()

-- กำหนดขนาด GUI Window (กว้าง x สูง)
local windowWidth, windowHeight = 700, 500

-- คำนวณตำแหน่งให้ GUI อยู่กลางจอ
local x = (screenW - windowWidth) / 2
local y = (screenH - windowHeight) / 2

-- ========================================
-- ตัวแปร GUI Elements
-- ========================================

-- หน้าต่างหลักของร้านค้า
local weaponShopWindow = nil

-- แท็บแยกหมวดหมู่อาวุธ
local tabPanel = nil

-- เก็บ Tab ทั้งหมด
local tabs = {}

-- เก็บข้อมูลอาวุธที่เลือกในขณะนั้น (id, name, price)
local selectedWeapon = nil

-- เก็บปุ่มรูปปืนทั้งหมดเพื่อใช้ลบ Event Handler ตอนปิด GUI
local weaponButtons = {}

-- ปุ่มซื้ออาวุธ
local buyButton = nil

-- ปุ่มปิด GUI
local closeButton = nil

-- Label แสดงชื่อและราคาอาวุธที่เลือก
local selectedWeaponLabel = nil

-- StaticImage แสดงรูปอาวุธที่เลือก
local selectedWeaponImage = nil

-- ========================================
-- ข้อมูลอาวุธแยกตามหมวดหมู่
-- ========================================
-- โครงสร้าง: { id, "ชื่ออาวุธ", ราคา }
-- รูปอาวุธจะถูกโหลดจาก images/weapons/{id}.png
local weaponCategories = {
    -- หมวดปืนพก (Handguns)
    {
        name = "Handguns",
        weapons = {
            { 22, "Colt 45", 100 },            -- ปืนพกมาตรฐาน
            { 23, "Silenced Colt 45", 100 },   -- ปืนพกติดเครื่องเก็บเสียง
            { 24, "Desert Eagle", 100 }        -- ปืนพกขนาดใหญ่ พลังสูง
        }
    },
    -- หมวดปืนลูกซอง (Shotguns)
    {
        name = "Shotguns",
        weapons = {
            { 25, "Shotgun", 100 },            -- ปืนลูกซองมาตรฐาน
            { 26, "Sawed-off Shotgun", 100 },  -- ปืนลูกซองลำกล้องสั้น
            { 27, "Combat Shotgun", 100 }      -- ปืนลูกซองต่อสู้
        }
    },
    -- หมวดปืนกลมือ (Sub-Machine Guns)
    {
        name = "SMGs",
        weapons = {
            { 28, "Uzi", 100 },                -- ปืนกลมือขนาดเล็ก
            { 29, "MP5", 100 },                -- ปืนกลมือยอดนิยม
            { 32, "Tec-9", 100 }               -- ปืนกลมืออัตโนมัติ
        }
    },
    -- หมวดปืนไรเฟิลจู่โจม (Assault Rifles)
    {
        name = "Assault Rifles",
        weapons = {
            { 30, "AK-47", 100 },              -- ปืนไรเฟิลรัสเซีย
            { 31, "M4", 100 }                  -- ปืนไรเฟิลอเมริกัน
        }
    },
    -- หมวดปืนไรเฟิลระยะไกล (Rifles)
    {
        name = "Rifles",
        weapons = {
            { 33, "Rifle", 100 },              -- ปืนไรเฟิลมาตรฐาน
            { 34, "Sniper Rifle", 100 }        -- ปืนไรเฟิลซุ่มยิง
        }
    },
    -- หมวดอาวุธหนัก (Heavy Weapons)
    {
        name = "Heavy Weapons",
        weapons = {
            { 35, "Rocket Launcher", 1000 },    -- ปล่อยจรวด
            { 36, "HS Rocket Launcher", 1000 }, -- ปล่อยจรวดติดตามความร้อน
            { 37, "Flamethrower", 1000 },       -- พ่นไฟ
            { 38, "Minigun", 1000 }             -- ปืนกลหนัก
        }
    }
}

-- ========================================
-- ฟังก์ชันสร้าง GUI ร้านขายอาวุธ
-- ========================================
-- ฟังก์ชันนี้จะสร้างหน้าต่าง GUI พร้อม Tab แยกหมวดหมู่
-- และแสดงรูปอาวุธทั้งหมดให้คลิกเลือกได้
function createWeaponShopGUI()
    -- ป้องกันการสร้าง GUI ซ้ำถ้ามีอยู่แล้ว
    if weaponShopWindow and isElement(weaponShopWindow) then return end

    -- สร้างหน้าต่างหลัก
    weaponShopWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Weapon Shop", false)
    guiWindowSetSizable(weaponShopWindow, false) -- ไม่ให้ปรับขนาดหน้าต่างได้

    -- สร้าง TabPanel สำหรับแยกหมวดหมู่อาวุธ
    -- ตำแหน่ง X=10, Y=30, กว้าง=480, สูง=420
    tabPanel = guiCreateTabPanel(10, 30, 480, 420, false, weaponShopWindow)
    
    -- วนลูปสร้าง Tab สำหรับแต่ละหมวดหมู่อาวุธ
    for categoryIndex, category in ipairs(weaponCategories) do
        -- สร้าง Tab ใหม่ตามชื่อหมวดหมู่
        local tab = guiCreateTab(category.name, tabPanel)
        tabs[categoryIndex] = tab
        
        -- ========================================
        -- สร้างปุ่มรูปอาวุธในแต่ละ Tab
        -- ========================================
        local col = 0        -- คอลัมน์ปัจจุบัน (0-3)
        local row = 0        -- แถวปัจจุบัน
        local buttonSize = 100   -- ขนาดรูปอาวุธ 100x100 pixels
        local spacing = 20       -- ระยะห่างระหว่างรูป
        local startX = 20        -- ตำแหน่งเริ่มต้น X
        local startY = 20        -- ตำแหน่งเริ่มต้น Y
        
        -- วนลูปสร้างรูปอาวุธในหมวดหมู่นี้
        for weaponIndex, weaponData in ipairs(category.weapons) do
            -- ดึงข้อมูลอาวุธ
            local weaponID = weaponData[1]      -- ID อาวุธ (ใช้โหลดรูป)
            local weaponName = weaponData[2]    -- ชื่ออาวุธ
            local weaponPrice = weaponData[3]   -- ราคาอาวุธ
            
            -- คำนวณตำแหน่งของรูปอาวุธ (แบบ Grid 4 คอลัมน์)
            local btnX = startX + (col * (buttonSize + spacing))
            local btnY = startY + (row * (buttonSize + spacing + 30)) -- +30 สำหรับ Label
            
            -- สร้าง StaticImage แสดงรูปอาวุธ (โหลดจากไฟล์ images/weapons/{id}.png)
            local weaponImg = guiCreateStaticImage(btnX, btnY, buttonSize, buttonSize, "images/weapons/" .. weaponID .. ".png", false, tab)
            
            -- สร้าง Label แสดงชื่อและราคาอาวุธใต้รูป
            local label = guiCreateLabel(btnX, btnY + buttonSize + 2, buttonSize, 25, weaponName .. "\n$" .. weaponPrice, false, tab)
            guiSetFont(label, "default-small")                    -- ตั้งฟอนต์เล็ก
            guiLabelSetHorizontalAlign(label, "center", false)    -- จัดกึ่งกลางแนวนอน
            guiLabelSetVerticalAlign(label, "top")                -- จัดด้านบน
            
            -- เก็บข้อมูลอาวุธไว้ใน Element Data เพื่อใช้ตอนคลิก
            setElementData(weaponImg, "weaponID", weaponID)
            setElementData(weaponImg, "weaponName", weaponName)
            setElementData(weaponImg, "weaponPrice", weaponPrice)
            
            -- เพิ่ม Event Handler เพื่อรับการคลิกบนรูปอาวุธ
            addEventHandler("onClientGUIClick", weaponImg, onWeaponImageClick, false)
            
            -- เก็บปุ่มไว้ใน table เพื่อลบ Event Handler ตอนปิด GUI
            table.insert(weaponButtons, weaponImg)
            
            -- เลื่อนไปคอลัมน์ถัดไป
            col = col + 1
            -- ถ้าครบ 4 คอลัมน์ ให้ขึ้นแถวใหม่
            if col >= 4 then
                col = 0
                row = row + 1
            end
        end
    end
    
    -- ========================================
    -- สร้างพื้นที่แสดงอาวุธที่เลือก (ด้านขวาของหน้าต่าง)
    -- ========================================
    local infoX = 500  -- ตำแหน่ง X เริ่มต้น
    local infoY = 30   -- ตำแหน่ง Y เริ่มต้น
    
    -- Label หัวข้อ "Selected Weapon:"
    guiCreateLabel(infoX, infoY, 180, 25, "Selected Weapon:", false, weaponShopWindow)
    guiSetFont(guiGetScreenSize() > 1024 and "default-bold-small" or "default-small")
    
    -- รูปอาวุธที่เลือกขนาดใหญ่ (เริ่มต้นเป็นพื้นหลัง)
    selectedWeaponImage = guiCreateStaticImage(infoX + 40, infoY + 30, 100, 100, "images/item_bg.jpg", false, weaponShopWindow)
    
    -- Label แสดงชื่อและราคาอาวุธที่เลือก
    selectedWeaponLabel = guiCreateLabel(infoX, infoY + 140, 180, 60, "Please select\na weapon", false, weaponShopWindow)
    guiSetFont(selectedWeaponLabel, "default-bold-small")
    guiLabelSetHorizontalAlign(selectedWeaponLabel, "center", false)
    
    -- ========================================
    -- สร้างปุ่ม Buy และ Close
    -- ========================================
    
    -- ปุ่มซื้ออาวุธ (เริ่มต้นปิดการใช้งาน จนกว่าจะเลือกอาวุธ)
    buyButton = guiCreateButton(infoX + 10, infoY + 220, 160, 35, "Buy Weapon", false, weaponShopWindow)
    guiSetEnabled(buyButton, false)  -- ปิดปุ่มไว้ก่อนจนกว่าจะเลือกอาวุธ
    guiSetProperty(buyButton, "NormalTextColour", "FF90EE90")  -- สีเขียวอ่อน
    
    -- ปุ่มปิด GUI
    closeButton = guiCreateButton(infoX + 10, infoY + 265, 160, 35, "Close", false, weaponShopWindow)
    guiSetProperty(closeButton, "NormalTextColour", "FFFF6B6B")  -- สีแดงอ่อน

    -- ========================================
    -- ผูก Event Handlers กับปุ่ม
    -- ========================================
    addEventHandler("onClientGUIClick", buyButton, onBuyButtonClick, false)
    addEventHandler("onClientGUIClick", closeButton, hideGUI, false)
    
    -- แสดงเคอร์เซอร์เมาส์
    showCursor(true)
    
    -- อนุญาตให้ผู้เล่นเดินได้ขณะเปิด GUI
    guiSetInputEnabled(false)
end

-- ========================================
-- ฟังก์ชันจัดการการคลิกบนรูปอาวุธ
-- ========================================
-- เมื่อผู้เล่นคลิกที่รูปอาวุธ จะแสดงข้อมูลอาวุธนั้นด้านขวา
-- และเปิดใช้งานปุ่ม Buy
function onWeaponImageClick(button)
    -- ตรวจสอบว่าเป็นการคลิกซ้าย
    if button == "left" then
        -- ดึงข้อมูลอาวุธจาก Element Data
        local weaponID = getElementData(source, "weaponID")
        local weaponName = getElementData(source, "weaponName")
        local weaponPrice = getElementData(source, "weaponPrice")
        
        -- ถ้ามีข้อมูลอาวุธ
        if weaponID then
            -- เก็บข้อมูลอาวุธที่เลือกไว้ในตัวแปร
            selectedWeapon = {
                id = weaponID,
                name = weaponName,
                price = weaponPrice
            }
            
            -- อัพเดตรูปอาวุธด้านขวา (โหลดรูปใหม่)
            guiStaticImageLoadImage(selectedWeaponImage, "images/weapons/" .. weaponID .. ".png")
            
            -- อัพเดต Label แสดงชื่อและราคาอาวุธที่เลือก
            guiSetText(selectedWeaponLabel, weaponName .. "\n$" .. weaponPrice)
            
            -- เปิดใช้งานปุ่ม Buy
            guiSetEnabled(buyButton, true)
        end
    end
end

-- ========================================
-- ฟังก์ชันปิด GUI ร้านขายอาวุธ
-- ========================================
-- ลบ Event Handlers ทั้งหมดและทำลาย GUI Elements
function hideGUI()
    -- ตรวจสอบว่า GUI ยังมีอยู่หรือไม่
    if weaponShopWindow and isElement(weaponShopWindow) then
        -- ลบ Event Handlers จากปุ่ม Buy และ Close
        removeEventHandler("onClientGUIClick", buyButton, onBuyButtonClick, false)
        removeEventHandler("onClientGUIClick", closeButton, hideGUI, false)
        
        -- วนลูปลบ Event Handlers จากทุกปุ่มรูปอาวุธ
        for _, btn in ipairs(weaponButtons) do
            if isElement(btn) then
                removeEventHandler("onClientGUIClick", btn, onWeaponImageClick, false)
            end
        end
        
        -- ทำลาย GUI หน้าต่างหลัก (จะทำลาย elements ภายในทั้งหมดด้วย)
        destroyElement(weaponShopWindow)
        
        -- รีเซ็ตตัวแปรทั้งหมด
        weaponShopWindow = nil
        selectedWeapon = nil
        weaponButtons = {}
        
        -- คืนค่าการควบคุมคีย์บอร์ดกลับมาเป็นปกติ
        guiSetInputEnabled(true)
        
        -- ซ่อนเคอร์เซอร์เมาส์
        showCursor(false)
    end
end

-- ========================================
-- ฟังก์ชันจัดการการกดปุ่มซื้ออาวุธ
-- ========================================
-- ส่งคำขอซื้ออาวุธไปยัง Server และแสดงข้อความยืนยัน
-- GUI จะไม่ปิด เพื่อให้สามารถซื้ออาวุธต่อได้
function onBuyButtonClick()
    -- ตรวจสอบว่ามีอาวุธที่เลือกอยู่หรือไม่
    if selectedWeapon and selectedWeapon.id then
        -- ส่ง Event ไปยัง Server เพื่อดำเนินการซื้ออาวุธ
        -- ส่งพารามิเตอร์: Player element และ Weapon ID
        triggerServerEvent("shop_weapons:buyWeapon", localPlayer, selectedWeapon.id)
        
        -- แสดงข้อความยืนยันการซื้อในแชท (สีเขียว: R=0, G=255, B=0)
        outputChatBox("Purchasing " .. selectedWeapon.name .. " for $" .. selectedWeapon.price, 0, 255, 0)
        
        -- หมายเหตุ: ไม่มีการปิด GUI (hideGUI()) เพื่อให้ซื้อต่อได้
    end
end

-- ========================================
-- Event Handlers รับจาก Server
-- ========================================

-- รับ Event จาก Server เพื่อแสดง GUI ร้านขายอาวุธ
addEvent("shop_weapons:showGUI", true)
addEventHandler("shop_weapons:showGUI", root, createWeaponShopGUI)

-- รับ Event จาก Server เพื่อซ่อน GUI ร้านขายอาวุธ
addEvent("shop_weapons:hideGUI", true)
addEventHandler("shop_weapons:hideGUI", root, hideGUI)