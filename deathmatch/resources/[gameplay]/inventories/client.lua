local inventoriesWindow = nil                -- หน้าต่างหลักของร้านค้า
local tabPanel = nil                        -- แท็บแยกหมวดหมู่อาวุธ
local categories = {
    "general",    -- หมวดทั่วไป
    "drugs",      -- หมวดยาเสพติด
    "weapon",    -- หมวดอาวุธ
}
local tabs = {}                             -- เก็บแท็บแต่ละหมวดหมู่
local selectedWeapon = nil                  -- เก็บข้อมูลอาวุธที่เลือกในขณะนั้น (id, name, price)
local weaponButtons = {}                    -- เก็บปุ่มรูปปืนทั้งหมดเพื่อใช้ลบ Event Handler ตอนปิด GUI
local buyButton = nil                       -- ปุ่มซื้ออาวุธ
local closeButton = nil                     -- ปุ่มปิดหน้าต่างร้านค้า
local selectedWeaponLabel = nil             -- ป้ายแสดงอาวุธที่เลือก
local selectedWeaponImage = nil             -- รูปอาวุธที่เลือก

local screenW, screenH = guiGetScreenSize() -- ดึงขนาดหน้าจอของผู้เล่น
local windowWidth, windowHeight = 900, 500  -- กำหนดขนาดหน้าต่างร้านค้า
local x = (screenW - windowWidth) / 2       -- คำนวณตำแหน่งกึ่งกลางหน้าจอ
local y = (screenH - windowHeight) / 2      -- คำนวณตำแหน่งกึ่งกลางหน้าจอ


function createInventoriesGUI()
    -- ถ้ากดอีกครั้งให้ปิด GUI (toggle)
    if inventoriesWindow and isElement(inventoriesWindow) then
        hideGUI()
        return
    end
    -- สร้างหน้าต่างหลัก
    inventoriesWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Weapon Shop", false)
    guiWindowSetSizable(inventoriesWindow, false) -- ไม่ให้ปรับขนาดหน้าต่างได้
    -- สร้าง TabPanel สำหรับแยกหมวดหมู่อาวุธ
    -- ตำแหน่ง X=10, Y=30, กว้าง=680, สูง=420
    tabPanel = guiCreateTabPanel(10, 30, 680, 420, false, inventoriesWindow)
    -- วนลูปสร้าง Tab สำหรับแต่ละหมวด
    for _, category in ipairs(categories) do
        local tab = guiCreateTab(category:gsub("^%l", string.upper), tabPanel)
        tabs[category] = tab
        -- ที่นี่สามารถเพิ่มโค้ดเพื่อเติมปุ่มรูปอาวุธในแต่ละแท็บได้
    end

    -- แสดงเคอร์เซอร์เมาส์
    showCursor(true)
end


function hideGUI()
    -- GUI hiding code here
    if inventoriesWindow and isElement(inventoriesWindow) then
        -- ลบ Event Handlers จากปุ่ม Buy และ Close
        removeEventHandler("onClientGUIClick", buyButton, onBuyButtonClick, false)
        removeEventHandler("onClientGUIClick", closeButton, hideGUI, false)
        -- วนลูปลบ Event Handlers จากทุกปุ่มรูปอาวุธ
        for _, btn in ipairs(weaponButtons) do
            if isElement(btn) then
                removeEventHandler("onClientGUIClick", btn, onWeaponImageClick, false)
            end
        end
        -- ทำลายหน้าต่างร้านค้า
        destroyElement(inventoriesWindow)
        -- รีเซ็ตตัวแปรทั้งหมด
        inventoriesWindow = nil
        selectedWeapon = nil
        weaponButtons = {}
        -- ซ่อนเคอร์เซอร์เมาส์
        showCursor(false)
    end
end

-- ผูกปุ่ม 'i' ให้เป็น toggle: เปิดถ้าไม่มี, ปิดถ้ามี
bindKey("i", "down", createInventoriesGUI)