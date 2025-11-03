function registerPlayer(source, commandName, username, email, password, password2)
    exports.api_player:register(source, username, email, password, password2)
end

addCommandHandler("register", registerPlayer)
