function register(source, username, email, password, password2)
    local player = source
    local url = exports.settings:baseUrl() .. '/api/player/register/'
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "POST",
        formFields = {
            username = username,
            email = email,
            password = password,
            password2 = password2
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 201 then
            addAccount(username, password)
            outputChatBox('Registration successful! You can now log in.', player, 0, 255, 0)
        else
            outputChatBox('Error: ' .. data, player)
        end
    end)
end
