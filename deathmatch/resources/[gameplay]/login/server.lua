function loginPlayer(source, command, username, password)
    login(source, username, password)
end

addCommandHandler("log-in", loginPlayer) 

function login(source, username, password)
    local url = exports.settings:baseUrl() .. '/api/player/login/'
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "POST",
        formFields = {
            username = username,
            password = password,
        }
    }
end