-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy

local screenWidth, screenHeight = guiGetScreenSize()

function renderDrift()
    if not (localPlayer:getOccupiedVehicle()) then 
        return 
    end
    
    local vehicle = localPlayer:getOccupiedVehicle()
    if (config["BlockVehiclesType"][vehicle:getVehicleType()]) or (config["BlockVehicles"][vehicle:getModel()]) then 
        return 
    end

    if (vehicle:getOccupants()[0] == localPlayer) then
        local speed = getElementSpeed(vehicle, "km/h")
        local driftText = "DRIFT: "
        local statusText, statusColor
        if (getKeyState(config["KeyStart"])) then
            if (speed >= config["MinVelocity"] and speed <= config["MaxVelocity"]) then
                SetVehicleReduceGrip(vehicle, true)
                statusText = "Aktif"
                statusColor = tocolor(0, 255, 0, 255) -- Yeşil
            else
                SetVehicleReduceGrip(vehicle, false)
                statusText = "Deaktif"
                statusColor = tocolor(255, 0, 0, 255) -- Kırmızı
            end
        else
            SetVehicleReduceGrip(vehicle, false)
            statusText = "Deaktif"
            statusColor = tocolor(255, 0, 0, 255) -- Kırmızı
        end

        if (config["RenderText"]) then
            local driftTextWidth = dxGetTextWidth(driftText, 1, "pricedown")
            local statusTextWidth = dxGetTextWidth(statusText, 1, "pricedown")
            local textHeight = dxGetFontHeight(1, "pricedown")
            local x = (screenWidth - (driftTextWidth + statusTextWidth)) / 2
            local y = screenHeight - textHeight - 20 -- Ekranın altından 20 piksel yukarıda

            -- Siyah kontur - DRIFT:
            dxDrawText(driftText, x - 1, y - 1, x + driftTextWidth - 1, y + textHeight - 1, tocolor(0, 0, 0, 255), 1, "pricedown")
            dxDrawText(driftText, x + 1, y - 1, x + driftTextWidth + 1, y + textHeight - 1, tocolor(0, 0, 0, 255), 1, "pricedown")
            dxDrawText(driftText, x - 1, y + 1, x + driftTextWidth - 1, y + textHeight + 1, tocolor(0, 0, 0, 255), 1, "pricedown")
            dxDrawText(driftText, x + 1, y + 1, x + driftTextWidth + 1, y + textHeight + 1, tocolor(0, 0, 0, 255), 1, "pricedown")
            -- Beyaz DRIFT:
            dxDrawText(driftText, x, y, x + driftTextWidth, y + textHeight, tocolor(255, 255, 255, 255), 1, "pricedown")

            -- Siyah kontur - Durum
            dxDrawText(statusText, x + driftTextWidth - 1, y - 1, x + driftTextWidth + statusTextWidth - 1, y + textHeight - 1, tocolor(0, 0, 0, 255), 1, "pricedown")
            dxDrawText(statusText, x + driftTextWidth + 1, y - 1, x + driftTextWidth + statusTextWidth + 1, y + textHeight - 1, tocolor(0, 0, 0, 255), 1, "pricedown")
            dxDrawText(statusText, x + driftTextWidth - 1, y + 1, x + driftTextWidth + statusTextWidth - 1, y + textHeight + 1, tocolor(0, 0, 0, 255), 1, "pricedown")
            dxDrawText(statusText, x + driftTextWidth + 1, y + 1, x + driftTextWidth + statusTextWidth + 1, y + textHeight + 1, tocolor(0, 0, 0, 255), 1, "pricedown")
            -- Renkli Durum
            dxDrawText(statusText, x + driftTextWidth, y, x + driftTextWidth + statusTextWidth, y + textHeight, statusColor, 1, "pricedown")
        end
    end
end
addEventHandler("onClientRender", getRootElement(), renderDrift)

function SetVehicleReduceGrip(vehicle, state)
    if (state) then
        triggerServerEvent("mst:SetVehicleReduceGripOn", localPlayer, vehicle)
    else
        triggerServerEvent("mst:SetVehicleReduceGripOff", localPlayer, vehicle)
    end
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end


-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy