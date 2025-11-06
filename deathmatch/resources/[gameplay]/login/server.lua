function loginPlayer(source, command, username, password)
    outputChatBox("Login command received. Username: " .. tostring(username) .. ", Password: " .. tostring(password), source)
end

addCommandHandler("log-in", loginPlayer) 
