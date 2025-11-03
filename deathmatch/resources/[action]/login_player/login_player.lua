function loginPlayer(source, command, username, password)
    local result = exports.api_player:get_account(source, username, password)
end

addCommandHandler("log-in", loginPlayer) 


function login_player(source, username, password)
    local result = exports.api_player:get_account(source, username, password)
end