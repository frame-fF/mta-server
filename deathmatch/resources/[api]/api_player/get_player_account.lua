function get_player_account(source)
    local username = getPlayerName(source)
    local url = "http://127.0.0.1:8000" .. '/api/player/me/'
    local key = getElementData(source, "results").key

    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "GET",
        headers = {
            ["Authorization"] = "Token ".. key
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            local result = fromJSON(data)
            local player_data = result.data
            -- Set player name
            setPlayerName(source, result.username)

            -- Set player positiona
            local x, y, z = player_data.position.x, player_data.position.y, player_data.position.z
            -- Set player team
            team = player_data.team and getTeamFromName(player_data.team)

            spawnPlayer(
                source,
                x, y, z,
                player_data.rotation,
                player_data.skin,
                player_data.interior,
                player_data.dimension,
                team
            )

            if player_data.weapons then
                for weapon, ammo in pairs(player_data.weapons) do
                    giveWeapon(source, tonumber(weapon), tonumber(ammo))
                end
            end

            setElementHealth(source, player_data.health)
            setPedArmor(source, player_data.armor)
            setPlayerMoney(source, player_data.money)
            setPlayerWantedLevel(source, player_data.wantedlevel)

            clothes = unpack(player_data.clothes)
            if player_data.clothes then
                for _, cloth in ipairs(player_data.clothes) do
                    addPedClothes(source, cloth[1], cloth[2], cloth[3])
                end
            end

            fadeCamera(source, true)
            setCameraTarget(source, source)
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end
