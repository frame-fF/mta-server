ZOMBIES_SPAWN = {
    {x = -2706.3330078125, y = 376.490234375, z = 4.9684176445007},
    {x = -2072.162109375, y = 211.5029296875, z = 35.391548156738},
}

local function zombiesSpawn(res)

    if res and res ~= getThisResource() then return end

    for _, pos in ipairs(ZOMBIES_SPAWN) do
        local minR, maxR = 50, 100  -- ระยะห่างขั้นต่ำและมากสุด (หน่วยเดียวกับพิกัด)
        local count = math.random(18, 21)  -- จำนวนซอมบี้ที่จะสร้างในแต่ละตำแหน่ง
        for i = 1, count do
            -- เพิ่ม offset เล็กน้อยเพื่อไม่ให้เกิดทับจุดเดียวกัน
            local angle = math.random() * 2 * math.pi
            local r = minR + math.random() * (maxR - minR)
            local offsetX = math.cos(angle) * r
            local offsetY = math.sin(angle) * r
            exports.zombies:createZombie(pos.x + offsetX, pos.y + offsetY, pos.z)
        end
    end
end

addEventHandler("onResourceStart", root, zombiesSpawn)