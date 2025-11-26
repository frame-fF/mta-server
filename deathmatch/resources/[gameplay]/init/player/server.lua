local function addBackpack(player)
    if res and res ~= getThisResource() then return end

    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end

    local oldBackpack = getElementData(player, "backpack")
    if isElement(oldBackpack) then
        destroyElement(oldBackpack)
    end

    local x, y, z = getElementPosition(player)
    local backpack = createObject(1318, x, y, z)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)
    setElementInterior(backpack, interior)
    setElementDimension(backpack, dimension)

    setElementData(player, "backpack", backpack, true)

    if isElement(backpack) then
        exports.bone_attach:attachElementToBone(backpack, player, 3, 0, -0.225, 0.05, 90, 0, 0)
    end
end

-- Event Handlers

addEventHandler("onPlayerSpawn", root, function()
    addBackpack(source)
end)

addEventHandler("onResourceStart", root, function()
    -- วนลูปผู้เล่นทั้งหมดที่อยู่ในเกม
    for _, player in ipairs(getElementsByType("player")) do
        addBackpack(player)
    end
end)

addEventHandler("onPlayerInteriorWarped", root,
    function(warpedInterior)
        addBackpack(source)
    end
)

local function cleanupPlayerBackpackOnQuit()
    local backpack = getElementData(source, "backpack")
    -- ตรวจสอบว่ามีค่า backpack และค่านั้นเป็น Element จริงๆ หรือไม่
    if backpack and isElement(backpack) then
        destroyElement(backpack)
    end
end

addEventHandler("onPlayerQuit", root, cleanupPlayerBackpackOnQuit)

addEventHandler("onPlayerLogout", root, cleanupPlayerBackpackOnQuit)

local handsUp = false
local sitting = false

function funcBindSit(player, key, keyState)
    if sitting then
        setPedAnimation(player, false)
        sitting = false
    else
        if isPedInVehicle(player) then return end
        setPedAnimation(player, "BEACH", "ParkSit_M_loop", -1, false)
        sitting = true
    end
end

function funcBindHandsup(player, key, keyState)
    if handsUp then
        setPedAnimation(player, false)
        handsUp = false
    else
        if isPedInVehicle(player) then return end
        setPedAnimation(player, "SHOP", "SHP_Rob_HandsUp", -1, false)
        handsUp = true
    end
end

function bindTheKeys()
    bindKey(source, ".", "down", funcBindHandsup)
    bindKey(source, "-", "down", funcBindSit)
end

addEventHandler("onPlayerLogin", root, bindTheKeys)
