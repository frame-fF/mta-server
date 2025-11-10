local inventoryWindow = nil -- หน้าต่างหลักของร้านค้า
local tabPanel = nil        -- แท็บแยกหมวดหมู่อาวุธ
local tabs = {}
local weaponGrids = {}
local weaponButtons = {} 
local ammoGrid = nil
local tab_menu = {
    "general",
    "medicine",
    "weapon",
}                                           -- เก็บแท็บแต่ละหมวดหมู่
local selectedItemImage = nil  
local selectedItemLabel = nil


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
            -- สร้าง TabPanel ย่อยภายในแท็บ weapon (เต็มพื้นที่ของแท็บ)
            local subTabPanel = guiCreateTabPanel(0, 0, 1, 1, true, tab)
            -- สร้างแท็บย่อย Weapon และ Ammo ภายใน subTabPanel
            for i, name in ipairs({"Weapon", "Ammo"}) do
                local tabSub = guiCreateTab(name, subTabPanel)
                if name == "Weapon" then
                    tabs[name] = tabSub
                    -- สร้าง Scroll Pane เพื่อให้เลื่อนได้เมื่อมีข้อมูลเยอะ
                    local scrollPane = guiCreateScrollPane(0, 0, 660, 380, false, tabSub)
                    local col = 0                         -- คอลัมน์ปัจจุบัน (0-3)
                    local row = 0                         -- แถวปัจจุบัน
                    local buttonSize = 100                -- ขนาดรูปอาวุธ 100x100 pixels
                    local spacing = 20                    -- ระยะห่างระหว่างรูป
                    local startX = 20                     -- ตำแหน่งเริ่มต้น X
                    local startY = 20                     -- ตำแหน่งเริ่มต้น Y
                    local player = localPlayer
                    local weapons = {}
                    for key, value  in pairs(getElementData(player, "weapons")) do
                        if value > 0 then
                            weapons[key] = true
                        end
                    end
                    local weapons_in_hand = {}
                    for slot = 0, 12 do
                        local weapon = getPedWeapon(player, slot)
                        if weapon > 0 then
                            weapons_in_hand[tostring(weapon)] = true
                        end
                    end
                    local slotWeapon={
                        {slot = 2, name = "Pistols"},
                        {slot = 3, name = "Shotguns"},
                        {slot = 4, name = "SMGs & Assault Rifles"},
                        {slot = 5, name = "Rifles"},
                        {slot = 6, name = "Heavy Weapons"},
                        {slot = 7, name = "Special Weapons"},
                        {slot = 8, name = "Throwables"},
                    }   
                    for slot, slotName in ipairs(slotWeapon) do
                        for id, info in pairs(DATA_WEAPON) do
                            if info.slot == slot then
                                if weapons[tostring(id)] then                   
                                    local weaponID = id    -- ID อาวุธ (ใช้โหลดรูป)
                                    local weaponName = info.name   -- ชื่ออาวุธ
                                    local weaponDiscription = info.weaponDiscription -- ราคาอาวุธ
                                    local weaponCount = getElementData(player, "weapons")[tostring(id)] or 0
                                    -- คำนวณตำแหน่งของรูปอาวุธ (แบบ Grid 4 คอลัมน์)
                                    local btnX = startX + (col * (buttonSize + spacing))
                                    local btnY = startY + (row * (buttonSize + spacing + 30)) -- +30 สำหรับ Label
                                    local weaponImg = guiCreateStaticImage(btnX, btnY, buttonSize, buttonSize, "images/" .. weaponID .. ".png",
                                        false, scrollPane)
                                    if weapons_in_hand[tostring(weaponID)] then
                                        guiSetProperty(weaponImg, "ImageColours", "tl:FF00FF00 tr:FF00FF00 bl:FF00FF00 br:FF00FF00")
                                    end
                                    -- สร้าง Label แสดงชื่อและราคาอาวุธใต้รูป
                                    local label = guiCreateLabel(btnX, btnY + buttonSize + 2, buttonSize, 25, weaponName .. "\nx" .. weaponCount,
                                        false, scrollPane)
                                    guiSetFont(label, "default-small")                 -- ตั้งฟอนต์เล็ก
                                    guiLabelSetHorizontalAlign(label, "center", false) -- จัดกึ่งกลางแนวนอน
                                    guiLabelSetVerticalAlign(label, "top")             -- จัดด้านบน
                                    -- เก็บข้อมูลอาวุธไว้ใน Element Data เพื่อใช้ตอนคลิก
                                    setElementData(weaponImg, "weaponID", weaponID)
                                    setElementData(weaponImg, "weaponName", weaponName)
                                    setElementData(weaponImg, "weaponDiscription", weaponDiscription)
                                    -- เพิ่ม Event Handler เพื่อรับการคลิกบนรูปอาวุธ
                                    addEventHandler("onClientGUIClick", weaponImg, onWeaponImageClick, false)
                                    -- เก็บปุ่มไว้ใน table เพื่อลบ Event Handler ตอนปิด GUI
                                    table.insert(weaponButtons, weaponImg)
                                    -- เลื่อนไปคอลัมน์ถัดไป
                                    col = col + 1
                                    -- ถ้าครบ 4 คอลัมน์ ให้ขึ้นแถวใหม่
                                    if col >= 5 then
                                        col = 0
                                        row = row + 1
                                    end
                                end
                            end
                        end
                    end
                else
                    tabs[name] = tabSub
                    -- สร้าง Scroll Pane เพื่อให้เลื่อนได้เมื่อมีข้อมูลเยอะ
                    local scrollPane = guiCreateScrollPane(0, 0, 660, 380, false, tabSub)
                    local col = 0                         -- คอลัมน์ปัจจุบัน (0-3)
                    local row = 0                         -- แถวปัจจุบัน
                    local buttonSize = 100                -- ขนาดรูปอาวุธ 100x100 pixels
                    local spacing = 20                    -- ระยะห่างระหว่างรูป
                    local startX = 20                     -- ตำแหน่งเริ่มต้น X
                    local startY = 20                     -- ตำแหน่งเริ่มต้น Y
                    local player = localPlayer
                    local ammo = {}
                    for key, value  in pairs(getElementData(player, "ammo")) do
                        if value > 0 then
                            ammo[key] = true
                        end
                    end
                    for id, info in pairs(DATA_AMMO) do
                        if ammo[tostring(id)] then                   
                            local ammoID = id    -- ID กระสุน (ใช้โหลดรูป)
                            local ammoName = info.name   -- ชื่อกระสุน
                            local ammoDiscription = info.discription -- ราคาอาวุธ
                            local ammoCount = getElementData(player, "ammo")[tostring(id)] or 0
                            -- คำนวณตำแหน่งของรูปอาวุธ (แบบ Grid 4 คอลัมน์)
                            local btnX = startX + (col * (buttonSize + spacing))
                            local btnY = startY + (row * (buttonSize + spacing + 30)) -- +30 สำหรับ Label
                            local ammoImg = guiCreateStaticImage(btnX, btnY, buttonSize, buttonSize, "images/" .. ammoID .. ".png",
                                false, scrollPane)
                            -- สร้าง Label แสดงชื่อและราคาอาวุธใต้รูป
                            local label = guiCreateLabel(btnX, btnY + buttonSize + 2, buttonSize, 25, ammoName .. "\nx" .. ammoCount,
                                false, scrollPane)
                            guiSetFont(label, "default-small")                 -- ตั้งฟอนต์เล็ก
                            guiLabelSetHorizontalAlign(label, "center", false) -- จัดกึ่งกลางแนวนอน
                            guiLabelSetVerticalAlign(label, "top")             -- จัดด้านบน
                            -- เก็บข้อมูลอาวุธไว้ใน Element Data เพื่อใช้ตอนคลิก
                            setElementData(ammoImg, "ammoID", ammoID)
                            setElementData(ammoImg, "ammoName", ammoName)
                            setElementData(ammoImg, "ammoDiscription", ammoDiscription)
                            -- เพิ่ม Event Handler เพื่อรับการคลิกบนรูปอาวุธ
                            addEventHandler("onClientGUIClick", ammoImg, onAmmoImageClick, false)
                            -- เก็บปุ่มไว้ใน table เพื่อลบ Event Handler ตอนปิด GUI
                            table.insert(weaponButtons, ammoImg)
                            -- เลื่อนไปคอลัมน์ถัดไป
                            col = col + 1
                            -- ถ้าครบ 4 คอลัมน์ ให้ขึ้นแถวใหม่
                            if col >= 5 then
                                col = 0
                                row = row + 1
                            end
                        end
                    end    
                end
            end
        end
    end
    -- ========================================
    -- สร้างพื้นที่แสดงอาวุธที่เลือก (ด้านขวาของหน้าต่าง)
    -- ========================================
    local infoX = 700 -- ตำแหน่ง X เริ่มต้น
    local infoY = 30  -- ตำแหน่ง Y เริ่มต้น
    -- Label หัวข้อ "Selected:"
    guiCreateLabel(infoX, infoY, 180, 25, "Selected Item:", false, inventoryWindow)
    guiSetFont(guiGetScreenSize() > 1024 and "default-bold-small" or "default-small")
    -- รูปอาวุธที่เลือกขนาดใหญ่ (เริ่มต้นเป็นพื้นหลัง)
    selectedItemImage = guiCreateStaticImage(infoX + 40, infoY + 30, 100, 100, "images/default.png", false,
    inventoryWindow)
    -- Label แสดงชื่อและราคาอาวุธที่เลือก
    selectedItemLabel = guiCreateLabel(infoX, infoY + 140, 180, 60, "Please select\na item", false, inventoryWindow)
    guiSetFont(selectedItemLabel, "default-bold-small")
    guiLabelSetHorizontalAlign(selectedItemLabel, "center", false)
    -- แสดงเคอร์เซอร์เมาส์
    showCursor(true)
