function onPlayerQuit()
    local account = getPlayerAccount(source)

    if not account or isGuestAccount(account) then
        return
    end

    local username = getAccountName(account)

    local x, y, z = getElementPosition(source)
    local rotation = getPedRotation(source)
    local skin = getElementModel(source)
    local interior = getElementInterior(source)
    local dimension = getElementDimension(source)
    local team = getPlayerTeam(source)

    local weapon = getPedWeapon(source)
    local ammo = getPedTotalAmmo(source)
    local health = getElementHealth(source)
    local armor = getPedArmor(source)
    local money = getPlayerMoney(source)
    local wantedlevel = getPlayerWantedLevel(source)

    local position = toJSON({ x, y, z })
    local team = team and getTeamName(team)
    local weapons = {}
    for slot = 1, 12 do
        local weapon = getPedWeapon(source, slot)
        local ammo = getPedTotalAmmo(source, slot)
        if (weapon > 0) and (ammo > 0) then
            weapons[weapon] = ammo
        end
    end

    local clothes = {}
    for type = 0, 17 do
        local texture, model = getPedClothes(source, type)
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
        clothes = toJSON(clothes)
    }
    result = exports.api_player:save_player_account(source, data)
    logOut(source)
end

addEventHandler("onPlayerQuit", root, onPlayerQuit)
