--[[
    Script: Back Weapon System (Refactored for Scalability)
    Author: MTA:SA (via Google)
    Purpose: Shows non-equipped primary weapons on a player's back.
             Uses a configuration table for easy addition of new weapons.
]]

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

local AK47_ATTACH_POS = { 3, -0.19, -0.31, -0.1, 0, 270, -90 }
local M4_ATTACH_POS = { 3, -0.19, -0.31, -0.1, 0, 270, -90 }

local RIFLE_ATTACH_POS = { 3, 0.19, -0.31, -0.1, 0, 270, -90 }
local SNIPER_ATTACH_POS = { 3, 0.19, -0.31, -0.1, 0, 270, -90 }



-- มิติพิเศษสำหรับเก็บอาวุธที่ไม่ต้องการให้เห็น
local LIMBO_DIMENSION = 65535


local backWeaponsConfig = {
    [AK47_WEAPON_ID] = {
        objectID = AK47_OBJECT_ID,
        attachPos = AK47_ATTACH_POS
    },
    [M4_WEAPON_ID] = {
        objectID = M4_OBJECT_ID,
        attachPos = M4_ATTACH_POS
    },
    [RIFLE_WEAPON_ID] = {
        objectID = RIFLE_OBJECT_ID,
        attachPos = RIFLE_ATTACH_POS
    },
    [SNIPER_WEAPON_ID] = {
        objectID = SNIPER_OBJECT_ID,
        attachPos = SNIPER_ATTACH_POS
    },
}

local function setupBackWeapons(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end

    local playerInterior = getElementInterior(player)
    local playerDimension = getElementDimension(player)
    local x, y, z = getElementPosition(player)
    local currentWeapon = getPedWeapon(player)

    for weaponID, config in pairs(backWeaponsConfig) do
        local dataKey = "backWeapon:" .. weaponID -- สร้าง key ที่ไม่ซ้ำกัน เช่น "backWeapon:31"
        
        -- ตรวจสอบและลบ object เก่า (ถ้ามี)
        local oldObject = getElementData(player, dataKey)
        if isElement(oldObject) then
            destroyElement(oldObject)
        end

        -- สร้าง object ใหม่
        local newObject = createObject(config.objectID, x, y, z)
        
        -- ซ่อนในมิติพิเศษ
        setElementInterior(newObject, LIMBO_DIMENSION)
        setElementDimension(newObject, LIMBO_DIMENSION)

        setElementData(player, dataKey, newObject, true)
    end

    -- 2. วนลูปเช็คอาวุธในตัวผู้เล่นเพื่อ attach
    -- (แยก loop เพื่อให้แน่ใจว่า object ทั้งหมดถูกสร้างและเก็บใน data แล้ว)
    for slot = 0, 12 do
        local weaponInSlot = getPedWeapon(player, slot)
        local config = backWeaponsConfig[weaponInSlot] -- ดึง config ของอาวุธใน slot นี้

        -- ถ้าอาวุธนี้มีใน config ของเรา และ ไม่ได้ถืออยู่
        if config and weaponInSlot ~= currentWeapon then
            local dataKey = "backWeapon:" .. weaponInSlot
            local object = getElementData(player, dataKey)
            
            if isElement(object) then
                exports.bone_attach:attachElementToBone(object, player, unpack(config.attachPos))
                setElementInterior(object, playerInterior)
                setElementDimension(object, playerDimension)
            end
        end
    end
end

-- ฟังก์ชันสำหรับลบ object ทั้งหมดเมื่อผู้เล่นออก
local function cleanupPlayerWeaponsOnQuit()
    local player = source
    if not isElement(player) then return end

    -- วนลูปใน config เพื่อลบ object ทั้งหมด
    for weaponID, _ in pairs(backWeaponsConfig) do
        local dataKey = "backWeapon:" .. weaponID
        local object = getElementData(player, dataKey)
        if isElement(object) then
            destroyElement(object)
        end
    end
end

-- ฟังก์ชันทั่วไปสำหรับจัดการการสลับอาวุธ
function handleWeaponSwitch(previousWeaponID, currentWeaponID)
    local player = source
    if not isElement(player) then return end

    local playerDimension = getElementDimension(player)
    local playerInterior = getElementInterior(player)

    -- 1. ตรวจสอบอาวุธ "ก่อนหน้า" (ที่เพิ่งสลับออก)
    local prevConfig = backWeaponsConfig[previousWeaponID]
    if prevConfig then
        -- ถ้าอาวุธก่อนหน้าอยู่ใน config (เช่น M4, Sniper) -> "แสดง" object กลับมา
        local dataKey = "backWeapon:" .. previousWeaponID
        local object = getElementData(player, dataKey)
        
        if isElement(object) then
            -- ย้าย object กลับมามิติของผู้เล่น
            setElementDimension(object, playerDimension)
            setElementInterior(object, playerInterior)
            -- Attach เข้ากับกระดูก
            exports.bone_attach:attachElementToBone(object, player, unpack(prevConfig.attachPos))
        end
    end

    -- 2. ตรวจสอบอาวุธ "ปัจจุบัน" (ที่กำลังจะใช้)
    local currentConfig = backWeaponsConfig[currentWeaponID]
    if currentConfig then
        -- ถ้าอาวุธปัจจุบันอยู่ใน config -> "ซ่อน" object โดยย้ายไปมิติอื่น
        local dataKey = "backWeapon:" .. currentWeaponID
        local object = getElementData(player, dataKey)
        
        if isElement(object) then
            setElementDimension(object, LIMBO_DIMENSION)
            setElementInterior(object, LIMBO_DIMENSION) -- ตั้งค่าเผื่อไว้
        end
    end
end

--- === Event Handlers ===
--- 
addEvent("onSetupBackWeapons", true)
addEventHandler("onSetupBackWeapons", root, setupBackWeapons)

addEventHandler("onPlayerSpawn", root, function()
    setTimer(setupBackWeapons, 500, 1, source)
end)

addEventHandler("onResourceStart", root, function()
    for _, player in ipairs(getElementsByType("player")) do
        setupBackWeapons(player)
    end
end)

addEventHandler("onPlayerInteriorWarped", root, function(warpedInterior)
    setupBackWeapons(source)
end)

addEventHandler("onPlayerQuit", root, cleanupPlayerWeaponsOnQuit)
addEventHandler("onPlayerLogout", root, cleanupPlayerWeaponsOnQuit)

addEventHandler("onPlayerWeaponSwitch", getRootElement(), handleWeaponSwitch)