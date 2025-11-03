function get_player_account(source, username)
    -- Get API URL from global server configuration
    local url = get("api_base_url") or "http://127.0.0.1:8000"
    local apiEndpoint = url .. '/userdata/' .. username
    
    sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "GET",
        formFields = {},
    }
    fetchRemote(apiEndpoint, sendOptions, function(data, info)
        if info.success then
            outputChatBox('load data success', source, 0, 255, 0)
            iprint('load data success')
            local result = fromJSON(data)
            local x, y, z = unpack(result.position[1])

            team = result.team and getTeamFromName(result.team)

            spawnPlayer (
                source,
                x, y, z, 
                result.rotation, 
                result.skin , 
                result.interior, 
                result.dimension, 
                team
            )

            local weapons = unpack(result.weapons)
            for weapon, ammo in pairs(weapons) do
                giveWeapon(source, weapon, ammo)
            end

            setElementHealth(source, result.health)
            setPedArmor(source, result.armor)
            setPlayerMoney(source, result.money)
            setPlayerWantedLevel(source, result.wantedlevel)
            
            clothes = unpack(result.clothes)

            for _, cloth in ipairs(clothes) do
                addPedClothes(source, cloth[1], cloth[2], cloth[3])
            end

            for _, stat in ipairs({ 69, 70, 71, 72, 73, 74, 76, 77, 78, 79 }) do
                setPedStat(source, stat, 1000)
                -- outputChatBox("Your game stats upgraded to maximum!", source, 0, 255, 0, false)
             end
            
            fadeCamera (source, true)
	        setCameraTarget (source, source)
        else
            outputChatBox('Error: ' .. data, source, 255, 0, 0)
        end
    end)
end