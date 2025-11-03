local function onPlayerLogin()
    local result = exports.api_player:get_player_account(source)
    outputChatBox("Welcome to the server, " .. getPlayerName(source) .. "!")
end

addEventHandler("onPlayerLogin", root, onPlayerLogin)