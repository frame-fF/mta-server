local function onPlayerJoin()
    outputChatBox("Welcome to the server, " .. getPlayerName(source) .. "!")
end

addEventHandler("onPlayerJoin", root, onPlayerJoin)