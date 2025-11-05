local buildingEntranceX, buildingEntranceY, buildingEntranceZ = -2034.8935546875, 148.5478515625, 28.8359375 -- Exterior entrance coordinates
local interiorSpawnX, interiorSpawnY, interiorSpawnZ = -27.31, -31.38, 1002.55 -- Interior spawn coordinates
local interiorDimension = 4 -- A unique dimension for the interior

-- Create a colshape at the entrance
local entranceColshape = createColSphere(buildingEntranceX, buildingEntranceY, buildingEntranceZ, 2)

-- Handle player entering the colshape
addEventHandler("onColShapeHit", entranceColshape, function(player)
    if getElementType(player) == "player" then
        -- Teleport player to interior
        setElementPosition(player, interiorSpawnX, interiorSpawnY, interiorSpawnZ)
        setElementInterior(player, 4) -- Set interior ID if necessary
        setElementDimension(player, interiorDimension)
    end
end)