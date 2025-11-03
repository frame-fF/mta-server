function get_account(source, username, password)
    local url = "http://127.0.0.1:8000" .. '/api/player/login'

    local jsonData = toJSON({
        username = username,
        password = password
    })

    sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "POST",
        postData = jsonData,
        headers = {
            ["accept"] = "application/json",
            ["Content-Type"] = "application/json"  -- เพิ่ม header
        } 
    }
    fetchRemote(url, sendOptions, function(data, info)
        iprint("----", data, info.statusCode)
        if info.success then
            outputChatBox('login success', source, 0, 255, 0)
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end
