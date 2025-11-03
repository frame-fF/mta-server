function save_player_account(
    username,
    position,
    rotation,
    skin,
    interior,
    dimension,
    team,
    weapons,
    health,
    armor,
    money,
    wantedlevel,
    clothes
)
    local url = "http://127.0.0.1:8000" .. '/api/player/me/'
    local key = getElementData(source, "results").key
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "PATCH",
        formFields = {
            position = position,
            rotation = rotation,
            skin = skin,
            interior = interior,
            dimension = dimension,
            team = team,
            weapons = weapons,
            health = health,
            armor = armor,
            money = money,
            wantedlevel = wantedlevel,
            clothes = clothes
        },
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
