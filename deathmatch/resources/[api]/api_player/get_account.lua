function get_account(source, username, password)
    local url = "http://127.0.0.1:8000" .. '/api/player/login/'
    sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "POST",
        formFields = {
            username=username,
            password=password,
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        iprint(data)
        if info.statusCode == 200 then
            outputChatBox('login success', source, 0, 255, 0)
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end
