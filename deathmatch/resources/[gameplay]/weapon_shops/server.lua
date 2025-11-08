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
            outputChatBox("You have purchased Body Armor.", player, 0, 255, 0)
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
        outputChatBox("You have purchased a weapon.", player, 0, 255, 0)
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