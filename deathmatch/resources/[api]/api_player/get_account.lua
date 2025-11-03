function get_account(source, username, password)
    local url = "http://127.0.0.1:8000" .. '/api/player/login/'
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "POST",
        formFields = {
            username = username,
            password = password,
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            outputChatBox('login success', source, 0, 255, 0)
            -- Parse JSON data
            local result = fromJSON(data)
            -- เช็คว่าเคยร์มีอยู่ในระบบหรือไม่
            local account = getAccount(username, password)
            if (account ~= false) then
                -- ถ้ามีแล้วให้ทำการล็อกอิน
                logIn(source, account, password)
            else
                -- ถ้าไม่มีให้สร้างบัญชีใหม่แล้วทำการล็อกอิน
                local new_account = addAccount(username, password)
                logIn(source, new_account, password)
            end

            local player_data = result.user.data

            -- Set player name
            setPlayerName(source, result.user.username)

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

            setElementData(source, "results", result)
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end
