local function addBackpack(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end

    local x, y, z = getElementPosition(player)
    local backpack = createObject(1318, x, y, z)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)
    setElementInterior(backpack, interior)
    setElementDimension(backpack, dimension)

    if isElement(backpack) then
        attachElementToBone(backpack, player, 3, 0, -0.225, 0.05, 90, 0, 0)
    end
end

addEventHandler("onPlayerJoin", root, function()
    addBackpack(source)
end)

addEventHandler("onResourceStart", root, function()
    -- วนลูปผู้เล่นทั้งหมดที่อยู่ในเกม
    for _, player in ipairs(getElementsByType("player")) do
        addBackpack(source)
    end
end)

addEventHandler("onPlayerInteriorWarped", root,
    function(warpedInterior)
        addBackpack(source)
    end
)