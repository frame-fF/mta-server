function register(source, username, email, password, password2)
    local url = get("base_url") .. '/api/player/register/'
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
            outputChatBox('Registration successful! You can now log in.', source, 0, 255, 0)
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end
