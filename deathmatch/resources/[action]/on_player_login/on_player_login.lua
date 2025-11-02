local function onPlayerLogin(source)
    outputChatBox("Welcome back to the server, " .. getPlayerName(source) .. "!")
end

addEventHandler("onPlayerLogin", root, onPlayerLogin)