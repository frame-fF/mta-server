
    


-- ตารางเก็บข้อมูลอาวุธที่แสดงบนหลังของผู้เล่นแต่ละคน
local jugadores = {}
-- ตัวแปรเก็บข้อมูลผู้เล่นในเครื่อง (local player)
local lplayer = getLocalPlayer()
-- ตารางเก็บสถานะของผู้เล่น (มีชีวิต/อยู่ในรถ)
local info = {}


-- ฟังก์ชันสร้างอาวุธ (object) บนหลังผู้เล่น
-- @param jug: ผู้เล่นที่จะสร้างอาวุธให้
-- @param arma: ID ของอาวุธที่จะสร้าง
function crearArma(jug,arma)
	-- ดึง model ID ของอาวุธ
	local model = obtenerObjeto(arma)
	-- ดึง slot ของอาวุธ (1-7)
	local slot = getSlotFromWeapon(arma)
	-- สร้าง object อาวุธและเก็บในตาราง jugadores
	jugadores[jug][slot] = createObject(model,0,0,0)
	-- ปิด collision เพื่อไม่ให้อาวุธชนกับสิ่งอื่น
	setElementCollisionsEnabled(jugadores[jug][slot],false)
end


-- ฟังก์ชันทำลายอาวุธที่แสดงบนหลัง
-- @param jug: ผู้เล่นที่จะทำลายอาวุธ
-- @param slot: slot ของอาวุธที่จะทำลาย
function destruirArma(jug,slot)
	destroyElement(jugadores[jug][slot])
	jugadores[jug][slot] = nil
end

-- เมื่อ resource เริ่มทำงาน
addEventHandler("onClientResourceStart",resourceRoot,function()
	-- จากนั้นเริ่มต้นผู้เล่นคนอื่นๆ
	for k,v in ipairs(getElementsByType("player",root,true)) do
		jugadores[v] = {}
		info[v] = {true,isPedInVehicle(v)}
	end
end)

-- เมื่อผู้เล่นออกจากเกม
addEventHandler("onClientPlayerQuit",root,function()
	if jugadores[source] and source ~= lplayer then
		-- ทำลายอาวุธทั้งหมดบนหลังผู้เล่นที่ออก
		for k,v in pairs(jugadores[source]) do
			destroyElement(v)
		end
		-- ลบข้อมูลผู้เล่นออกจากตาราง
		jugadores[source] = nil
		info[source] = nil
	end
end)

-- เมื่อผู้เล่นเข้ามาในระยะมองเห็น (stream in)
addEventHandler("onClientElementStreamIn",root,function()
	if getElementType(source) == "player" and source ~= lplayer then
		-- เริ่มต้นข้อมูลผู้เล่นใหม่
		jugadores[source] = {}
		info[source] = {true,isPedInVehicle(source)}
	end
end)


-- เมื่อผู้เล่นออกจากระยะมองเห็น (stream out)
addEventHandler("onClientElementStreamOut",root,function()
	if jugadores[source] and source ~= lplayer then
		-- ทำลายอาวุธทั้งหมดบนหลังผู้เล่นที่หายไป
		for k,v in pairs(jugadores[source]) do
			destroyElement(v)
		end
		-- ลบข้อมูลผู้เล่นออกจากตาราง
		jugadores[source] = nil
		info[source] = nil
	end
end)

-- เมื่อผู้เล่นเกิดใหม่ (spawn)
addEventHandler("onClientPlayerSpawn",root,function()
	if jugadores[source] then
		-- อัพเดทสถานะว่าผู้เล่นมีชีวิต
		info[source][1] = true
	end
end)

-- เมื่อผู้เล่นตาย
addEventHandler("onClientPlayerWasted",root,function()
	if jugadores[source] then
		-- ทำลายอาวุธทั้งหมดบนหลังผู้เล่นที่ตาย
		for k,v in pairs(jugadores[source]) do
			destruirArma(source,k)
		end
		-- อัพเดทสถานะว่าผู้เล่นตาย
		info[source][1] = false
	end
end)

