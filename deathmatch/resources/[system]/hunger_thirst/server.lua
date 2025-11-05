--[[
    Hunger & Thirst System
    ระบบที่จะลดค่า Hunger และ Thirst ของผู้เล่นลงเรื่อยๆ
]]

-- ตัวแปรเก็บ Timer สำหรับแต่ละผู้เล่น
local playerTimers = {}
local playerDamageTimers = {}

-- ดึงค่า Settings
local decreaseInterval = tonumber(get("decrease_interval")) or 1000
local hungerDecreaseAmount = tonumber(get("hunger_decrease_amount")) or 0.1
local thirstDecreaseAmount = tonumber(get("thirst_decrease_amount")) or 0.15
local defaultHunger = tonumber(get("default_hunger")) or 100
local defaultThirst = tonumber(get("default_thirst")) or 100
local damageWhenLow = get("damage_when_low") == "true"
local damageAmount = tonumber(get("damage_amount")) or 1
local damageInterval = tonumber(get("damage_interval")) or 5000

-- ฟังก์ชันเริ่มต้นระบบสำหรับผู้เล่น
function startHungerThirstSystem(player)
    if not isElement(player) then return end
    
    -- หยุด Timer เก่าถ้ามี
    stopHungerThirstSystem(player)
    
    -- ตั้งค่าเริ่มต้นถ้ายังไม่มี
    if not getElementData(player, "hunger") then
        setElementData(player, "hunger", defaultHunger)
    end
    if not getElementData(player, "thirst") then
        setElementData(player, "thirst", defaultThirst)
    end
    
    -- สร้าง Timer ใหม่สำหรับลด hunger/thirst
    playerTimers[player] = setTimer(function()
        if not isElement(player) then
            stopHungerThirstSystem(player)
            return
        end
        
        -- ดึงค่าปัจจุบัน
        local currentHunger = getElementData(player, "hunger") or 100
        local currentThirst = getElementData(player, "thirst") or 100
        
        -- ลดค่าลง
        local newHunger = math.max(0, currentHunger - hungerDecreaseAmount)
        local newThirst = math.max(0, currentThirst - thirstDecreaseAmount)
        
        -- อัพเดทค่าใหม่
        setElementData(player, "hunger", newHunger)
        setElementData(player, "thirst", newThirst)
        
        -- เช็คว่าค่าต่ำเกินไปหรือไม่
        if damageWhenLow then
            if newHunger <= 0 or newThirst <= 0 then
                -- เริ่มสร้างความเสียหาย
                if not playerDamageTimers[player] or not isTimer(playerDamageTimers[player]) then
                    playerDamageTimers[player] = setTimer(function()
                        if isElement(player) and not isPedDead(player) then
                            local health = getElementHealth(player)
                            setElementHealth(player, math.max(0, health - damageAmount))
                            
                            -- แจ้งเตือนผู้เล่น
                            if newHunger <= 0 and newThirst <= 0 then
                                outputChatBox("คุณกำลังหิวและหิวน้ำ! หาอาหารและน้ำเร็ว!", player, 255, 0, 0)
                            elseif newHunger <= 0 then
                                outputChatBox("คุณกำลังหิว! หาอาหารเร็ว!", player, 255, 100, 0)
                            else
                                outputChatBox("คุณกำลังหิวน้ำ! หาน้ำเร็ว!", player, 0, 150, 255)
                            end
                        end
                    end, damageInterval, 0)
                end
            else
                -- หยุดสร้างความเสียหายถ้าค่ากลับมาสูงกว่า 0
                if playerDamageTimers[player] and isTimer(playerDamageTimers[player]) then
                    killTimer(playerDamageTimers[player])
                    playerDamageTimers[player] = nil
                end
            end
        end
        
    end, decreaseInterval, 0)
    
    outputDebugString("Hunger/Thirst system started for player: " .. getPlayerName(player))
end

