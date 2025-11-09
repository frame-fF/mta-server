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
            -- สร้าง Label และ Grid สำหรับอาวุธ
            local weaponLabel = guiCreateLabel(10, 10, 650, 20, "Weapons", false, tab)
            local weaponGrid = guiCreateGridList(10, 30, 650, 150, false, tab)
            guiGridListAddColumn(weaponGrid, "Name", 0.4)
            guiGridListAddColumn(weaponGrid, "Count", 0.3)
            guiGridListAddColumn(weaponGrid, "Slot", 0.3)
            
            -- สร้าง Label และ Grid สำหรับกระสุน
            local ammoLabel = guiCreateLabel(10, 190, 650, 20, "Ammo", false, tab)
            local ammoGrid = guiCreateGridList(10, 210, 650, 140, false, tab)
            guiGridListAddColumn(ammoGrid, "Name", 0.5)
            guiGridListAddColumn(ammoGrid, "Count", 0.5)
        
            local player_weapons = getElementData(localPlayer, "weapons") or {}
            local player_ammo = getElementData(localPlayer, "ammo") or {}
            
            -- เพิ่มอาวุธเข้า Grid
            for weaponID, weaponInfo in pairs(DATA_WEAPON) do
                local count = player_weapons[tostring(weaponID)] or 0
                if count > 0 then
                    local row = guiGridListAddRow(weaponGrid)
                    guiGridListSetItemText(weaponGrid, row, 1, weaponInfo.name or "Unknown", false, false)
                    guiGridListSetItemText(weaponGrid, row, 2, tostring(count), false, false)
                    guiGridListSetItemText(weaponGrid, row, 3, tostring(weaponInfo.slot or "N/A"), false, false)
                end
            end
            
            -- เพิ่มกระสุนเข้า Grid
            for ammoID, ammoInfo in pairs(DATA_AMMO) do
                local ammoCount = player_ammo[tostring(ammoID)] or 0
                if ammoCount > 0 then
                    local row = guiGridListAddRow(ammoGrid)
                    guiGridListSetItemText(ammoGrid, row, 1, ammoInfo.name or "Unknown Ammo", false, false)
                    guiGridListSetItemText(ammoGrid, row, 2, tostring(ammoCount), false, false)
                end
            end
            -- เก็บ reference ของ grids
            weaponGrids[tabName] = weaponGrid
            weaponGrids["ammo"] = ammoGrid
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
