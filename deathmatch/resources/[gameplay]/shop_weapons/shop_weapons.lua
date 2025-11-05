a = createBlip(-2625.85, 208.345, 3.98935, 6, 2, 255, 0, 0, 255, 0, 300)
b = createMarker(295.626953125, -37.5712890625, 1001.515625, "cylinder", 2, 255, 255, 0, 255)
setElementInterior(b, 1)
setElementDimension(b, 1)


function activeMarkers(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        local player = hitElement
        setMarkerColor(source, 0, 255, 0, 255)
    end
end

function disabledMarkers(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        local player = hitElement
        setMarkerColor(source, 255, 255, 0, 255)
    end
end

addEventHandler("onMarkerHit", b, activeMarkers)
addEventHandler("onMarkerLeave", b, disabledMarkers)



-- Marker1 = createMarker(-2034.8935546875, 148.5478515625, 28.8359375 + 1.5, "arrow", 2, 255, 255, 0, 255)
-- pickup1 = createPickup(291.8271484375, -83.0009765625, 1001.515625, 0, 10, 5000)

-- local x,y,z,int,dim = 285.8000, -84.5470, 1001.5390, 4, 1
-- setElementInterior(pickup1, int)
-- setElementDimension(pickup1, dim )

-- function activeMarkers(hitElement, matchingDimension)
--     if getElementType(hitElement) == "player" and matchingDimension then
--         local player = hitElement
--         setElementPosition(player, 285.8000, -84.5470, 1001.5390)
--         setElementInterior(player, 4)
--         setElementDimension(player, 1)
--     end
-- end

-- addEventHandler("onMarkerHit", Marker1, activeMarkers)


-- local ExitMarker = createMarker(285.8466796875, -86.7822265625, 1001.5228881836 + 1.5, "arrow", 2, 255, 0, 0, 255)
-- setElementInterior(ExitMarker, 4)
-- setElementDimension(ExitMarker, 1)

-- function exitInterior(hitElement, matchingDimension)
--     if getElementType(hitElement) == "player" and matchingDimension then
--         local player = hitElement
--         -- ส่งผู้เล่นกลับไปยังตำแหน่งเริ่มต้น
--         setElementPosition(player, -2027.3447265625, 148.8935546875, 28.8359375)
--         setElementInterior(player, 0)
--         setElementDimension(player, 0)
--     end
-- end

-- addEventHandler("onMarkerHit", ExitMarker, exitInterior)