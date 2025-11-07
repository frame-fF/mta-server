local function save(source, data)
    local url = exports.settings:baseUrl() .. '/api/player/me/data/update/'
    local key = getElementData(source, "results").key
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "PATCH",
        formFields = data,
        headers = {
            ["Authorization"] = "Token " .. key
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            iprint("Save data success")
        else
            outputChatBox('Error: ' .. data, source)
        end
    end)
end


local function savePlayerData()
    local player = source
    local account = getPlayerAccount(player)

    if not account then
        return
    end

    local username = getAccountName(account)
    -- Save ElementData
    local hunger = getElementData(player, "hunger") or 100
    local thirst = getElementData(player, "thirst") or 100
    local stamina = getElementData(player, "stamina") or 100

    local x, y, z = getElementPosition(player)
    local rotation = getPedRotation(player)
    local skin = getElementModel(player)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)
    local team = getPlayerTeam(player)

    local weapon = getPedWeapon(player)
    local ammo = getPedTotalAmmo(player)
    local health = getElementHealth(player)
    local armor = getPedArmor(player)
    local money = getPlayerMoney(player)
    local wantedlevel = getPlayerWantedLevel(player)

    local position = toJSON({ x, y, z })
    local team = team and getTeamName(team)
    local weapons = {}
    for slot = 0, 12 do
        local weapon = getPedWeapon(player, slot)
        local ammo = getPedTotalAmmo(player, slot)
        if (weapon > 0) and (ammo > 0) then
            weapons[weapon] = ammo
        end
    end

    local clothes = {}
    for type = 0, 17 do
        local texture, model = getPedClothes(player, type)
        if (texture) and (model) then
            table.insert(clothes, { texture, model, type })
        end
    end

    local data = {
        position = position,
        rotation = rotation,
        skin = skin,
        interior = interior,
        dimension = dimension,
        team = team,
        weapons = toJSON(weapons),
        health = health,
        armor = armor,
        money = money,
        wantedlevel = wantedlevel,
        clothes = toJSON(clothes),
        -- Additional Status
        hunger = hunger,
        thirst = thirst,
        stamina = stamina
    }
    save(player, data)
end

addEvent("savePlayerData", true)
addEventHandler("savePlayerData", root, savePlayerData)


addEventHandler("onPlayerQuit", root,
    function()
        triggerEvent("savePlayerData", source)
    end)

addEventHandler("onPlayerLogout", root,
    function()
        triggerEvent("savePlayerData", source)
    end)

addEventHandler("onPlayerSpawn", root,
    function()
        triggerEvent("savePlayerData", source)
    end)

addEventHandler("onResourceStop", root,
    function()
        for _, player in ipairs(getElementsByType("player")) do
            local account = getPlayerAccount(player)
            if (account) and not (isGuestAccount(account)) then
                triggerEvent("savePlayerData", player)
            end
        end
    end)