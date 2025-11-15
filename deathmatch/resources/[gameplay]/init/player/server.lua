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
    destroyElement(backpack)
end

addEventHandler("onPlayerQuit", root, cleanupPlayerBackpackOnQuit)

addEventHandler("onPlayerLogout", root, cleanupPlayerBackpackOnQuit)