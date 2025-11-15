-- ตารางพิกัดจุดเกิดของซอมบี้
ZOMBIES_SPAWN = {
    { x = -2706.3330078125, y = 376.490234375,   z = 4.9684176445007 },
    { x = -2072.162109375,  y = 211.5029296875,  z = 35.391548156738 },
    { x = -2751.9990234375, y = -280.2392578125, z = 7.0390625 },
}

-- ฟังก์ชันที่จะทำงานเมื่อ Resource เริ่ม
local function zombiesSpawn(res)
    -- ตรวจสอบว่า Resource ที่เริ่มคือตัวนี้เองหรือไม่ (ป้องกันการรันซ้ำซ้อน)
    if res and res ~= getThisResource() then return end

    -- วนลูปตามจำนวนจุดเกิดในตาราง ZOMBIES_SPAWN
    for _, pos in ipairs(ZOMBIES_SPAWN) do
        -- === ส่วนที่เพิ่มเข้ามาสำหรับ Radar Area ===
        local minR, maxR = 50, 100             -- นำค่า maxR มาใช้คำนวณขนาด Radar
        local radarSize = maxR * 2             -- ขนาดของ Radar Area (เส้นผ่านศูนย์กลางสูงสุด)
        local radarX = pos.x - (radarSize / 2) -- คำนวณมุมบนซ้าย X (จุดศูนย์กลาง - รัศมี)
        local radarY = pos.y - (radarSize / 2) -- คำนวณมุมบนซ้าย Y (จุดศูนย์กลาง - รัศมี)

        -- สร้าง Radar Area (x, y, width, height, r, g, b, a)
        createRadarArea(radarX, radarY, radarSize, radarSize, 255, 0, 0, 100)
        -- =======================================

        local count = math.random(18, 21) -- จำนวนซอมบี้ที่จะสร้างในแต่ละตำแหน่ง

        -- วนลูปเพื่อสร้างซอมบี้ตามจำนวน
        for i = 1, count do
            -- สุ่มมุมและรัศมี
            local angle = math.random() * 2 * math.pi
            local r = minR + math.random() * (maxR - minR)
            local offsetX = math.cos(angle) * r
            local offsetY = math.sin(angle) * r

            -- สร้างซอมบี้โดยใช้ export
            exports.zombies:createZombie(pos.x + offsetX, pos.y + offsetY, pos.z)
        end
    end
end
-- เพิ่ม Event Handler ให้เรียกใช้ฟังก์ชัน zombiesSpawn เมื่อ Resource เริ่มทำงาน
addEventHandler("onResourceStart", root, zombiesSpawn)


SLOTHBOT_SPAWN = {
    { x = -2618.5966796875, y = 184.8291015625, z = 4.3407707214355 },
}


local function slothbotSpawn(res)
    if res and res ~= getThisResource() then return end

    for _, pos in ipairs(SLOTHBOT_SPAWN) do
        for i = 1, 1 do
            exports.slothbot:spawnBot(
                pos.x, pos.y, pos.z, 0,
                299, -- skin
                0,
                0,
                nil,
                31,
                "hunting",
                nil
            )
        end
    end
end

addEventHandler("onResourceStart", root, slothbotSpawn)
