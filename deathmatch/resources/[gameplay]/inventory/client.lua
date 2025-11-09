local inventoryWindow = nil -- หน้าต่างหลักของร้านค้า
local tabPanel = nil        -- แท็บแยกหมวดหมู่อาวุธ
local tabs = {}
local weaponGrids = {}
local ammoGrid = nil
local tab_menu = {
    "general",
    "medicine",
    "weapon",
}                                           -- เก็บแท็บแต่ละหมวดหมู่

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
            weaponGrids[tabName] = weaponGrid
            weaponGrids["ammo"] = ammoGrid
            addEventHandler("onClientGUIClick", weaponGrid, onGridClick)
            addEventHandler("onClientGUIClick", ammoGrid, onGridClick)
        end
    end

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
