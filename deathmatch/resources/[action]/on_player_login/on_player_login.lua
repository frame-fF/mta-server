local function onPlayerLogin()
    outputChatBox("Welcome back to the server, " .. getPlayerName(source) .. "!")
    -- -- สปอนผู้เล่นที่ San Fierro
    -- spawnPlayer(source, -1969.4, 137.85, 27.69, 0, 0, 0, 0)
    -- fadeCamera(source, true)
    -- setCameraTarget(source, source)

    -- local account = getPlayerAccount(source)
    -- local username = getAccountName(account)
    
    result = exports.api_player:get_player_account(source, username)
end

addEventHandler("onPlayerLogin", root, onPlayerLogin)