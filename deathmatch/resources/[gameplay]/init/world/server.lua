local function zombiesSpawn(res)
    for _, pos in ipairs(ZOMBIES_SPAWN) do
        -- สร้าง 100 ตัวต่อแต่ละตำแหน่งในตาราง (ถ้าต้องการรวมทั้งหมด ให้ย้าย loop นี้ออกไป)
        for i = 1, 50 do
            -- เพิ่ม offset เล็กน้อยเพื่อไม่ให้เกิดทับจุดเดียวกัน
            local offsetX = (math.random() - 0.5) * 10
            local offsetY = (math.random() - 0.5) * 10
            exports.zombies:createZombie(pos.x + offsetX, pos.y + offsetY, pos.z)
        end
    end
end

addEventHandler("onResourceStart", root, zombiesSpawn)