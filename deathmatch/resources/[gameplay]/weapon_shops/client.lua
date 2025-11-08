local weaponCategories = {
    -- หมวดปืนพก (Handguns)
    {
        name = "Handguns",
        weapons = {
            { 22, "Colt 45", 100 },          -- ปืนพกมาตรฐาน
            { 23, "Silenced Colt 45", 100 }, -- ปืนพกติดเครื่องเก็บเสียง
            { 24, "Desert Eagle", 100 }      -- ปืนพกขนาดใหญ่ พลังสูง
        }
    },
    -- หมวดปืนลูกซอง (Shotguns)
    {
        name = "Shotguns",
        weapons = {
            { 25, "Shotgun", 100 },           -- ปืนลูกซองมาตรฐาน
            { 26, "Sawed-off Shotgun", 100 }, -- ปืนลูกซองลำกล้องสั้น
            { 27, "Combat Shotgun", 100 }     -- ปืนลูกซองต่อสู้
        }
    },
    -- หมวดปืนกลมือ (Sub-Machine Guns)
    {
        name = "SMGs",
        weapons = {
            { 28, "Uzi", 100 },  -- ปืนกลมือขนาดเล็ก
            { 29, "MP5", 100 },  -- ปืนกลมือยอดนิยม
            { 32, "Tec-9", 100 } -- ปืนกลมืออัตโนมัติ
        }
    },
    -- หมวดปืนไรเฟิลจู่โจม (Assault Rifles)
    {
        name = "Assault Rifles",
        weapons = {
            { 30, "AK-47", 100 }, -- ปืนไรเฟิลรัสเซีย
            { 31, "M4", 100 }     -- ปืนไรเฟิลอเมริกัน
        }
    },
    -- หมวดปืนไรเฟิลระยะไกล (Rifles)
    {
        name = "Rifles",
        weapons = {
            { 33, "Rifle", 100 },       -- ปืนไรเฟิลมาตรฐาน
            { 34, "Sniper Rifle", 100 } -- ปืนไรเฟิลซุ่มยิง
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
    },
    -- หมวดระเบิดและวัตถุระเบิด (Projectiles)
    {
        name = "Projectiles",
        weapons = {
            { 16, "Grenade", 50 },       -- ระเบิดมือ
            { 17, "Tear Gas", 50 },      -- แก๊สน้ำตา
            { 18, "Molotov", 50 },       -- ขวดเพลิง
            { 39, "Satchel Charge", 50 } -- ระเบิดชนิดวางกับพื้น
        }
    },
    -- เกราะ (Armor) - ใช้ "armor"แทน
    {
        name = "Armor",
        weapons = {
            { "armor", "Body Armor", 1000 } -- เสื้อเกราะ
        }
    }
}

local weaponShopWindow = nil -- หน้าต่างหลักของร้านค้า
local tabPanel = nil -- แท็บแยกหมวดหมู่อาวุธ
local tabs = {} -- เก็บแท็บแต่ละหมวดหมู่
local selectedWeapon = nil -- เก็บข้อมูลอาวุธที่เลือกในขณะนั้น (id, name, price)
local weaponButtons = {} -- เก็บปุ่มรูปปืนทั้งหมดเพื่อใช้ลบ Event Handler ตอนปิด GUI
local buyButton = nil -- ปุ่มซื้ออาวุธ
local closeButton = nil -- ปุ่มปิดหน้าต่างร้านค้า
local selectedWeaponLabel = nil -- ป้ายแสดงอาวุธที่เลือก
local selectedWeaponImage = nil -- รูปอาวุธที่เลือก

local screenW, screenH = guiGetScreenSize() -- ดึงขนาดหน้าจอของผู้เล่น
local windowWidth, windowHeight = 900, 500 -- กำหนดขนาดหน้าต่างร้านค้า
local x = (screenW - windowWidth) / 2 -- คำนวณตำแหน่งกึ่งกลางหน้าจอ
local y = (screenH - windowHeight) / 2 -- คำนวณตำแหน่งกึ่งกลางหน้าจอ

function createWeaponShopGUI()
    outputChatBox("open", player)
    -- ป้องกันการสร้าง GUI ซ้ำถ้ามีอยู่แล้ว
    if weaponShopWindow and isElement(weaponShopWindow) then return end
    -- สร้างหน้าต่างหลัก
    weaponShopWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Weapon Shop", false)
    guiWindowSetSizable(weaponShopWindow, false) -- ไม่ให้ปรับขนาดหน้าต่างได้
    -- สร้าง TabPanel สำหรับแยกหมวดหมู่อาวุธ
    -- ตำแหน่ง X=10, Y=30, กว้าง=680, สูง=420
    tabPanel = guiCreateTabPanel(10, 30, 680, 420, false, weaponShopWindow)
    -- วนลูปสร้าง Tab สำหรับแต่ละหมวดหมู่อาวุธ
    for categoryIndex, category in ipairs(weaponCategories) do
        -- สร้าง Tab ใหม่ตามชื่อหมวดหมู่
        local tab = guiCreateTab(category.name, tabPanel)
        tabs[categoryIndex] = tab
        local col = 0        -- คอลัมน์ปัจจุบัน (0-3)
        local row = 0        -- แถวปัจจุบัน
        local buttonSize = 100   -- ขนาดรูปอาวุธ 100x100 pixels
        local spacing = 20       -- ระยะห่างระหว่างรูป
        local startX = 20        -- ตำแหน่งเริ่มต้น X
        local startY = 20        -- ตำแหน่งเริ่มต้น Y
        for weaponIndex, weaponData in ipairs(category.weapons) do
            local weaponID = weaponData[1]      -- ID อาวุธ (ใช้โหลดรูป)
            local weaponName = weaponData[2]    -- ชื่ออาวุธ
            local weaponPrice = weaponData[3]   -- ราคาอาวุธ
            -- คำนวณตำแหน่งของรูปอาวุธ (แบบ Grid 4 คอลัมน์)
            local btnX = startX + (col * (buttonSize + spacing))
            local btnY = startY + (row * (buttonSize + spacing + 30)) -- +30 สำหรับ Label
             -- สร้าง StaticImage แสดงรูปอาวุธ (โหลดจากไฟล์ images/weapons/{id}.png)
            local weaponImg = guiCreateStaticImage(btnX, btnY, buttonSize, buttonSize, "images/" .. weaponID .. ".png", false, tab)
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
    local infoX = 700  -- ตำแหน่ง X เริ่มต้น
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
    -- ปิดการควบคุมเกมเพื่อโฟกัสที่ GUI
    guiSetInputEnabled(true)
end

function hideGUI()
    outputChatBox("close", player)
    -- GUI hiding code here
    if weaponShopWindow and isElement(weaponShopWindow) then
        destroyElement(weaponShopWindow)
        weaponShopWindow = nil
        -- ซ่อนเคอร์เซอร์เมาส์
        showCursor(false)
        -- เปิดการควบคุมเกมกลับมา
        guiSetInputEnabled(false)
    end
end

addEvent("weapon_shop_open", true)
addEventHandler("weapon_shop_open", root, createWeaponShopGUI)


addEvent("weapon_shop_close", true)
addEventHandler("weapon_shop_close", root, hideGUI)
