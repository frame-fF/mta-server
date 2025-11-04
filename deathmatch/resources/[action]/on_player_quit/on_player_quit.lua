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

    result = exports.api_player:save_player_account(
        source,
        username,
        position,
        rotation,
        skin,
        interior,
        dimension,
        team,
        toJSON(weapons),
        health,
        armor,
        money,
        wantedlevel,
        toJSON(clothes)
    )
end

addEventHandler("onPlayerQuit", root, onPlayerQuit)
