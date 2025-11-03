local function onPlayerJoin()
    outputChatBox("Welcome to the server! Please login or register.", source)
end

addEventHandler("onPlayerJoin", root, onPlayerJoin)