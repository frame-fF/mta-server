function loginPlayer(thePlayer, command, username, password)
    local result = exports.api_player:get_account(source, username, password)
    
end

addCommandHandler("log-in", loginPlayer) 
