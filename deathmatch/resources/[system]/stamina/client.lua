-- Stamina System - Client Side
-- ระบบ Stamina สำหรับควบคุมการวิ่งของผู้เล่น

-- ตัวแปรสำหรับเก็บสถานะ
local isRunning = false
local canRun = true
local updateTimer = nil

-- ฟังก์ชันตรวจสอบว่าผู้เล่นกำลังวิ่งหรือไม่
function checkRunningState()
    local player = localPlayer
    
    -- ตรวจสอบว่าผู้เล่นกำลังกดปุ่มวิ่ง (Sprint) หรือไม่
    local controlState = getPedControlState(player, "sprint")
    
    -- ตรวจสอบว่าผู้เล่นกำลังเคลื่อนที่หรือไม่
    local vx, vy, vz = getElementVelocity(player)
    local isMoving = (vx ~= 0 or vy ~= 0)
    
    -- ตรวจสอบว่าผู้เล่นอยู่บนพื้นหรือไม่
    local onGround = isPedOnGround(player)
    
    -- ผู้เล่นวิ่งเมื่อ: กดปุ่ม sprint + กำลังเคลื่อนที่ + อยู่บนพื้น
    local newRunningState = controlState and isMoving and onGround
    
    -- ตรวจสอบ stamina
    local stamina = getElementData(player, "stamina") or 100
    
    -- ถ้า stamina หมด ห้ามวิ่ง
    if stamina <= 0 then
        canRun = false
        -- ปิดการวิ่ง
        if controlState then
            setPedControlState(player, "sprint", false)
        end
    else
        canRun = true
    end
    
    -- ถ้าสถานะเปลี่ยน ส่งข้อมูลไปยัง server
    if newRunningState ~= isRunning then
        isRunning = newRunningState
        triggerServerEvent("onPlayerStaminaUpdate", player, player, isRunning)
    end
    
    -- ส่งข้อมูล stamina update ไปยัง server ทุกๆ 1 วินาที
    triggerServerEvent("onPlayerStaminaUpdate", player, player, isRunning)
end

-- เริ่มตรวจสอบสถานะการวิ่ง
function startStaminaSystem()
    if updateTimer then
        killTimer(updateTimer)
    end
    
    -- ตรวจสอบทุกๆ 1 วินาที
    updateTimer = setTimer(checkRunningState, 1000, 0)
    outputChatBox("Stamina System loaded!", 0, 255, 0)
end
addEventHandler("onClientResourceStart", resourceRoot, startStaminaSystem)

-- หยุดระบบเมื่อ resource หยุด
function stopStaminaSystem()
    if updateTimer then
        killTimer(updateTimer)
        updateTimer = nil
    end
end
addEventHandler("onClientResourceStop", resourceRoot, stopStaminaSystem)

-- แจ้งเตือนเมื่อ stamina หมด
function onStaminaEmpty()
    outputChatBox("Stamina หมด! พักผ่อนสักครู่", 255, 0, 0)
end
addEvent("onStaminaDepleted", true)
addEventHandler("onStaminaDepleted", localPlayer, onStaminaEmpty)

-- ฟังก์ชันแสดง stamina bar (ถ้าต้องการ debug)
function showStaminaDebug()
    local stamina = getElementData(localPlayer, "stamina") or 0
    dxDrawText("Stamina: " .. math.floor(stamina) .. "%", 10, 10, 200, 30, tocolor(255, 255, 255, 255), 1, "default-bold")
    dxDrawText("Running: " .. tostring(isRunning), 10, 30, 200, 50, tocolor(255, 255, 255, 255), 1, "default-bold")
    dxDrawText("Can Run: " .. tostring(canRun), 10, 50, 200, 70, tocolor(255, 255, 255, 255), 1, "default-bold")
end
-- Uncomment บรรทัดด้านล่างถ้าต้องการเปิด debug
-- addEventHandler("onClientRender", root, showStaminaDebug)
