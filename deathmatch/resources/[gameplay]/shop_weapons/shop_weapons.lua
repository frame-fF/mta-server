local a = createBlip(-2625.85, 208.345, 3.98935, 6, 2, 255, 0, 0, 255, 0, 300)
local b = createMarker(295.626953125, -37.5712890625, 1000.5, "cylinder", 2, 255, 255, 0, 255)
setElementInterior(b, 1)
setElementDimension(b, 1)


function activeMarkers(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        local player = hitElement
        setMarkerColor(source, 0, 255, 0, 255)
        triggerClientEvent(hitElement, "shop_weapons:showGUI", hitElement)
    end
end

function disabledMarkers(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        local player = hitElement
        setMarkerColor(source, 255, 255, 0, 255)
         triggerClientEvent(hitElement, "shop_weapons:hideGUI", hitElement)
    end
end

addEventHandler("onMarkerHit", b, activeMarkers)
addEventHandler("onMarkerLeave", b, disabledMarkers)

-- ตารางราคาปืนฝั่ง server
local weaponData = {
    -- Handguns 
    [22] = { price = 100, ammo = 50 }, -- Colt 45
    [23] = { price = 100, ammo = 50 }, -- Silenced
    [24] = { price = 100, ammo = 50 },  -- Desert Eagle
    -- Shotguns 
    [25] = { price = 100, ammo = 30 },-- Shotgun
    [26] = { price = 100, ammo = 30 },-- Sawed-off
    [27] = { price = 100, ammo = 30 },  -- Combat Shotgun
    -- Sub-Machine Guns
    [28] = { price = 100, ammo = 60 },-- Uzi
    [29] = { price = 100, ammo = 60 },-- MP5
    [32] = { price = 100, ammo = 60 },  -- Tec-9
    -- Assault Rifles 
    [30] = { price = 100, ammo = 90 },-- Ak47
    [31] = { price = 100, ammo = 90 },-- M4
    -- Rifles
    [33] = { price = 100, ammo = 20 },-- Rifle
    [34] = { price = 100, ammo = 20 },-- Sniper Rifle
    --Heavy Weapons
    [35] = { price = 1000, ammo = 500 },-- Rocket Launcher
    [36] = { price = 1000, ammo = 500 }, -- Rocket Launcher HS
    [37] = { price = 1000, ammo = 500 },-- Flame
    [38] = { price = 1000, ammo = 500 },-- Minigun
    --Projectiles 
    [16] = { price = 50, ammo = 20 },-- Grenade
    [17] = { price = 50, ammo = 20 },-- Tear Gas
    [18] = { price = 50, ammo = 20 },-- Molotov
    [39] = { price = 50, ammo = 20 },-- Satchel
    -- Armor
    ["armor"] = { price = 1000, ammo = 100 } -- Body Armor
}

function buyWeapon(weaponID)
    -- client คือผู้เล่นที่ส่ง event มา
    local player = client

    if weaponID == "armor" then
        local armorInfo = weaponData["armor"]
        if not armorInfo then return end
        
        local price = armorInfo.price
        local armorAmount = armorInfo.ammo -- ใช้ ammo เป็นค่าเกราะ
        
        if getPlayerMoney(player) >= price then
            takePlayerMoney(player, price)
            setPedArmor(player, armorAmount) -- ให้เกราะแทนปืน
            outputChatBox("You have purchased Body Armor.", player, 0, 255, 0)
        else
            outputChatBox("You don't have enough money.", player, 255, 0, 0)
        end
        return
    end
    
    local weaponInfo = weaponData[tonumber(weaponID)]

    if not weaponInfo then return end

    local price = weaponInfo.price
    local ammo = weaponInfo.ammo

    if getPlayerMoney(player) >= price then
        takePlayerMoney(player, price)
        giveWeapon(player, weaponID, ammo, true) -- ให้ปืนพร้อมกระสุนตามที่กำหนด
        outputChatBox("You have purchased a weapon.", player, 0, 255, 0)
    else
        outputChatBox("You don't have enough money.", player, 255, 0, 0)
    end
end

addEvent("shop_weapons:buyWeapon", true)
addEventHandler("shop_weapons:buyWeapon", root, buyWeapon)

-- Marker1 = createMarker(-2034.8935546875, 148.5478515625, 28.8359375 + 1.5, "arrow", 2, 255, 255, 0, 255)
-- pickup1 = createPickup(291.8271484375, -83.0009765625, 1001.515625, 0, 10, 5000)

-- local x,y,z,int,dim = 285.8000, -84.5470, 1001.5390, 4, 1
-- setElementInterior(pickup1, int)
-- setElementDimension(pickup1, dim )

-- function activeMarkers(hitElement, matchingDimension)
--     if getElementType(hitElement) == "player" and matchingDimension then
--         local player = hitElement
--         setElementPosition(player, 285.8000, -84.5470, 1001.5390)
--         setElementInterior(player, 4)
--         setElementDimension(player, 1)
--     end
-- end

-- addEventHandler("onMarkerHit", Marker1, activeMarkers)


-- local ExitMarker = createMarker(285.8466796875, -86.7822265625, 1001.5228881836 + 1.5, "arrow", 2, 255, 0, 0, 255)
-- setElementInterior(ExitMarker, 4)
-- setElementDimension(ExitMarker, 1)

-- function exitInterior(hitElement, matchingDimension)
--     if getElementType(hitElement) == "player" and matchingDimension then
--         local player = hitElement
--         -- ส่งผู้เล่นกลับไปยังตำแหน่งเริ่มต้น
--         setElementPosition(player, -2027.3447265625, 148.8935546875, 28.8359375)
--         setElementInterior(player, 0)
--         setElementDimension(player, 0)
--     end
-- end

-- addEventHandler("onMarkerHit", ExitMarker, exitInterior)