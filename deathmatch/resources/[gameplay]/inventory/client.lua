local inventoryWindow = nil                -- หน้าต่างหลักของร้านค้า
local tabPanel = nil                        -- แท็บแยกหมวดหมู่อาวุธ
local tabs = {}  
local weaponGrids = {}
local ammoGrid = nil
local tab_menu={
    "general",
    "medicine",
    "weapon",
}                           -- เก็บแท็บแต่ละหมวดหมู่

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
    -- สร้างแท็บแต่ละหมวดหมู่
    for _, tabName in ipairs(tab_menu) do
        local tab = guiCreateTab(tabName:gsub("^%l", string.upper), tabPanel)
        tabs[tabName] = tab
        if tabName == "weapon" then
            -- สร้าง Grid List สำหรับแสดงรายการอาวุธ
            local weaponGrid = guiCreateGridList(10, 10, 650, 350, false, tab)
            guiGridListAddColumn(weaponGrid, "Weapon Name", 0.5)
            guiGridListAddColumn(weaponGrid, "Count", 0.3)
            guiGridListAddColumn(weaponGrid, "Ammo", 0.2)

            
            local player_weapons = getElementData(localPlayer, "weapons") or {}
            local player_ammo = getElementData(localPlayer, "ammo") or {}
            
            for weaponID, weaponInfo in pairs(DATA_WEAPON) do
                local count = player_weapons[tostring(weaponID)] or 0
                local ammo = player_ammo[tostring(weaponInfo.ammo_id)] or 0
                if count > 0 then  -- แสดงเฉพาะอาวุธที่มีกระสุน
                    local row = guiGridListAddRow(weaponGrid)
                    guiGridListSetItemText(weaponGrid, row, 1, weaponInfo.name or "Unknown", false, false)
                    guiGridListSetItemText(weaponGrid, row, 2, tostring(count), false, false)
                    guiGridListSetItemText(weaponGrid, row, 3, tostring(ammo), false, false)
                end
            end
            -- เก็บ reference ของ grid ไว้ใน weaponGrids ถ้าต้องการใช้ภายหลัง
            weaponGrids[tabName] = weaponGrid
        end
    end

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
