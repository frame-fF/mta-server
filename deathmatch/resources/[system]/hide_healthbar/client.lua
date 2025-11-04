-- ซ่อนการแสดงผลแทบเลือด
addEventHandler("onClientRender", root, function()
    -- วิธีที่ 1: ใช้ setPlayerNametagShowing เพื่อซ่อน nametag และแทบเลือด
    for _, player in ipairs(getElementsByType("player")) do
        if player ~= localPlayer then
            -- ซ่อนแทบเลือดโดยการปิด nametag
            setPlayerNametagShowing(player, false)
        end
    end
end)