-- เมื่อผู้เล่นขึ้นรถ
addEventHandler("onClientPlayerVehicleEnter",root,function()
	if jugadores[source] then
		-- ทำลายอาวุธทั้งหมดเมื่อขึ้นรถ (เพราะไม่ควรแสดง)
		for k,v in pairs(jugadores[source]) do
			destruirArma(source,k)
		end
		-- อัพเดทสถานะว่าผู้เล่นอยู่ในรถ
		info[source][2] = true
	end
end)

-- เมื่อผู้เล่นลงจากรถ
addEventHandler("onClientPlayerVehicleExit",root,function()
	if jugadores[source] then
		-- อัพเดทสถานะว่าผู้เล่นไม่อยู่ในรถ
		info[source][2] = false
	end
end)

-- ฟังก์ชันแปลง weapon ID เป็น object model ID
-- @param arma: ID ของอาวุธ
-- @return model ID ของ object ที่จะแสดง
function obtenerObjeto(arma)
	local m
	-- อาวุธ ID 2-8 (Melee weapons)
	if arma > 1 and arma < 9 then
		m = 331 + arma
	-- อาวุธ ID 9 (Chainsaw)
	elseif arma == 9 then
		m = 341
	-- อาวุธ ID 15 (Cane)
	elseif arma == 15 then
		m = 326
	-- อาวุธ ID 22-29, 33-38, 41-43
	elseif (arma > 21 and arma < 30) or (arma > 32 and arma < 39) or (arma > 40 and arma < 44) then
		m = 324 + arma
	-- อาวุธ ID 30-31 (AK-47, M4)
	elseif arma > 29 and arma < 32 then
		m = 325 + arma
	-- อาวุธ ID 32 (Tec-9)
	elseif arma == 32 then
		m = 372
	end
	return m
end


addEventHandler("onClientPreRender",root,function()

	-- ตารางอาวุธที่อนุญาตให้แสดงบนหลัง
	local allowedWeapons = {[25]=true, [30]=true, [31]=true, [33]=true, [34]=true}
    

	for k,v in pairs(jugadores) do
		-- ดึงตำแหน่งกระดูก spine ของผู้เล่น
		local x,y,z = getPedBonePosition(k,3)
		-- คำนวณมุมหมุนของผู้เล่น
		local rot = math.rad(90-getPedRotation(k))
		local i = 30
		-- ดึง slot อาวุธที่ถือในมืออยู่
		local wep = getPedWeaponSlot(k)
		-- คำนวณระยะ offset ด้านหน้า-หลัง
		local ox,oy = math.cos(rot)*0.08,-math.sin(rot)*0.08
		-- ดึงค่า alpha ของผู้เล่น
		local alpha = getElementAlpha(k)
		for q,w in pairs(v) do
			-- ถ้าอาวุธที่กำลังแสดงตรงกับที่ถืออยู่ ให้ทำลายทิ้ง
			if q == wep then
				destruirArma(k,q)
			else
				local sideOffset = (i % 2 == 0) and  0.24 or -0.2  -- สลับซ้าย-ขวา
                exports.pAttach:attach(w, k, "backpack", 0.25, -0.12, sideOffset, -90, -180, 0)
				i=i+15
			end
		end
		-- ถ้าผู้เล่นมีชีวิตและไม่ได้อยู่ในรถ
		if info[k][1] and not info[k][2] then
			-- วนลูปตรวจสอบอาวุธทุก slot (1-7)
			for i=1,7 do
				local arma = getPedWeapon(k,i)
				-- ถ้าไม่ใช่อาวุธที่ถืออยู่ และยังไม่ได้สร้าง และอยู่ในรายการที่อนุญาต
				if arma~=wep and arma>0 and not jugadores[k][i] and allowedWeapons[arma] then
                    crearArma(k,arma)
                end
			end
		end
	end
end)