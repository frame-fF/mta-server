local function remotePlayerJoin()
	outputChatBox("* " .. getPlayerName(source) .. " has joined the server")
end

addEventHandler("onPlayerJoin", root, remotePlayerJoin)