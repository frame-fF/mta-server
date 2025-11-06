-- Stamina System - Server Side
-- ระบบ Stamina สำหรับควบคุมการวิ่งของผู้เล่น

-- ตั้งค่าเริ่มต้น
local MAX_STAMINA = 100
local STAMINA_DRAIN_RATE = 6  -- ลดลง 2 ต่อวินาที เมื่อวิ่ง
local STAMINA_REGEN_RATE = 1.5  -- เพิ่มขึ้น 1.5 ต่อวินาที เมื่อไม่วิ่ง
local REGEN_DELAY = 3  -- ต้องหยุดวิ่ง 3 วินาทีก่อน stamina จะเริ่มฟื้น

-- ตารางเก็บเวลาที่หยุดวิ่งของแต่ละผู้เล่น
local playerStopTime = {}

-- ฟังก์ชันเมื่อผู้เล่นเข้าเกม
function onPlayerJoin()
    -- ตั้งค่า stamina เริ่มต้นเป็น 100
    setElementData(source, "stamina", MAX_STAMINA)
end
addEventHandler("onPlayerJoin", root, onPlayerJoin)

-- ฟังก์ชันเมื่อ resource เริ่มทำงาน (สำหรับผู้เล่นที่อยู่ในเกมแล้ว)
function onResourceStart()
    for _, player in ipairs(getElementsByType("player")) do
        if not getElementData(player, "stamina") then
            setElementData(player, "stamina", MAX_STAMINA)
        end
    end
    outputDebugString("Stamina System: Server started successfully")
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

-- ฟังก์ชันจัดการ stamina เมื่อผู้เล่นวิ่ง
function handleStaminaDrain(player, isRunning)
    local currentStamina = getElementData(player, "stamina") or MAX_STAMINA
    local currentTime = getTickCount()
    
    if isRunning then
        -- ลด stamina เมื่อวิ่ง
        local newStamina = math.max(0, currentStamina - STAMINA_DRAIN_RATE)
        setElementData(player, "stamina", newStamina)
        
        -- รีเซ็ตเวลาหยุดวิ่ง
        playerStopTime[player] = nil
        
        -- ถ้า stamina หมด ให้แจ้งเตือน client
        if newStamina <= 0 then
            triggerClientEvent(player, "onStaminaDepleted", player)
        end
    else
        -- บันทึกเวลาที่หยุดวิ่งครั้งแรก
        if not playerStopTime[player] then
            playerStopTime[player] = currentTime
        end
        
        -- คำนวณว่าหยุดวิ่งมานานเท่าไหร่แล้ว (เป็นวินาที)
        local timeStopped = (currentTime - playerStopTime[player]) / 1000
        
        -- ถ้าหยุดวิ่งเกิน 3 วินาที ค่อยเริ่มฟื้น stamina
        if timeStopped >= REGEN_DELAY then
            local newStamina = math.min(MAX_STAMINA, currentStamina + STAMINA_REGEN_RATE)
            setElementData(player, "stamina", newStamina)
        end
    end
end
addEvent("onPlayerStaminaUpdate", true)
addEventHandler("onPlayerStaminaUpdate", root, handleStaminaDrain)

-- ลบข้อมูลผู้เล่นเมื่อออกจากเกม
function onPlayerQuit()
    playerStopTime[source] = nil
end
addEventHandler("onPlayerQuit", root, onPlayerQuit)

-- คำสั่งสำหรับตรวจสอบ stamina (สำหรับ debug)
function checkStamina(player)
    local stamina = getElementData(player, "stamina") or 0
    outputChatBox("Your stamina: " .. math.floor(stamina) .. "%", player, 0, 255, 0)
end
addCommandHandler("stamina", checkStamina)