-- ฟังก์ชันหยุดระบบสำหรับผู้เล่น
function stopHungerThirstSystem(player)
    if playerTimers[player] and isTimer(playerTimers[player]) then
        killTimer(playerTimers[player])
        playerTimers[player] = nil
    end
    
    if playerDamageTimers[player] and isTimer(playerDamageTimers[player]) then
        killTimer(playerDamageTimers[player])
        playerDamageTimers[player] = nil
    end
end

-- เริ่มระบบเมื่อผู้เล่น Login สำเร็จ
addEventHandler("onPlayerLogin", root, function()
    startHungerThirstSystem(source)
end)

-- หยุดระบบเมื่อผู้เล่น Quit
addEventHandler("onPlayerQuit", root, function()
    stopHungerThirstSystem(source)
end)

-- เริ่มระบบเมื่อผู้เล่น Spawn
addEventHandler("onPlayerSpawn", root, function()
    startHungerThirstSystem(source)
end)

-- หยุดระบบเมื่อผู้เล่นตาย
addEventHandler("onPlayerWasted", root, function()
    stopHungerThirstSystem(source)
end)

-- เริ่มระบบสำหรับผู้เล่นที่ออนไลน์อยู่แล้วเมื่อ resource start
addEventHandler("onResourceStart", resourceRoot, function()
    outputDebugString("Hunger/Thirst System started!")
    
    -- เริ่มระบบสำหรับผู้เล่นทุกคนที่ออนไลน์อยู่
    for _, player in ipairs(getElementsByType("player")) do
        local account = getPlayerAccount(player)
        if account and not isGuestAccount(account) then
            startHungerThirstSystem(player)
        end
    end
end)

-- หยุดระบบทั้งหมดเมื่อ resource stop
addEventHandler("onResourceStop", resourceRoot, function()
    for player, timer in pairs(playerTimers) do
        stopHungerThirstSystem(player)
    end
    outputDebugString("Hunger/Thirst System stopped!")
end)

-- Commands สำหรับทดสอบ/จัดการ
addCommandHandler("sethunger", function(player, cmd, targetPlayer, amount)
    if not hasObjectPermissionTo(player, "function.setElementData", false) then
        outputChatBox("คุณไม่มีสิทธิ์ใช้คำสั่งนี้!", player, 255, 0, 0)
        return
    end
    
    local target = targetPlayer and getPlayerFromName(targetPlayer) or player
    local value = tonumber(amount) or 100
    
    if target then
        value = math.max(0, math.min(100, value))
        setElementData(target, "hunger", value)
        outputChatBox("ตั้งค่า Hunger ของ " .. getPlayerName(target) .. " เป็น " .. value, player, 0, 255, 0)
    else
        outputChatBox("ไม่พบผู้เล่น!", player, 255, 0, 0)
    end
end)

addCommandHandler("setthirst", function(player, cmd, targetPlayer, amount)
    if not hasObjectPermissionTo(player, "function.setElementData", false) then
        outputChatBox("คุณไม่มีสิทธิ์ใช้คำสั่งนี้!", player, 255, 0, 0)
        return
    end
    
    local target = targetPlayer and getPlayerFromName(targetPlayer) or player
    local value = tonumber(amount) or 100
    
    if target then
        value = math.max(0, math.min(100, value))
        setElementData(target, "thirst", value)
        outputChatBox("ตั้งค่า Thirst ของ " .. getPlayerName(target) .. " เป็น " .. value, player, 0, 255, 0)
    else
        outputChatBox("ไม่พบผู้เล่น!", player, 255, 0, 0)
    end
end)

-- ฟังก์ชันสำหรับเพิ่มค่า hunger/thirst (สำหรับใช้กับระบบอาหาร)
function addHunger(player, amount)
    if not isElement(player) then return false end
    
    local current = getElementData(player, "hunger") or 100
    local newValue = math.min(100, current + amount)
    setElementData(player, "hunger", newValue)
    return true
end

function addThirst(player, amount)
    if not isElement(player) then return false end
    
    local current = getElementData(player, "thirst") or 100
    local newValue = math.min(100, current + amount)
    setElementData(player, "thirst", newValue)
    return true
end

-- Export functions เพื่อให้ resource อื่นๆ สามารถเรียกใช้ได้
