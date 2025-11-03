function onPlayerWasted()
    local team = getPlayerTeam(source)
    local team = team and getTeamName(team)
    local skin = getElementModel(source)
    local money = getPlayerMoney(source)
    local wantedlevel = getPlayerWantedLevel(source)

    local clothes = {}
    for type = 0, 17 do
        local texture, model = getPedClothes(source, type)
        if (texture) and (model) then
            table.insert(clothes, { texture, model, type })
        end
    end

    setElementHealth(source, 100)
    setPedArmor(source, 0)
    for _, cloth in ipairs(clothes) do
        addPedClothes(source, cloth[1], cloth[2], cloth[3])
    end

    local thePlayer = source

    -- รอ 3 วินาที แล้วสปอนผู้เล่นที่ San Fierro
    setTimer(function()
        spawnPlayer(
            thePlayer,
            -1969.4, 137.85, 27.69,
            0,
            skin,
            0,
            0,
            team
        )
        fadeCamera(thePlayer, true)
        setCameraTarget(thePlayer, thePlayer)
    end, 3000, 1)
end

addEventHandler("onPlayerWasted", root, onPlayerWasted)
