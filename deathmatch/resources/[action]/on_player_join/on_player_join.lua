local function onPlayerJoin()
    outputChatBox("Welcome to the server")
    outputChatBox("login using /login [username] [password]")
end

addEventHandler("onPlayerJoin", root, onPlayerJoin)