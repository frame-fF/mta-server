function registerPlayer(source, commandName, username, email, password, password2)
    exports.api_player:register(source, username, password, password_confirm)
end

addCommandHandler("register", registerPlayer)
