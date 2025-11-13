local function addWeaponInblack(player)

    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end

    local x, y, z = getElementPosition(player)
    local m4 = createObject(356, x, y, z)
    local svd = createObject(358, x, y, z)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)

    setElementInterior(m4, interior)
    setElementDimension(m4, dimension)

    setElementInterior(svd, interior)
    setElementDimension(svd, dimension)

    if isElement(m4) then
        exports.bone_attach:attachElementToBone(m4, player,3, -0.19, -0.31, -0.1, 0, 270, -90)
    end

    if isElement(svd) then
        exports.bone_attach:attachElementToBone(svd, player, 3, 0.19, -0.31, -0.1, 0, 270, -90)
    end

end


addEventHandler("onPlayerJoin", root, function()
    addWeaponInblack(source)
end)


addEventHandler("onPlayerSpawn", root, function()
    addWeaponInblack(source)
end)

addEventHandler("onResourceStart", root, function()
    -- วนลูปผู้เล่นทั้งหมดที่อยู่ในเกม
    for _, player in ipairs(getElementsByType("player")) do
        addWeaponInblack(player)
    end
end)

addEventHandler("onPlayerInteriorWarped", root,
    function(warpedInterior)
        addWeaponInblack(source)
    end
)