end

function onGridClick(button, state, absoluteX, absoluteY)
    if button == "right" and state == "up" then
        if source == weaponGrids["weapon"] then
            local row, col = guiGridListGetSelectedItem(source)
            if row ~= -1 then
                local weaponName = guiGridListGetItemText(source, row, 1)
                for id, info in pairs(DATA_WEAPON) do
                    if info.name == weaponName then
                        selectedItem = { type = "weapon", id = id }
                        createContextMenu("weapon")
                        break
                    end
                end
            end
        elseif source == weaponGrids["ammo"] then
            local row, col = guiGridListGetSelectedItem(source)
            if row ~= -1 then
                local ammoName = guiGridListGetItemText(source, row, 1)
                for id, info in pairs(DATA_AMMO) do
                    if info.name == ammoName then
                        selectedItem = { type = "ammo", id = id }
                        createContextMenu("ammo")
                        break
                    end
                end
            end
        end
    end
end

function createContextMenu(itemType)
    if contextMenu then destroyElement(contextMenu) end
    local cursorX, cursorY = getCursorPosition()
    cursorX, cursorY = cursorX * screenW, cursorY * screenH
    contextMenu = guiCreateWindow(cursorX, cursorY, 100, itemType == "weapon" and 80 or 40, "", false)
    guiWindowSetSizable(contextMenu, false)
    if itemType == "weapon" then
        local useBtn = guiCreateButton(10, 10, 80, 25, "ใช้", false, contextMenu)
        addEventHandler("onClientGUIClick", useBtn, function()
            triggerServerEvent("useWeapon", localPlayer, selectedItem.id)
            hideContextMenu()
        end, false)
        local dropBtn = guiCreateButton(10, 40, 80, 25, "ทิ้ง", false, contextMenu)
        addEventHandler("onClientGUIClick", dropBtn, function()
            triggerServerEvent("dropItem", localPlayer, selectedItem.type, selectedItem.id)
            hideContextMenu()
        end, false)
    else
        local dropBtn = guiCreateButton(10, 10, 80, 25, "ทิ้ง", false, contextMenu)
        addEventHandler("onClientGUIClick", dropBtn, function()
            triggerServerEvent("dropItem", localPlayer, selectedItem.type, selectedItem.id)
            hideContextMenu()
        end, false)
    end
