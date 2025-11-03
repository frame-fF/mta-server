function loginPlayer(thePlayer, command, username, password)
    local result = exports.api_player:get_account(thePlayer, username, password)
end

addCommandHandler("log-in", loginPlayer) 
