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


local function removeItem(data)
    local player = client
    if data.type == "weapon" then
        takeWeapon( player, data.id )
        triggerClientEvent(player, "onUseItemResponse", player, true)
    elseif data.type == "ammo" then

    end
end


addEvent("remove_item", true)
addEventHandler("remove_item", root, removeItem)


local function dropItem(data)
    local player = client
    if data.type == "weapon" then
        
    elseif data.type == "ammo" then

    end
end


addEvent("drop_item", true)
addEventHandler("drop_item", root, dropItem)



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
