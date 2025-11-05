local screenW, screenH = guiGetScreenSize()
local windowWidth, windowHeight = 400, 300
local x = (screenW - windowWidth) / 2
local y = (screenH - windowHeight) / 2

local weaponShopWindow = nil
local weaponList = nil
local buyButton = nil
local closeButton = nil

-- รายการปืนที่จะขาย (id, ชื่อ, ราคา)
local weaponsForSale = {
    -- Handguns
    { 22, "Colt 45", 100 },
    { 23, "Silenced Colt 45", 100 },
    { 24, "Desert Eagle", 100 },
    -- Shotguns
    { 25, "Shotgun", 100 },
    { 26, "Sawed-off Shotgun", 100 },
    { 27, "Combat Shotgun", 100 },
    -- Sub-Machine Guns
    { 28, "Uzi", 100 },
    { 29, "MP5", 100 },
    { 32, "Tec-9", 100 },
    -- Assault Rifles
    { 30, "AK-47", 100 },
    { 31, "M4", 100 },
    -- Rifles
    { 33, "Rifle", 100 },
    { 34, "Sniper Rifle", 100 },
    -- Heavy Weapons
    { 35, "Rocket Launcher", 1000 },
    { 36, "HS Rocket Launcher", 1000 },
    { 37, "Flamethrower", 1000 },
    { 38, "Minigun", 1000 }
}

function createWeaponShopGUI()
    if weaponShopWindow and isElement(weaponShopWindow) then return end

    weaponShopWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Weapon Shop", false)
    guiWindowSetSizable(weaponShopWindow, false)

    weaponList = guiCreateGridList(10, 25, 250, 240, false, weaponShopWindow)
    guiGridListAddColumn(weaponList, "Weapon", 0.5)
    guiGridListAddColumn(weaponList, "Price", 0.3)

    for _, weaponData in ipairs(weaponsForSale) do
        local row = guiGridListAddRow(weaponList)
        guiGridListSetItemText(weaponList, row, 1, weaponData[2], false, false)
        guiGridListSetItemText(weaponList, row, 2, "$" .. weaponData[3], false, false)
        guiGridListSetItemData(weaponList, row, 1, weaponData[1]) -- เก็บ ID ปืนไว้
    end

    buyButton = guiCreateButton(270, 40, 120, 30, "Buy", false, weaponShopWindow)
    closeButton = guiCreateButton(270, 80, 120, 30, "Close", false, weaponShopWindow)

    -- Event Handlers
    addEventHandler("onClientGUIClick", buyButton, onBuyButtonClick, false)
    addEventHandler("onClientGUIClick", closeButton, hideGUI, false)
    
    showCursor(true)
end

function hideGUI()
    if weaponShopWindow and isElement(weaponShopWindow) then
        removeEventHandler("onClientGUIClick", buyButton, onBuyButtonClick, false)
        removeEventHandler("onClientGUIClick", closeButton, hideGUI, false)
        destroyElement(weaponShopWindow)
        weaponShopWindow = nil
        showCursor(false)
    end
end

function onBuyButtonClick()
    local selectedRow = guiGridListGetSelectedItem(weaponList)
    if selectedRow ~= -1 then
        local weaponID = guiGridListGetItemData(weaponList, selectedRow, 1)
        if weaponID then
            -- ส่งข้อมูลไปให้ server ทำการซื้อ
            triggerServerEvent("shop_weapons:buyWeapon", localPlayer, weaponID)
        end
    end
end

-- รับ event จาก server เพื่อแสดง GUI
addEvent("shop_weapons:showGUI", true)
addEventHandler("shop_weapons:showGUI", root, createWeaponShopGUI)

-- รับ event จาก server เพื่อซ่อน GUI
addEvent("shop_weapons:hideGUI", true)
addEventHandler("shop_weapons:hideGUI", root, hideGUI)