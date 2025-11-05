function getPosition(source)
    x, y, z = getElementPosition(source)
    rx, ry, rz = getElementRotation(source)
    local interior = getElementInterior(source)
    local dimension = getElementDimension(source)
    outputChatBox("Posicion: " .. x .. ", " .. y .. ", " .. z, source, 255, 255, 0)
    outputChatBox("Rotacion: " .. rx .. ", " .. ry .. ", " .. rz, source, 255, 255, 0)
    outputChatBox("Interior ID: " .. interior, source, 255, 255, 0)
    outputChatBox("Dimension ID: " .. dimension, source, 255, 255, 0)
end

addCommandHandler("get_pos", getPosition)

addEventHandler("onPlayerInteriorWarped", root,
    function(warpedInterior)
        local interiorName = exports.interiors:getInteriorName(warpedInterior)
        local interior = getElementInterior(source)
        local dimension = getElementDimension(source)
        outputChatBox("Has entrado en el interior: " .. interiorName, source, 0, 255, 0)
        outputChatBox("Interior ID: " .. interior, source, 255, 255, 0)
        outputChatBox("Dimension ID: " .. dimension, source, 255, 255, 0)
    end
)