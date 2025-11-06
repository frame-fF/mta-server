-- HUD System for displaying hunger and thirst
local screenW, screenH = guiGetScreenSize()

-- ตำแหน่งและขนาดของ HUD
local hudX = screenW - 220  -- ตำแหน่ง X (มุมขวาล่าง)
local hudY = screenH - 120  -- ตำแหน่ง Y (ด้านล่าง)
local barWidth = 200
local barHeight = 25
local barSpacing = 10

-- สีของแถบ
local colors = {
    hunger = {r = 255, g = 140, b = 0},  -- สีส้ม
    thirst = {r = 0, g = 150, b = 255},  -- สีฟ้า
    stamina = {r = 128, g = 128, b = 128}    -- สีเทา
}

-- ฟังก์ชันวาด HUD
function drawHUD()
    local player = getLocalPlayer()
    
    -- ดึงค่า hunger และ thirst จาก element data
    local hunger = getElementData(player, "hunger") or 100
    local thirst = getElementData(player, "thirst") or 100
    local stamina = getElementData(localPlayer, "stamina") or 0
    
    -- จำกัดค่าให้อยู่ระหว่าง 0-100
    hunger = math.max(0, math.min(100, hunger))
    thirst = math.max(0, math.min(100, thirst))
    stamina = math.max(0, math.min(100, stamina))
    
    -- คำนวณความกว้างของแถบตามเปอร์เซ็นต์
    local hungerBarWidth = (hunger / 100) * barWidth
    local thirstBarWidth = (thirst / 100) * barWidth
    local staminaBarWidth = (stamina / 100) * barWidth
    
    -- วาดพื้นหลังแถบ Hunger
    dxDrawRectangle(hudX, hudY, barWidth, barHeight, tocolor(0, 0, 0, 150))
    -- วาดแถบ Hunger
    dxDrawRectangle(hudX, hudY, hungerBarWidth, barHeight, tocolor(255, 140, 0, 200))
    -- วาดข้อความ Hunger
    dxDrawText("Hunger: " .. math.floor(hunger) .. "%", hudX, hudY, hudX + barWidth, hudY + barHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
    
    -- วาดพื้นหลังแถบ Thirst
    local thirstY = hudY + barHeight + barSpacing
    dxDrawRectangle(hudX, thirstY, barWidth, barHeight, tocolor(0, 0, 0, 150))
    -- วาดแถบ Thirst
    dxDrawRectangle(hudX, thirstY, thirstBarWidth, barHeight, tocolor(0, 150, 255, 200))
    -- วาดข้อความ Thirst
    dxDrawText("Thirst: " .. math.floor(thirst) .. "%", hudX, thirstY, hudX + barWidth, thirstY + barHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
    
    -- วาดพื้นหลังแถบ Stamina
    local staminaY = thirstY + barHeight + barSpacing
    dxDrawRectangle(hudX, staminaY, barWidth, barHeight, tocolor(0, 0, 0, 150))
    -- วาดแถบ Stamina
    dxDrawRectangle(hudX, staminaY, staminaBarWidth, barHeight, tocolor(128, 128, 128, 200))
    -- วาดข้อความ Stamina
    dxDrawText("Stamina: " .. math.floor(stamina) .. "%", hudX, staminaY, hudX + barWidth, staminaY + barHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
end

-- เริ่มวาด HUD เมื่อ resource เริ่มทำงาน
addEventHandler("onClientResourceStart", resourceRoot, function()
    addEventHandler("onClientRender", root, drawHUD)
    outputChatBox("HUD System loaded!", 0, 255, 0)
end)

-- หยุดวาด HUD เมื่อ resource หยุดทำงาน
addEventHandler("onClientResourceStop", resourceRoot, function()
    removeEventHandler("onClientRender", root, drawHUD)
end)
