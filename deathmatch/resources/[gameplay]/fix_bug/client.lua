-- รายชื่อ ID อาวุธที่มีปัญหา (34 = Sniper Rifle, 43 = Camera ฯลฯ สามารถเพิ่มได้)
local hiddenWeapons = {
    [34] = true, -- Sniper Rifle
    [43] = true  -- Camera (เผื่อถ่ายรูปแล้วบัง)
}

addEventHandler("onClientPreRender", root, function()
    local player = localPlayer
    local backpack = getElementData(player, "backpack")

    -- ถ้าไม่มีกระเป๋า ไม่ต้องทำอะไร
    if not isElement(backpack) then return end

    local weapon = getPedWeapon(player)
    
    -- ตรวจสอบสถานะ: ถืออาวุธที่กำหนด AND กำลังกดเล็ง
    if hiddenWeapons[weapon] and getPedControlState(player, "aim_weapon") then
        -- ซ่อนกระเป๋า (ปรับ Alpha เป็น 0)
        if getElementAlpha(backpack) > 0 then
            setElementAlpha(backpack, 0)
        end

        for slot = 0, 12 do
            local weaponInSlot = getPedWeapon(player, slot)
            if weaponInSlot ~= 0 then
                local weaponObjectKey = "backWeapon:" .. weaponInSlot
                local weaponObject = getElementData(player, weaponObjectKey)
                if isElement(weaponObject) then
                    setElementAlpha(weaponObject, 0)
                end
            end
        end
    else
        -- แสดงกระเป๋าตามปกติ (ปรับ Alpha เป็น 255)
        if getElementAlpha(backpack) ~= 255 then
            setElementAlpha(backpack, 255)
        end

        for slot = 0, 12 do
            local weaponInSlot = getPedWeapon(player, slot)
            if weaponInSlot ~= 0 then
                local weaponObjectKey = "backWeapon:" .. weaponInSlot
                local weaponObject = getElementData(player, weaponObjectKey)
                if isElement(weaponObject) then
                    setElementAlpha(weaponObject, 255)
                end
            end
        end
    end
end)