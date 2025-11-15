local function zombiesSpawn(res)
    for _, pos in ipairs(ZOMBIES_SPAWN) do
        -- สร้าง 50 ตัวต่อแต่ละตำแหน่งในตาราง (ถ้าต้องการรวมทั้งหมด ให้ย้าย loop นี้ออกไป)
        local minR, maxR = 10, 60  -- ระยะห่างขั้นต่ำและมากสุด (หน่วยเดียวกับพิกัด)
        for i = 1, 50 do
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