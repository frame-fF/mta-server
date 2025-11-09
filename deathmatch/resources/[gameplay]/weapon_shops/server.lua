-- ตารางราคาปืนฝั่ง server
local weaponData = {
    -- Handguns 
    [22] = { price = 200, amount = 1 }, -- Colt 45
    [23] = { price = 600, amount = 1 }, -- Silenced
    [24] = { price = 1200, amount = 1  },  -- Desert Eagle
    [50] = { price = 1200, amount = 30  }, -- 9mm Ammo for Colt 45
    [51] = { price = 1200, amount = 30  },  -- Desert Eagle Ammo
    -- Shotguns 
    [25] = { price = 600, amount = 1  },-- Shotgun
    [26] = { price = 800, amount = 1  },-- Sawed-off
    [27] = { price = 1000, amount = 1  },  -- Combat Shotgun
    [52] = { price = 400, amount = 30  },  -- Shotgun Ammo
    -- Sub-Machine Guns
    [28] = { price = 500, amount = 1  },-- Uzi
    [29] = { price = 2000, amount = 1  },-- MP5
    [32] = { price = 300, amount = 1  },  -- Tec-9
    [53] = { price = 600, amount = 30 },  -- SMG Ammo
    -- Assault Rifles 
    [30] = { price = 3500, amount = 1  },-- Ak47
    [31] = { price = 4500, amount = 1  },-- M4
    [54] = { price = 800, amount = 30 },  -- Assault Rifle Ammo
    -- Rifles
    [33] = { price = 1000, amount = 1  },-- Rifle
    [55] = { price = 800, amount = 30 },  -- Rifle Ammo
    [34] = { price = 5000, amount = 1  },-- Sniper Rifle
    [56] = { price = 1200, amount = 30  },  -- Sniper Ammo
    --Heavy Weapons
    [35] = { price = 6000, amount = 1  },-- Rocket Launcher
    [57] = { price = 800, amount = 1  },  -- Rocket Ammo
    [36] = { price = 6000, amount = 1  }, -- Rocket Launcher HS
    [58] = { price = 800, amount = 1  },  -- HS Rocket Ammo
    [37] = { price = 6000, amount = 1  },-- Flame
    [59] = { price = 800, amount = 500 },  -- Flame Ammo
    [38] = { price = 6000, amount = 1  },-- Minigun
    [60] = { price = 800, amount = 300 },  -- Minigun Ammo
    --Projectiles 
    [16] = { price = 300, amount = 1  },-- Grenade
    [17] = { price = 300, amount = 1  },-- Tear Gas
    [18] = { price = 300, amount = 1  },-- Molotov
    [39] = { price = 2000, amount = 1  },-- Satchel
    -- Armor
    ["armor"] = { price = 5000, amount = 100 } -- Body Armor
}


MAP_AMMO = {
    [50] = {22, 23},
    [51] = {24},
    [52] = {25, 26, 27},
    [53] = {28, 29, 32},
    [54] = {30, 31},
    [55] = {33},
    [56] = {34},
    [57] = {35},
    [58] = {36},
    [59] = {37},
    [60] = {38},
}

-- ฟังก์ชันจัดการการซื้ออาวุธ
local function buyWeapon(weaponID)
    local player = client
    local player_weapons = getElementData(player, "weapons") or {}
    local player_ammo = getElementData(player, "ammo") or {}

    if weaponID == "armor" then
        local armorInfo = weaponData["armor"]
        if not armorInfo then return end
        local price = armorInfo.price
        local armorAmount = armorInfo.amount
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

    if getPlayerMoney(player) < price then
        outputChatBox("You don't have enough money.", player, 255, 0, 0)
        return
    end

    takePlayerMoney(player, price)

    local idNum = tonumber(weaponID)
    if idNum and idNum >= 50 and idNum <= 60 then
        local key = tostring(idNum)
        player_ammo[key] = (player_ammo[key] or 0) + weaponInfo.amount
        iprint("ammo:", toJSON(player_ammo))
        setElementData(player, "ammo", player_ammo)
        if MAP_AMMO[idNum] then
            for slot = 0, 12 do
                local weapon = getPedWeapon(player, slot)
                for _, wID in ipairs(MAP_AMMO[idNum]) do
                    if weapon == wID then
                        ammo = getElementData(player, "ammo")[tostring(idNum)]
                        outputChatBox(weapon)
                        outputChatBox(ammo)
                        giveWeapon(player, weapon, ammo, false)
                        setWeaponAmmo(player, weapon, ammo)
                    end
                end
            end
        end
    else
        local key = tostring(weaponID)
        player_weapons[key] = (player_weapons[key] or 0) + weaponInfo.amount
        iprint("weapon:", toJSON(player_weapons))
        setElementData(player, "weapons", player_weapons)
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