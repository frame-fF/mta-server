function save_player_account(source, data)
    local url = get("base_url") .. '/api/player/me/data/update/'
    local key = getElementData(source, "results").key
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "PATCH",
        formFields = data,
        headers = {
            ["Authorization"] = "Token ".. key
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            iprint("Save data success")
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end
