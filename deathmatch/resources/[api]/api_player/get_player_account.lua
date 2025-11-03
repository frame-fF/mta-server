function get_player_account(source)
    local username = getPlayerName(source)
    local url = "http://127.0.0.1:8000" .. '/api/player/' .. username .. '/'
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "GET",
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            local result = fromJSON(data)
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end
