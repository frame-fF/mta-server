local blip_1 = createBlip(-2625.85, 208.345, 3.98935, 6, 2, 255, 0, 0, 255, 0, 300)
local mark_1 = createMarker(295.626953125, -37.5712890625, 1000.5, "cylinder", 2, 255, 255, 0, 255)
local npc_1 = createPed(179, 295.669921875, -40.45703125, 1001.515625)
setElementInterior(mark_1, 1)
setElementDimension(mark_1, 1)
setElementInterior(npc_1, 1)
setElementDimension(npc_1, 1)

function markerHit_1(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        local player = hitElement
        triggerClientEvent(player, "weapon_shops_open", player)
    end
end

function markerLeave_1(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        local player = hitElement
        triggerClientEvent(player, "weapon_shops_close", player)
    end
end

addEventHandler("onMarkerHit", mark_1, markerHit_1)
addEventHandler("onMarkerLeave", mark_1, markerLeave_1)