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


local function dropItem(data, quantity)
    local player = client
    quantity = tonumber(quantity)

    -- ตรวจสอบ quantity
    if not quantity or quantity <= 0 or quantity ~= math.floor(quantity) then
        triggerClientEvent(player, "onDropItemResponse", player, false, "Invalid quantity.")
        return
    end

    local itemIDStr = tostring(data.id)
    local currentWeapon = getPedWeapon(player)
    local weaponTaken = false -- ตัวแปรเช็คว่าถอดปืนไปหรือยัง

    if data.type == "weapon" then
        local weapons = getElementData(player, "weapons") or {}
        local currentCount = weapons[itemIDStr] or 0

        if quantity > currentCount then
            triggerClientEvent(player, "onDropItemResponse", player, false, "You don't have that many.")
            return
        end

        local newCount = currentCount - quantity
        weapons[itemIDStr] = newCount > 0 and newCount or nil -- ถ้าเหลือ 0 ให้ลบออกจาก table
        setElementData(player, "weapons", weapons)

        -- ตรวจสอบ: ถ้า drop จนหมด และกำลังถือปืนนี้อยู่ ให้ถอดออก
        if newCount == 0 then
            takeWeapon(player, data.id)
            weaponTaken = true
        end

    elseif data.type == "ammo" then
        local ammo = getElementData(player, "ammo") or {}
        local currentCount = ammo[itemIDStr] or 0

        if quantity > currentCount then
            triggerClientEvent(player, "onDropItemResponse", player, false, "You don't have that much ammo.")
            return
        end

        local newCount = currentCount - quantity
        ammo[itemIDStr] = newCount > 0 and newCount or nil -- ถ้าเหลือ 0 ให้ลบออกจาก table
        setElementData(player, "ammo", ammo)

        -- ตรวจสอบ: ถ้า drop กระสุนจนหมด และกระสุนนี้เป็นของปืนที่ถืออยู่ ให้ถอดปืน
        for slot = 0, 12 do
            local weaponInSlot = getPedWeapon(player, slot)
            
            -- ถ้ามีปืนในช่องนี้
            if weaponInSlot > 0 then
                -- (สันนิษฐานว่า DATA_WEAPON โหลดอยู่บน server)
                local ammoID_for_weapon = DATA_WEAPON[weaponInSlot] and DATA_WEAPON[weaponInSlot].ammo_id
                
                -- ถ้าปืนในช่องนี้ (weaponInSlot) ใช้กระสุนที่กำลัง drop (data.id)
                if ammoID_for_weapon and ammoID_for_weapon == data.id then
                    if newCount == 0 then
                        -- ถ้ากระสุนหมด, ถอดปืน (ไม่ว่ากระบอกไหนก็ตาม)
                        takeWeapon(player, weaponInSlot)
                    else
                        -- ถ้ากระสุนยังเหลือ, อัปเดตจำนวนกระสุนในปืนนั้นๆ
                        setWeaponAmmo(player, weaponInSlot, newCount)
                    end
                end
            end
        end
    else
        triggerClientEvent(player, "onDropItemResponse", player, false, "Invalid item type.")
        return
    end

    -- สร้างกล่องของขวัญ (Object)
    local x, y, z = getElementPosition(player)
    local rx, ry, rz = getElementRotation(player)
    
    -- วางไว้ข้างหน้าผู้เล่น 1.5 หน่วย
    local dropX = x + (math.cos(math.rad(rz - 90)) * 1.5)
    local dropY = y + (math.sin(math.rad(rz - 90)) * 1.5)
    local dropZ = z - 0.9 -- ลดระดับ z ให้อยู่บนพื้น
    
    -- Model 1271 คือกล่องของขวัญ
    local giftBox = createObject(1271, dropX, dropY, dropZ, 0, 0, rz)
    setElementDimension(giftBox, getElementDimension(player))
    setElementInterior(giftBox, getElementInterior(player))

    -- เก็บข้อมูลไอเทมไว้ใน Object
    setElementData(giftBox, "isGiftBox", true)
    setElementData(giftBox, "droppedItem", data) -- 'data' มี type และ id
    setElementData(giftBox, "droppedQuantity", quantity)

    -- สร้าง ColShape (พื้นที่) สำหรับเก็บ
    local col = createColSphere(dropX, dropY, dropZ, 2.0) -- รัศมี 2 เมตร
    setElementDimension(col, getElementDimension(player))
    setElementInterior(col, getElementInterior(player))

    setElementData(col, "parentBox", giftBox) -- เชื่อม ColShape กับ กล่อง
    addEventHandler("onColShapeHit", col, onGiftBoxHit) -- เพิ่มอีเวนต์เมื่อเดินชน

    -- ตั้งเวลาให้ไอเทมหายไป (เช่น 5 นาที = 300000 ms)
    setTimer(function()
        if isElement(giftBox) then destroyElement(giftBox) end
        if isElement(col) then destroyElement(col) end
    end, 300000, 1)

    -- แจ้ง Client ว่าสำเร็จ
    triggerClientEvent(player, "onDropItemResponse", player, true)
end

-- [[ NEW: ฟังก์ชันเมื่อมีคนเดินชนกล่อง ]]
function onGiftBoxHit(hitPlayer, matchingDimension)
    -- เช็คว่าเป็นผู้เล่นหรือไม่
    if not hitPlayer or getElementType(hitPlayer) ~= "player" then return end
    
    -- เช็คว่าผู้เล่นตายหรือไม่
    if isPedDead(hitPlayer) then return end

    local col = source
    local giftBox = getElementData(col, "parentBox")

    -- เช็คว่ากล่องยังอยู่ และเป็นกล่องของขวัญจริง
    if not isElement(giftBox) or not getElementData(giftBox, "isGiftBox") then
        if isElement(col) then destroyElement(col) end -- ลบ ColShape ที่ค้าง
        return
    end

    local itemData = getElementData(giftBox, "droppedItem")
    local itemQty = getElementData(giftBox, "droppedQuantity")

    if not itemData or not itemQty then return end -- ข้อมูลหาย

    local itemName = ""

    -- เพิ่มไอเทมให้ผู้เล่น
    if itemData.type == "weapon" then
        local weapons = getElementData(hitPlayer, "weapons") or {}
        local itemIDStr = tostring(itemData.id)
        weapons[itemIDStr] = (weapons[itemIDStr] or 0) + itemQty
        setElementData(hitPlayer, "weapons", weapons)
        itemName = DATA_WEAPON[itemData.id].name

    elseif itemData.type == "ammo" then
        local ammo = getElementData(hitPlayer, "ammo") or {}
        local itemIDStr = tostring(itemData.id)
        ammo[itemIDStr] = (ammo[itemIDStr] or 0) + itemQty
        setElementData(hitPlayer, "ammo", ammo)
        itemName = DATA_AMMO[itemData.id].name
    end

    -- แจ้งเตือนผู้เล่นที่เก็บ
    outputChatBox("You picked up " .. itemQty .. "x " .. itemName .. ".", hitPlayer, 0, 255, 100)

    -- ลบกล่องและ ColShape
    destroyElement(giftBox)
    destroyElement(col) -- การลบ col จะลบ event handler ไปด้วย
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
