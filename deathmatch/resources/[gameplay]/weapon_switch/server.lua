-- ID อาวุธ 
local AK47_WEAPON_ID = 30
local M4_WEAPON_ID = 31

local RIFLE_WEAPON_ID = 33
local SNIPER_WEAPON_ID = 34

-- ID ของ Object ที่จะใช้แสดง 
local AK47_OBJECT_ID = 355
local M4_OBJECT_ID = 356

local RIFLE_OBJECT_ID = 357
local SNIPER_OBJECT_ID = 358

-- ตำแหน่งการติด
local M4_ATTACH_POS = { 3, -0.19, -0.31, -0.1, 0, 270, -90 }

local SNIPER_ATTACH_POS = { 3, 0.19, -0.31, -0.1, 0, 270, -90 }

-- มิติพิเศษสำหรับเก็บอาวุธที่ไม่ต้องการให้เห็น
local LIMBO_DIMENSION = 65535

local function addWeaponInblack(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end

    -- ตรวจสอบและลบ object เก่า (ถ้ามี)
    local oldM4 = getElementData(player, "backWeapon:m4")
    if isElement(oldM4) then
        destroyElement(oldM4)
    end
    local oldSNIPER = getElementData(player, "backWeapon:sniper")
    if isElement(oldSNIPER) then
        destroyElement(oldSNIPER)
    end

    -- สร้าง object ใหม่
    local x, y, z = getElementPosition(player)
    local m4 = createObject(M4_OBJECT_ID, x, y, z)
    local sniper = createObject(SNIPER_OBJECT_ID, x, y, z)
    
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)

    setElementInterior(m4, LIMBO_DIMENSION)
    setElementDimension(m4, LIMBO_DIMENSION)
    setElementInterior(sniper, LIMBO_DIMENSION)
    setElementDimension(sniper, LIMBO_DIMENSION)

    -- เก็บ object ไว้ใน element data
    setElementData(player, "backWeapon:m4", m4, true)
    setElementData(player, "backWeapon:sniper", sniper, true)

    local currentWeapon = getPedWeapon(player)

    for slot = 0, 12 do
        local weaponInSlot = getPedWeapon(player, slot)
        if weaponInSlot == SNIPER_WEAPON_ID and currentWeapon ~= SNIPER_WEAPON_ID then
            exports.bone_attach:attachElementToBone(sniper, player, unpack(SNIPER_ATTACH_POS))
            setElementInterior(sniper, interior)
            setElementDimension(sniper, dimension)
        elseif weaponInSlot == M4_WEAPON_ID and currentWeapon ~= M4_WEAPON_ID then
            exports.bone_attach:attachElementToBone(m4, player, unpack(M4_ATTACH_POS))
            setElementInterior(m4, interior)
            setElementDimension(m4, dimension)
        end
    end
end

addEventHandler("onPlayerSpawn", root, function()
    setTimer(addWeaponInblack, 500, 1, source)
end)

addEventHandler("onResourceStart", root, function()
    for _, player in ipairs(getElementsByType("player")) do
        addWeaponInblack(player)
    end
end)

addEventHandler("onPlayerInteriorWarped", root, function(warpedInterior)
    addWeaponInblack(source)
end)


local function cleanupPlayerWeaponsOnQuit()
    local m4 = getElementData(source, "backWeapon:m4")
    if isElement(m4) then
        destroyElement(m4)
    end
    local sniper = getElementData(source, "backWeapon:sniper")
    if isElement(sniper) then
        destroyElement(sniper)
    end
end

addEventHandler("onPlayerQuit", root, cleanupPlayerWeaponsOnQuit)

addEventHandler("onPlayerLogout", root, cleanupPlayerWeaponsOnQuit)

-- --- [แก้ไขทั้งหมด] ฟังก์ชันสลับอาวุธ (ใช้การย้ายมิติ) ---

function weaponSwitchBack(previousWeaponID, currentWeaponID)
    local player = source
    if not isElement(player) then return end

    -- ดึง object ที่เราเก็บไว้
    local m4Object = getElementData(player, "backWeapon:m4")
    local sniperObject = getElementData(player, "backWeapon:sniper")

    -- ดึงมิติและ interior ปัจจุบันของผู้เล่น
    local playerDimension = getElementDimension(player)
    local playerInterior = getElementInterior(player)

    -- --- Logic ของ sniper ---
    
    -- ถ้าอาวุธใหม่คือ sniper (กำลังจะใช้) -> "ซ่อน" โดยย้ายมิติ
    if currentWeaponID == SNIPER_WEAPON_ID and isElement(sniperObject) then
        -- [แก้ไข] ย้ายไปมิติอื่นเพื่อซ่อน
        setElementDimension(sniperObject, LIMBO_DIMENSION)
    end
    -- ถ้าอาวุธก่อนหน้าคือ sniper (เพิ่งใช้เสร็จ) -> "แสดง" โดยย้ายกลับมาและ Attach
    if previousWeaponID == SNIPER_WEAPON_ID and isElement(sniperObject) then
        -- [แก้ไข] ย้าย object กลับมาที่มิติ/interior ของผู้เล่นก่อน
        setElementDimension(sniperObject, playerDimension)
        setElementInterior(sniperObject, playerInterior)
        -- แล้วค่อย attach
        exports.bone_attach:attachElementToBone(sniperObject, player, unpack(SNIPER_ATTACH_POS))
    end

    -- --- Logic ของ M4 ---
    
    -- ถ้าอาวุธใหม่คือ M4 (กำลังจะใช้) -> "ซ่อน" โดยย้ายมิติ
    if currentWeaponID == M4_WEAPON_ID and isElement(m4Object) then
        -- [แก้ไข] ย้ายไปมิติอื่นเพื่อซ่อน
        setElementDimension(m4Object, LIMBO_DIMENSION)
    end
    -- ถ้าอาวุธก่อนหน้าคือ M4 (เพิ่งใช้เสร็จ) -> "แสดง" โดยย้ายกลับมาและ Attach
    if previousWeaponID == M4_WEAPON_ID and isElement(m4Object) then
        -- [แก้ไข] ย้าย object กลับมาที่มิติ/interior ของผู้เล่นก่อน
        setElementDimension(m4Object, playerDimension)
        setElementInterior(m4Object, playerInterior)
        -- แล้วค่อย attach
        exports.bone_attach:attachElementToBone(m4Object, player, unpack(M4_ATTACH_POS))
    end
end

addEventHandler("onPlayerWeaponSwitch", getRootElement(), weaponSwitchBack)