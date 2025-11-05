function getPosition(source)
    x, y, z = getElementPosition(source)
    rx, ry, rz = getElementRotation(source)
    local interior = getElementInterior(source)
    local dimension = getElementDimension(source)
    outputChatBox("Posicion: " .. x .. ", " .. y .. ", " .. z, source, 255, 255, 0)
    outputChatBox("Rotacion: " .. rx .. ", " .. ry .. ", " .. rz, source, 255, 255, 0)
    outputChatBox("Interior: " .. interior, source, 255, 255, 0)
    outputChatBox("Dimension: " .. dimension, source, 255, 255, 0)
end

addCommandHandler("get_pos", getPosition)

