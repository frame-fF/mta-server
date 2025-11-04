-- ฟังก์ชันวาดชื่อบนหัวผู้เล่น
local function drawCustomNametags()
    local cx, cy, cz = getCameraMatrix()
    
    for _, player in ipairs(getElementsByType("player")) do
        if isElement(player) and player ~= localPlayer then
            local px, py, pz = getElementPosition(player)
            
            -- คำนวณระยะห่าง
            local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
            
            -- แสดงชื่อเฉพาะในระยะไม่เกิน 30 เมตร
            if distance <= 30 then
                -- เพิ่มความสูงให้ชื่อลอยเหนือหัว
                local namePosZ = pz + 1
                
                -- ตรวจสอบว่ามีสิ่งกีดขวางระหว่างกล้องกับผู้เล่นหรือไม่
                local lineOfSight = isLineOfSightClear(cx, cy, cz, px, py, namePosZ, true, true, true, true, false, false, false, localPlayer)
                
                if lineOfSight then
                    -- แปลงพิกัด 3D เป็น 2D
                    local sx, sy = getScreenFromWorldPosition(px, py, namePosZ)
                    
                    if sx and sy then
                        -- ดึงชื่อผู้เล่น
                        local name = getPlayerName(player)
                        
                        -- คำนวณขนาดตัวอักษรตามระยะ
                        local scale = 1 - (distance / 30) * 0.5
                        if scale < 0.5 then scale = 0.5 end
                        
                        -- วาดพื้นหลังสีดำโปร่งใส
                        local textWidth = dxGetTextWidth(name, scale, "default-bold")
                        local textHeight = dxGetFontHeight(scale, "default-bold")
                        dxDrawRectangle(sx - textWidth/2 - 5, sy - textHeight/2 - 2, textWidth + 10, textHeight + 4, tocolor(0, 0, 0, 150), false)
                        
                        -- วาดชื่อผู้เล่น (ตรงกลาง)
                        dxDrawText(name, sx, sy, sx, sy, tocolor(255, 255, 255, 255), scale, "default-bold", "center", "center", false, false, false, true)
                    end
                end
            end
        end
    end
end

-- เพิ่ม event handler สำหรับวาดชื่อ
addEventHandler("onClientRender", root, drawCustomNametags)
