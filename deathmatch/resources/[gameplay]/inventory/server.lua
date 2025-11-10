local function useItem(data)
    local player = client
    if data.type == "weapon" then
        local projectiles = { [16] = true, [17] = true, [18] = true, [39] = true } -- IDs of throwable weapons
        local weapons = getElementData(player, "weapons") or {}
        local ammo = getElementData(player, "ammo") or {}
        local weaponCount = weapons[tostring(data.id)]
        if projectiles[data.id] then
            if weaponCount > 0 then
                giveWeapon(player, data.id, 1, true)
                setWeaponAmmo(player, data.id, weaponCount)
                -- ส่งสัญญาณกลับไปว่าสำเร็จ
                triggerClientEvent(player, "onUseItemResponse", player, true)
            else
                outputChatBox("You don't have this item!", player)
                -- ส่งสัญญาณกลับไปว่าไม่สำเร็จ
                triggerClientEvent(player, "onUseItemResponse", player, false)
            end
            return
        end
        if weaponCount > 0 then
            local ammoID = DATA_WEAPON[data.id].ammo_id
            local ammoCount = ammo[tostring(ammoID)] or 0
            if ammoCount > 0 then
                giveWeapon(player, data.id, 999, true)
                setWeaponAmmo(player, data.id, ammoCount)
                -- ส่งสัญญาณกลับไปว่าสำเร็จ
                triggerClientEvent(player, "onUseItemResponse", player, true)
            else
                outputChatBox("No ammo for this weapon!", player)
                -- ส่งสัญญาณกลับไปว่าไม่สำเร็จ
                triggerClientEvent(player, "onUseItemResponse", player, false)
            end
        else
            outputChatBox("You don't have this weapon!", player)
        end
    elseif data.type == "ammo" then

    end
end


addEvent("use_item", true)
addEventHandler("use_item", root, useItem)

addEvent("dropItem", true)
addEventHandler("dropItem", root, function(itemType, itemID)
    local player = client
    local x, y, z = getElementPosition(player)
    if itemType == "weapon" then
        -- local weapons = getElementData(player, "weapons") or {}
        -- local count = weapons[tostring(itemID)] or 0
        -- if count > 0 then
        --     weapons[tostring(itemID)] = count - 1
        --     if weapons[tostring(itemID)] == 0 then weapons[tostring(itemID)] = nil end
        --     setElementData(player, "weapons", weapons)
        --     -- create pickup
        --     createPickup(x, y, z, 2, itemID, 30000) -- weapon pickup, respawn 30s
        --     triggerClientEvent(player, "updateInventory", player)
        -- end
    elseif itemType == "ammo" then
        -- local ammo = getElementData(player, "ammo") or {}
        -- local count = ammo[tostring(itemID)] or 0
        -- if count > 0 then
        --     ammo[tostring(itemID)] = count - 1
        --     if ammo[tostring(itemID)] == 0 then ammo[tostring(itemID)] = nil end
        --     setElementData(player, "ammo", ammo)
        --     -- create ammo pickup using first weapon that uses this ammo
        --     local weaponID = MAP_AMMO[itemID] and MAP_AMMO[itemID][1]
        --     if weaponID then
        --         createPickup(x, y, z, 2, weaponID, 1)
        --     end
        --     triggerClientEvent(player, "updateInventory", player)
        -- end
    end
end)




addEventHandler("onPlayerWeaponFire", root,
    function(weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
        local player = source
        local weapons = getElementData(player, "weapons") or {}
        local ammo = getElementData(player, "ammo")
        local ammoID = DATA_WEAPON[weapon] and DATA_WEAPON[weapon].ammo_id
        -- outputChatBox(" server Fired weapon: "..weapon.." AmmoID: "..tostring(ammoID), player)
        -- test = getPedTotalAmmo(player)
        -- outputChatBox("server Ammo in clip: "..tostring(test), player)
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
