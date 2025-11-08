-- ตารางราคาปืนฝั่ง server
local weaponData = {
    -- Handguns 
    [22] = { price = 200, ammo = 34 }, -- Colt 45
    [23] = { price = 600, ammo = 34 }, -- Silenced
    [24] = { price = 1200, ammo = 14 },  -- Desert Eagle
    -- Shotguns 
    [25] = { price = 600, ammo = 30 },-- Shotgun
    [26] = { price = 800, ammo = 30 },-- Sawed-off
    [27] = { price = 1000, ammo = 30 },  -- Combat Shotgun
    -- Sub-Machine Guns
    [28] = { price = 500, ammo = 30 },-- Uzi
    [29] = { price = 2000, ammo = 30 },-- MP5
    [32] = { price = 300, ammo = 30 },  -- Tec-9
    -- Assault Rifles 
    [30] = { price = 3500, ammo = 30 },-- Ak47
    [31] = { price = 4500, ammo = 30 },-- M4
    -- Rifles
    [33] = { price = 1000, ammo = 20 },-- Rifle
    [34] = { price = 5000, ammo = 20 },-- Sniper Rifle
    --Heavy Weapons
    [35] = { price = 6000, ammo = 10 },-- Rocket Launcher
    [36] = { price = 6000, ammo = 10 }, -- Rocket Launcher HS
    [37] = { price = 6000, ammo = 500 },-- Flame
    [38] = { price = 6000, ammo = 500 },-- Minigun
    --Projectiles 
    [16] = { price = 300, ammo = 1 },-- Grenade
    [17] = { price = 300, ammo = 1 },-- Tear Gas
    [18] = { price = 300, ammo = 1 },-- Molotov
    [39] = { price = 2000, ammo = 1 },-- Satchel
    -- Armor
    ["armor"] = { price = 5000, ammo = 100 } -- Body Armor
}

-- ฟังก์ชันจัดการการซื้ออาวุธ
local function buyWeapon(weaponID)
    local player = client
    if weaponID == "armor" then
        local armorInfo = weaponData["armor"]
        if not armorInfo then return end
        local price = armorInfo.price
        local armorAmount = armorInfo.ammo
        if getPlayerMoney(player) >= price then
            takePlayerMoney(player, price)
            setPedArmor(player, armorAmount)
        else
            outputChatBox("You don't have enough money.", player, 255, 0, 0)
        end
        return
    end
    local weaponInfo = weaponData[weaponID]
    if not weaponInfo then return end
    local price = weaponInfo.price
    local ammo = weaponInfo.ammo
    if getPlayerMoney(player) >= price then
        takePlayerMoney(player, price)
        giveWeapon(player, weaponID, ammo, true) -- ให้ปืนพร้อมกระสุนตามที่กำหนด
    else
        outputChatBox("You don't have enough money.", player, 255, 0, 0)
    end
end


addEvent("weapon_shop_buy", true)
addEventHandler("weapon_shop_buy", root, buyWeapon)


local blip_1 = createBlip(-2625.85, 208.345, 3.98935, 6, 2, 255, 0, 0, 255, 0, 300)
local mark_1 = createMarker(295.626953125, -37.5712890625, 1000.5, "cylinder", 2, 255, 255, 0, 255)
local npc_1 = createPed(179, 295.669921875, -40.45703125, 1001.515625)
setElementInterior(mark_1, 1)
setElementDimension(mark_1, 1)
setElementInterior(npc_1, 1)
setElementDimension(npc_1, 1)

function markerHit_1(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        local player = hitElement
        triggerClientEvent(player, "weapon_shop_open", player)
    end
end

function markerLeave_1(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        local player = hitElement
        triggerClientEvent(player, "weapon_shop_close", player)
    end
end

addEventHandler("onMarkerHit", mark_1, markerHit_1)
addEventHandler("onMarkerLeave", mark_1, markerLeave_1)