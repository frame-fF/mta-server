local function onPlayerLogin()
    outputChatBox("Welcome back to the server, " .. getPlayerName(source) .. "!")
    -- สปอนผู้เล่นที่ San Fierro
    spawnPlayer(source, -1969.4, 137.85, 27.69, 0, 0, 0, 0)
    fadeCamera(source, true)
    setCameraTarget(source, source)
end

addEventHandler("onPlayerLogin", root, onPlayerLogin)