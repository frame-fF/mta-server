local inventoryWindow = nil -- หน้าต่างหลักของร้านค้า
local tabPanel = nil        -- แท็บแยกหมวดหมู่อาวุธ
local tabs = {}
local weaponButtons = {}
local ammoButtons = {}
local tab_menu = {
    "general",
    "medicine",
    "weapon",
}
local selectedItemImage = nil
local selectedItemLabel = nil
local useButton = nil
local removeButton = nil
local closeButton = nil
local dropButton = nil
local selectedItem = nil

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
            for i, name in ipairs({ "Weapon", "Ammo" }) do
                local tabSub = guiCreateTab(name, subTabPanel)
                if name == "Weapon" then
                    tabs[name] = tabSub
                    -- สร้าง Scroll Pane เพื่อให้เลื่อนได้เมื่อมีข้อมูลเยอะ
                    local scrollPane = guiCreateScrollPane(0, 0, 660, 380, false, tabSub)
                    local col = 0          -- คอลัมน์ปัจจุบัน (0-3)
                    local row = 0          -- แถวปัจจุบัน
                    local buttonSize = 100 -- ขนาดรูปอาวุธ 100x100 pixels
                    local spacing = 20     -- ระยะห่างระหว่างรูป
                    local startX = 20      -- ตำแหน่งเริ่มต้น X
                    local startY = 20      -- ตำแหน่งเริ่มต้น Y
                    local player = localPlayer
                    local weapons = {}
                    for key, value in pairs(getElementData(player, "weapons")) do
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
                    local slotWeapon = {
                        { slot = 2, name = "Pistols" },
                        { slot = 3, name = "Shotguns" },
                        { slot = 4, name = "SMGs & Assault Rifles" },
                        { slot = 5, name = "Rifles" },
                        { slot = 6, name = "Heavy Weapons" },
                        { slot = 7, name = "Special Weapons" },
                        { slot = 8, name = "Throwables" },
                    }
                    for slot, slotName in ipairs(slotWeapon) do
                        for id, info in pairs(DATA_WEAPON) do
                            if info.slot == slot then
                                if weapons[tostring(id)] then
                                    local weaponID = id                        -- ID อาวุธ (ใช้โหลดรูป)
                                    local weaponName = info.name               -- ชื่ออาวุธ
                                    local weaponDiscription = info.discription -- ราคาอาวุธ
                                    local weaponCount = getElementData(player, "weapons")[tostring(id)] or 0
                                    -- คำนวณตำแหน่งของรูปอาวุธ (แบบ Grid 4 คอลัมน์)
                                    local btnX = startX + (col * (buttonSize + spacing))
                                    local btnY = startY + (row * (buttonSize + spacing + 30)) -- +30 สำหรับ Label
                                    local weaponImg = guiCreateStaticImage(btnX, btnY, buttonSize, buttonSize,
                                        "images/" .. weaponID .. ".png",
                                        false, scrollPane)
                                    if weapons_in_hand[tostring(weaponID)] then
                                        guiSetProperty(weaponImg, "ImageColours",
                                            "tl:FF00FF00 tr:FF00FF00 bl:FF00FF00 br:FF00FF00")
                                    end
                                    -- สร้าง Label แสดงชื่อและราคาอาวุธใต้รูป
                                    local label = guiCreateLabel(btnX, btnY + buttonSize + 2, buttonSize, 25,
                                        weaponName .. "\nx" .. weaponCount,
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
                    local col = 0          -- คอลัมน์ปัจจุบัน (0-3)
                    local row = 0          -- แถวปัจจุบัน
                    local buttonSize = 100 -- ขนาดรูปอาวุธ 100x100 pixels
                    local spacing = 20     -- ระยะห่างระหว่างรูป
                    local startX = 20      -- ตำแหน่งเริ่มต้น X
                    local startY = 20      -- ตำแหน่งเริ่มต้น Y
                    local player = localPlayer
                    local ammo = {}
                    for key, value in pairs(getElementData(player, "ammo")) do
                        if value > 0 then
                            ammo[key] = true
                        end
                    end
                    for id, info in pairs(DATA_AMMO) do
                        if ammo[tostring(id)] then
                            local ammoID = id                        -- ID กระสุน (ใช้โหลดรูป)
                            local ammoName = info.name               -- ชื่อกระสุน
                            local ammoDiscription = info.discription -- ราคาอาวุธ
                            local ammoCount = getElementData(player, "ammo")[tostring(id)] or 0
                            -- คำนวณตำแหน่งของรูปอาวุธ (แบบ Grid 4 คอลัมน์)
                            local btnX = startX + (col * (buttonSize + spacing))
                            local btnY = startY + (row * (buttonSize + spacing + 30)) -- +30 สำหรับ Label
                            local ammoImg = guiCreateStaticImage(btnX, btnY, buttonSize, buttonSize,
                                "images/" .. ammoID .. ".png",
                                false, scrollPane)
                            -- สร้าง Label แสดงชื่อและราคาอาวุธใต้รูป
                            local label = guiCreateLabel(btnX, btnY + buttonSize + 2, buttonSize, 25,
                                ammoName .. "\nx" .. ammoCount,
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
                            table.insert(ammoButtons, ammoImg)
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
    -- ปุ่ม
    useButton = guiCreateButton(infoX + 10, infoY + 220, 160, 35, "Use", false, inventoryWindow)
    guiSetEnabled(useButton, false)                           -- ปิดปุ่มไว้ก่อนจนกว่าจะเลือกอาวุธ
    guiSetProperty(useButton, "NormalTextColour", "FF90EE90") -- สีเขียวอ่อน
    guiSetVisible(useButton, true)
    -- ปุ่มถอด
    removeButton = guiCreateButton(infoX + 10, infoY + 220, 160, 35, "Remove", false, inventoryWindow)
    guiSetEnabled(removeButton, true)
    guiSetProperty(removeButton, "NormalTextColour", "FFFFFF00") -- สีเหลืองอ
    guiSetVisible(removeButton, false)
    -- ปุ่มทิ้ง
    dropButton = guiCreateButton(infoX + 10, infoY + 265, 160, 35, "Drop", false, inventoryWindow)
    guiSetEnabled(dropButton, false)
    guiSetProperty(dropButton, "NormalTextColour", "FFFFFF00") -- สีเหล
    -- ปุ่มปิด GUI
    closeButton = guiCreateButton(infoX + 10, infoY + 310, 160, 35, "Close", false, inventoryWindow)
    guiSetProperty(closeButton, "NormalTextColour", "FFFF6B6B") -- สีแดงอ่อน
    -- ========================================
    -- ผูก Event Handlers กับปุ่ม
    -- ========================================
    addEventHandler("onClientGUIClick", useButton, onUseButtonClick, false)
    addEventHandler("onClientGUIClick", removeButton, onRemoveButtonClick, false)
    addEventHandler("onClientGUIClick", dropButton, onDropButtonClick, false)
    addEventHandler("onClientGUIClick", closeButton, hideGUI, false)
    -- แสดงเคอร์เซอร์เมาส์
    showCursor(true)
end

function onWeaponImageClick(button)
    if button == "left" then
        -- ดึงข้อมูลอาวุธจาก Element Data
        local weaponID = getElementData(source, "weaponID")
        local weaponName = getElementData(source, "weaponName")
        local weaponDiscription = getElementData(source, "weaponDiscription")
        local player = localPlayer
        local weapons_in_hand = {}
        -- เก็บอาวุธที่ถืออยู่
        for slot = 0, 12 do
            local weapon = getPedWeapon(player, slot)
            if weapon > 0 then
                weapons_in_hand[tostring(weapon)] = true
            end
        end
        selectedItem = {
            type = "weapon",
            id = weaponID,
        }
        if weapons_in_hand[tostring(weaponID)] then
            guiSetVisible(useButton, false)
            guiSetVisible(removeButton, true)
        else
            guiSetVisible(useButton, true)
            guiSetVisible(removeButton, false)
        end
        guiStaticImageLoadImage(selectedItemImage, "images/" .. weaponID .. ".png")
        guiSetText(selectedItemLabel, weaponName .. "\n:" .. weaponDiscription)
        -- เปิดใช้งานปุ่ม Buy
        guiSetEnabled(useButton, true)
        guiSetEnabled(dropButton, true)
    end
end

function onAmmoImageClick(button)
    if button == "left" then
        -- ดึงข้อมูลกระสุนจาก Element Data
        local ammoID = getElementData(source, "ammoID")
        local ammoName = getElementData(source, "ammoName")
        local ammoDiscription = getElementData(source, "ammoDiscription")
        selectedAmmo = {
            id = ammoID,
            name = ammoName,
            discription = discription
        }
        guiStaticImageLoadImage(selectedItemImage, "images/" .. ammoID .. ".png")
        guiSetText(selectedItemLabel, ammoName .. "\n:" .. ammoDiscription)
        -- เปิดใช้งานปุ่ม Buy
        guiSetEnabled(useButton, false)
        guiSetEnabled(dropButton, true)
    end
end

function onUseButtonClick()
    if selectedItem then
        -- ส่งคำขอซื้ออาวุธไปยัง Server
        triggerServerEvent("use_item", localPlayer, selectedItem)
    end
end

function onRemoveButtonClick()
    if selectedItem then
        -- ส่งคำขอซื้ออาวุธไปยัง Server
        triggerServerEvent("remove_item", localPlayer, selectedItem)
    end
end

function onDropButtonClick()

end

function hideGUI()
    -- GUI hiding code here
    if inventoryWindow and isElement(inventoryWindow) then
        destroyElement(inventoryWindow)
        -- ลบ Event Handlers
        removeEventHandler("onClientGUIClick", useButton, onUseButtonClick, false)
        removeEventHandler("onClientGUIClick", removeButton, onRemoveButtonClick, false)
        removeEventHandler("onClientGUIClick", dropButton, onDropButtonClick, false)
        removeEventHandler("onClientGUIClick", closeButton, hideGUI, false)
        -- วนลูปลบ Event Handlers
        for _, btn in ipairs(weaponButtons) do
            if isElement(btn) then
                removeEventHandler("onClientGUIClick", btn, onWeaponImageClick, false)
            end
        end
        for _, btn in ipairs(ammoButtons) do
            if isElement(btn) then
                removeEventHandler("onClientGUIClick", btn, onAmmoImageClick, false)
            end
        end
        -- รีเซ็ตตัวแปรทั้งหมด
        inventoryWindow = nil
        selectedItem = nil
        weaponButtons = {}
        ammoButtons = {}
        -- ซ่อนเคอร์เซอร์เมาส์
        showCursor(false)
    end
end

-- ฟังก์ชันอัปเดตสีของอาวุธทั้งหมดตามสถานะ
function updateUserWeapon()
    local player = localPlayer
    local weapons_in_hand = {}

    -- เก็บอาวุธที่ถืออยู่
    for slot = 0, 12 do
        local weapon = getPedWeapon(player, slot)
        if weapon > 0 then
            weapons_in_hand[tostring(weapon)] = true
        end
    end

    -- อัปเดตสีของปุ่มอาวุธทั้งหมด
    for _, weaponImg in ipairs(weaponButtons) do
        local weaponID = getElementData(weaponImg, "weaponID")
        if weaponID then
            if weapons_in_hand[tostring(weaponID)] then
                -- สีเขียวสำหรับอาวุธที่กำลังถืออยู่
                guiSetProperty(weaponImg, "ImageColours", "tl:FF00FF00 tr:FF00FF00 bl:FF00FF00 br:FF00FF00")
            else
                -- สีปกติ (ขาว)
                guiSetProperty(weaponImg, "ImageColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")
            end
        end
    end
    if selectedItem and selectedItem.type == "weapon" then
        if weapons_in_hand[tostring(selectedItem.id)] then
            guiSetVisible(useButton, false)
            guiSetVisible(removeButton, true)
        else
            guiSetVisible(useButton, true)
            guiSetVisible(removeButton, false)
        end
    end
end

-- รับการตอบกลับจาก server ว่าใช้ไอเทมสำเร็จหรือไม่
-- addEvent("onUseItemResponse", true)
-- addEventHandler("onUseItemResponse", localPlayer, function(success)
--     outputChatBox("Item used successfully!")
--     if success and inventoryWindow and isElement(inventoryWindow) then
--         -- ถ้าใช้สำเร็จ ให้อัปเดตสีอาวุธ
--         updateWeaponColors()
--     end
-- end)

function UseItemResponse(success)
    if success then
        updateUserWeapon()
    end
end

addEvent("onUseItemResponse", true)
addEventHandler("onUseItemResponse", localPlayer, UseItemResponse)



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