local inventoryWindow = nil                -- หน้าต่างหลักของร้านค้า
local tabPanel = nil                        -- แท็บแยกหมวดหมู่อาวุธ
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


function createInventoryGUI()
    -- ป้องกันการสร้าง GUI ซ้ำถ้ามีอยู่แล้ว
    if inventoryWindow and isElement(inventoryWindow) then
        hideGUI()
        return
     end
    -- สร้างหน้าต่างหลัก
    inventoryWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Inventory", false)
    guiWindowSetSizable(inventoryWindow, false) -- ไม่ให้ปรับขนาดหน้าต่างได้
    -- สร้าง TabPanel สำหรับแยกหมวดหมู่อาวุธ
    -- ตำแหน่ง X=10, Y=30, กว้าง=680, สูง=420
    tabPanel = guiCreateTabPanel(10, 30, 680, 420, false, inventoryWindow)

    -- แสดงเคอร์เซอร์เมาส์
    showCursor(true)
end

function hideGUI()
    -- GUI hiding code here
    if inventoryWindow and isElement(inventoryWindow) then
        
        destroyElement(inventoryWindow)
        -- รีเซ็ตตัวแปรทั้งหมด
        inventoryWindow = nil
        -- ซ่อนเคอร์เซอร์เมาส์
        showCursor(false)
    end
end

bindKey("i", "down", createInventoryGUI)
