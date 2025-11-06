local function playerLogin(source, username, password)
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
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            -- Parse JSON data
            local result = fromJSON(data)
            -- setElementData
            setElementData(source, "results", result)
            setElementData(source, "hunger", 100)
            setElementData(source, "thirst", 100)
            setElementData(source, "stamina", 100)

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
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end

local function onPlayerLogin(source)
    local username = getPlayerName(source)
    local url = exports.settings:baseUrl() .. '/api/player/me/'
    local key = getElementData(source, "results").key

    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "GET",
        headers = {
            ["Authorization"] = "Token " .. key
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            local result = fromJSON(data)
            local player_data = result.data
            -- Set player name
            setPlayerName(source, result.username)

            -- Set player positiona
            local x, y, z = unpack(player_data.position[1])

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

            local weapons = unpack(player_data.weapons)
            for weapon, ammo in pairs(weapons) do
                giveWeapon(source, weapon, ammo)
            end

            setElementHealth(source, player_data.health)
            setPedArmor(source, player_data.armor)
            setPlayerMoney(source, player_data.money)
            setPlayerWantedLevel(source, player_data.wantedlevel)

            clothes = unpack(player_data.clothes)
            for _, cloth in ipairs(clothes) do
                addPedClothes(source, cloth[1], cloth[2], cloth[3])
            end

            fadeCamera(source, true)
            setCameraTarget(source, source)
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end


local function commandLogin(source, command, username, password)
    playerLogin(source, username, password)
end

addCommandHandler("log-in", commandLogin)

addEventHandler("onPlayerLogin", root, onPlayerLogin)


