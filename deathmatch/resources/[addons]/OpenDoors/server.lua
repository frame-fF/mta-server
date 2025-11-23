---------------------------------------------------------
--- Sitemiz : https://sparrow-mta.blogspot.com/

--- Facebook : https://facebook.com/sparrowgta/
--- İnstagram : https://instagram.com/sparrowmta/
--- YouTube : https://www.youtube.com/@TurkishSparroW/

--- Discord : https://discord.gg/DzgEcvy
---------------------------------------------------------

local open_key1 = "num_8"
local open_key2 = "num_2"
local open_key3 = "num_4"
local open_key4 = "num_6"
local open_key5 = "num_1"
local open_key6 = "num_3"
local open_key7 = "num_0"

addEventHandler("onPlayerJoin",root,
function ()
    bindKey(source, open_key1, "down", hood)
    bindKey(source, open_key2, "down", trunk)
    bindKey(source, open_key3, "down", LeftPered)
    bindKey(source, open_key4, "down", RightPered)
    bindKey(source, open_key5, "down", LeftZad)
    bindKey(source, open_key6, "down", RightZad)
    bindKey(source, open_key7, "down", all)
end)

addEventHandler("onResourceStart",resourceRoot,
function ()
    for index, player in ipairs(getElementsByType("player")) do
        bindKey(player, open_key1, "down", hood)
        bindKey(player, open_key2, "down", trunk)
        bindKey(player, open_key3, "down", LeftPered)
        bindKey(player, open_key4, "down", RightPered)
        bindKey(player, open_key5, "down", LeftZad)
        bindKey(player, open_key6, "down", RightZad)
        bindKey(player, open_key7, "down", all)
    end
end)

function hood(thePlayer)
    local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        if getVehicleDoorOpenRatio ( theVehicle, 0 ) == 0 then
            setVehicleDoorOpenRatio(theVehicle, 0, 1, 2500)
        else
            setVehicleDoorOpenRatio(theVehicle, 0, 0, 1500)
        end
    else
        outputChatBox ( "Bunu yapabilmeniz için araçta olmalısınız.", thePlayer, 255, 0, 0, true )
    end
end

function trunk(thePlayer)
    local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        if getVehicleDoorOpenRatio ( theVehicle, 1 ) == 0 then
            setVehicleDoorOpenRatio(theVehicle, 1, 1, 2500)
        else
            setVehicleDoorOpenRatio(theVehicle, 1, 0, 1500)
        end
    else
        outputChatBox ( "Bunu yapabilmeniz için araçta olmalısınız.", thePlayer, 255, 0, 0, true )
    end
end

function LeftPered(thePlayer)
    local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        if getVehicleDoorOpenRatio ( theVehicle, 2 ) == 0 then
            setVehicleDoorOpenRatio(theVehicle, 2, 1, 2500)
        else
            setVehicleDoorOpenRatio(theVehicle, 2, 0, 2500)
        end
    else
        outputChatBox ( "Bunu yapabilmeniz için araçta olmalısınız.", thePlayer, 255, 0, 0, true )
    end
end

function RightPered(thePlayer)
    local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        if getVehicleDoorOpenRatio ( theVehicle, 3 ) == 0 then
            setVehicleDoorOpenRatio(theVehicle, 3, 1, 2500)
        else
            setVehicleDoorOpenRatio(theVehicle, 3, 0, 2500)
        end
    else
        outputChatBox ( "Bunu yapabilmeniz için araçta olmalısınız.", thePlayer, 255, 0, 0, true )
    end
end

function LeftZad(thePlayer)
    local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        if getVehicleDoorOpenRatio ( theVehicle, 4 ) == 0 then
            setVehicleDoorOpenRatio(theVehicle, 4, 1, 2500)
        else
            setVehicleDoorOpenRatio(theVehicle, 4, 0, 2500)
        end
    else
        outputChatBox ( "Bunu yapabilmeniz için araçta olmalısınız.", thePlayer, 255, 0, 0, true )
    end
end

function RightZad(thePlayer)
    local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        if getVehicleDoorOpenRatio ( theVehicle, 5 ) == 0 then
            setVehicleDoorOpenRatio(theVehicle, 5, 1, 2500)
        else
            setVehicleDoorOpenRatio(theVehicle, 5, 0, 2500)
        end
    else
        outputChatBox ( "Bunu yapabilmeniz için araçta olmalısınız.", thePlayer, 255, 0, 0, true )
    end
end

function all(thePlayer)
    local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        if getVehicleDoorOpenRatio ( theVehicle, 0 ) == 0 then
            setVehicleDoorOpenRatio(theVehicle, 0, 1, 2500)
            setVehicleDoorOpenRatio(theVehicle, 1, 1, 2500)
            setVehicleDoorOpenRatio(theVehicle, 2, 1, 2500)
            setVehicleDoorOpenRatio(theVehicle, 3, 1, 2500)
            setVehicleDoorOpenRatio(theVehicle, 4, 1, 2500)
            setVehicleDoorOpenRatio(theVehicle, 5, 1, 2500)
        else
            setVehicleDoorOpenRatio(theVehicle, 0, 0, 1500)
            setVehicleDoorOpenRatio(theVehicle, 1, 0, 1500)
            setVehicleDoorOpenRatio(theVehicle, 2, 0, 1500)
            setVehicleDoorOpenRatio(theVehicle, 3, 0, 1500)
            setVehicleDoorOpenRatio(theVehicle, 4, 0, 1500)
            setVehicleDoorOpenRatio(theVehicle, 5, 0, 1500)
        end
    else
        outputChatBox ( "Bunu yapabilmeniz için araçta olmalısınız.", thePlayer, 255, 0, 0, true )
    end
end

---------------------------------------------------------
--- Sitemiz : https://sparrow-mta.blogspot.com/

--- Facebook : https://facebook.com/sparrowgta/
--- İnstagram : https://instagram.com/sparrowmta/
--- YouTube : https://www.youtube.com/@TurkishSparroW/

--- Discord : https://discord.gg/DzgEcvy
---------------------------------------------------------