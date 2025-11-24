-- Sitemiz : https://sparrow-mta.blogspot.com/
-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy    <--- 1.790 Kişi Olduk Sende Gel :)

local space = {}

for i, v in pairs(getElementsByType("player")) do
    bindKey(v, bindbase or "alt", "down", function(source)
        space[source] = true
    end)

    bindKey(v, bindbase or "alt", "up", function(source)
        space[source] = false
    end)


    bindKey(v, bindforward or "w", "down", function(source)
        if space[source] then
            if isPedDead(source) then return end
            if isPedWearingJetpack(source) then return end
            if getPedOccupiedVehicle(source) then return end
            if not isPedOnGround(source) then return end
            triggerClientEvent(root, "startAnim", root, source, 1)
        end
    end)

    bindKey(v, bindback or "s", "down", function(source)
        if space[source] then

            local rx, ry, rz = getElementRotation(source)
            if isPedDead(source) then return end
            if isPedWearingJetpack(source) then return end
            if getPedOccupiedVehicle(source) then return end
            if not isPedOnGround(source) then return end
            setElementRotation(source, rx, ry, rz)
            triggerClientEvent(root, "startAnim", root, source, 2)
        end
    end)

    bindKey(v, bindright or "d", "down", function(source)
        if space[source] then

            local rx, ry, rz = getElementRotation(source)
            if isPedDead(source) then return end
            if isPedWearingJetpack(source) then return end
            if getPedOccupiedVehicle(source) then return end
            if not isPedOnGround(source) then return end
            setElementRotation(source, rx, ry, rz)
            triggerClientEvent(root, "startAnim", root, source, 3)
        end
    end)

    bindKey(v, bindleft or "a", "down", function(source)
    if space[source] then

        local rx, ry, rz = getElementRotation(source)
        if isPedDead(source) then return end
        if isPedWearingJetpack(source) then return end
        if getPedOccupiedVehicle(source) then return end
        if not isPedOnGround(source) then return end
        setElementRotation(source, rx, ry, rz)
        triggerClientEvent(root, "startAnim", root, source, 4)
        end
    end)
end

addEventHandler( "onPlayerQuit", getRootElement(), 
function (quitType, reason, responsibleElement) 
    if space[source] then
        space[source] = nil
    end
end)

addEventHandler("onPlayerLogin", getRootElement(), function()
for i, v in pairs(getElementsByType("player")) do
    bindKey(v, bindbase or "alt", "down", function(source)
        space[source] = true
    end)

    bindKey(v, bindbase or "alt", "up", function(source)
        space[source] = false
    end)


    bindKey(v, bindforward or "w", "down", function(source)
        if space[source] then
            if isPedDead(source) then return end
            if isPedWearingJetpack(source) then return end
            if getPedOccupiedVehicle(source) then return end
            if not isPedOnGround(source) then return end
            triggerClientEvent(root, "startAnim", root, source, 1)
        end
    end)

    bindKey(v, bindback or "s", "down", function(source)
        if space[source] then

            local rx, ry, rz = getElementRotation(source)
            if isPedDead(source) then return end
            if isPedWearingJetpack(source) then return end
            if getPedOccupiedVehicle(source) then return end
            if not isPedOnGround(source) then return end
            setElementRotation(source, rx, ry, rz)
            triggerClientEvent(root, "startAnim", root, source, 2)
        end
    end)

    bindKey(v, bindright or "d", "down", function(source)
        if space[source] then

            local rx, ry, rz = getElementRotation(source)
            if isPedDead(source) then return end
            if isPedWearingJetpack(source) then return end
            if getPedOccupiedVehicle(source) then return end
            if not isPedOnGround(source) then return end
            setElementRotation(source, rx, ry, rz)
            triggerClientEvent(root, "startAnim", root, source, 3)
        end
    end)

    bindKey(v, bindleft or "a", "down", function(source)
    if space[source] then

        local rx, ry, rz = getElementRotation(source)
        if isPedDead(source) then return end
        if isPedWearingJetpack(source) then return end
        if getPedOccupiedVehicle(source) then return end
        if not isPedOnGround(source) then return end
        setElementRotation(source, rx, ry, rz)
        triggerClientEvent(root, "startAnim", root, source, 4)
        end
    end)
end
end)



-- Sitemiz : https://sparrow-mta.blogspot.com/
-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy    <--- 1.790 Kişi Olduk Sende Gel :)