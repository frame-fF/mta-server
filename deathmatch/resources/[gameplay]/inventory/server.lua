addEvent("useWeapon", true)
addEventHandler("useWeapon", root, function(weaponID)
    local player = client
    local weapons = getElementData(player, "weapons") or {}
    local ammo = getElementData(player, "ammo") or {}
    local weaponCount = weapons[tostring(weaponID)] or 0
    if weaponCount > 0 then
        local ammoID = DATA_WEAPON[weaponID].ammo_id
        local ammoCount = ammo[tostring(ammoID)] or 0
        if ammoCount > 0 then
            giveWeapon(player, weaponID, 1, true)
            setWeaponAmmo(player, weaponID, ammoCount)
        else
            outputChatBox("No ammo for this weapon!", player)
        end
    else
        outputChatBox("You don't have this weapon!", player)
    end
end)

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