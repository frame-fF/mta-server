function onPlayerWasted()
    local player = source  -- เก็บค่า source ไว้ใน local variable

    -- Load or Set ElementData
    local hunger = setElementData(player, "hunger", 100)
    local thirst = setElementData(player, "thirst", 100)
    local stamina = setElementData(player, "stamina", 100)

    local team = getPlayerTeam(player)
    local team = team and getTeamName(team)
    local skin = getElementModel(player)
    local wantedlevel = getPlayerWantedLevel(player)

    -- Set Health Armor Money Wantedlevel
    setElementHealth(player, 100)
    setPedArmor(player, 0)
    takePlayerMoney(player, 1000)  -- ลดเงินผู้เล่น 1000
    setPlayerWantedLevel(player, wantedlevel)
    -- Set clothes
    local clothes = {}
    for type = 0, 17 do
        local texture, model = getPedClothes(player, type)
        if (texture) and (model) then
            table.insert(clothes, { texture, model, type })
        end
    end
    for _, cloth in ipairs(clothes) do
        addPedClothes(player, cloth[1], cloth[2], cloth[3])
    end

    -- รอ 3 วินาที แล้วสปอนผู้เล่นที่ San Fierro
    setTimer(function()
        spawnPlayer(
            player,
            -1969.4, 137.85, 27.69,
            0,
            skin,
            0,
            0,
            team
        )
        fadeCamera(player, true)
        setCameraTarget(player, player)
    end, 3000, 1)
end

addEventHandler("onPlayerWasted", root, onPlayerWasted)
