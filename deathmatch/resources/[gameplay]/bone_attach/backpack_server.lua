local function addBackpack(player)
    -- ตรวจสอบว่ามีผู้เล่นจริงหรือไม่
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end

    -- สร้างกระเป๋า (Object ID 371)
    -- เราไม่จำเป็นต้องกำหนดตำแหน่งตอนสร้าง เพราะสคริปต์จะย้ายไปที่ผู้เล่นทันที
    local x, y, z = getElementPosition(player)
    local backpack = createObject(371, x, y, z)
    local sniper = createObject(358, x, y, z)

    if isElement(backpack) then
        -- ใช้ฟังก์ชัน attachElementToBone
        -- attachElementToBone(element, ped, bone, x, y, z, rx, ry, rz)
        -- Bone 3 = Spine (กระดูกสันหลัง)
        attachElementToBone(backpack, player, 3, 0, -0.225, 0.05, 90, 0, 0)
        attachElementToBone(sniper, player, 3, 0.19, -0.31, -0.1, 0, 270, -90)
    end
end

-- เมื่อผู้เล่นเข้ามาในเซิร์ฟเวอร์ (หรือ resource เริ่มทำงาน)
addEventHandler("onPlayerJoin", root, function()
    addBackpack(source)
end)

-- หรือถ้าคุณอยากให้ทำงานเมื่อ Resource รีสตาร์ทสำหรับคนที่อยู่แล้ว
addEventHandler("onResourceStart", resourceRoot, function()
    -- วนลูปผู้เล่นทั้งหมดที่อยู่ในเกม
    for _, player in ipairs(getElementsByType("player")) do
        addBackpack(player)
    end
end)
