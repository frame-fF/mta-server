function onPlayerWasted()
    local thePlayer = source
    -- รอ 3 วินาที แล้วสปอนผู้เล่นที่ San Fierro
    setTimer(function()
        spawnPlayer(thePlayer, -1969.4, 137.85, 27.69, 0, 0, 0, 0)
        fadeCamera(thePlayer, true)
        setCameraTarget(thePlayer, thePlayer)
    end, 3000, 1)
end

addEventHandler("onPlayerWasted", root, onPlayerWasted)