end

function hideContextMenu()
    if contextMenu and isElement(contextMenu) then
        destroyElement(contextMenu)
        contextMenu = nil
        selectedItem = nil
    end
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

-- Add this as a handler so that the function will be triggered every time a player fires.
addEventHandler("onClientPlayerWeaponFire", root,
    function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
        if weapon ~= 35 and weapon ~= 36 and weapon ~= 37 and weapon ~= 38 then
            return
        end
        local player = localPlayer
        local weapons = getElementData(player, "weapons") or {}
        local ammo = getElementData(player, "ammo") or {}
        local ammoID = DATA_WEAPON[weapon] and DATA_WEAPON[weapon].ammo_id
        -- outputChatBox(" Client Fired weapon: " .. weapon .. " AmmoID: " .. tostring(ammoID))
        -- test = getPedTotalAmmo(player)
        -- outputChatBox(" Client Ammo in clip: " .. tostring(test))
        if ammoID then
            local ammoCount = ammo[tostring(ammoID)] or 0
            if ammoCount > 0 then
                ammo[tostring(ammoID)] = ammoCount - 1
                if ammo[tostring(ammoID)] == 0 then ammo[tostring(ammoID)] = nil end
                setElementData(player, "ammo", ammo)
            else
                removeWeapon(player, weapon)
            end
        end
    end
)

addEventHandler("onClientProjectileCreation", root, function(creator)
    local projectiles = { [16] = true, [17] = true, [18] = true, [39] = true }
    local player = creator
    local projectileType = getProjectileType(source)
    local weapons = getElementData(player, "weapons") or {}
    -- test = getPedTotalAmmo(player)
    -- outputChatBox(" Client Ammo in clip: " .. tostring(test))
    if projectiles[projectileType] then
        local weaponCount = weapons[tostring(projectileType)] or 0
        if weaponCount > 0 then
            weapons[tostring(projectileType)] = weaponCount - 1
            if weapons[tostring(projectileType)] == 0 then weapons[tostring(projectileType)] = nil end
            setElementData(player, "weapons", weapons)
        end
    end
end)
