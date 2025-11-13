--[[ BackWeapons script By Gothem

	Feel free to use and change it as you want,
	obviously keeping the credit to the creator.--]]

local jugadores = {}
local lplayer = getLocalPlayer()
local info = {}
local sx,sy = guiGetScreenSize()

function crearArma(jug,arma)
	local model = obtenerObjeto(arma)
	if not model then return end -- ป้องกัน error หาก model เป็น nil
	local slot = getSlotFromWeapon(arma)
	jugadores[jug][slot] = createObject(model,0,0,0)
	setElementCollisionsEnabled(jugadores[jug][slot],false)
end

function destruirArma(jug,slot)
	-- ตรวจสอบให้แน่ใจว่า object ยังคงอยู่ก่อนที่จะทำลาย
	if isElement(jugadores[jug][slot]) then
		destroyElement(jugadores[jug][slot])
	end
	jugadores[jug][slot] = nil
end

addEventHandler("onClientResourceStart",getResourceRootElement(),function()
	for k,v in ipairs(getElementsByType("player",root,true)) do
		jugadores[v] = {}
		info[v] = {true,isPedInVehicle(v)}
	end
end,false)

addEventHandler("onClientPlayerQuit",root,function()
	if jugadores[source] and source ~= lplayer then
		for k,v in pairs(jugadores[source]) do
			if isElement(v) then -- เพิ่มการตรวจสอบก่อนทำลาย
				destroyElement(v)
			end
		end
		jugadores[source] = nil
		info[source] = nil
	end
end)

addEventHandler("onClientElementStreamIn",root,function()
	if getElementType(source) == "player" and source ~= lplayer then
		jugadores[source] = {}
		info[source] = {true,isPedInVehicle(source)}
	end
end)

addEventHandler("onClientElementStreamOut",root,function()
	if jugadores[source] and source ~= lplayer then
		for k,v in pairs(jugadores[source]) do
			if isElement(v) then -- เพิ่มการตรวจสอบก่อนทำลาย
				destroyElement(v)
			end
		end
		jugadores[source] = nil
		info[source] = nil
	end
end)

addEventHandler("onClientPlayerSpawn",root,function()
	if jugadores[source] then
		info[source][1] = true
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if jugadores[source] then
		for k,v in pairs(jugadores[source]) do
			destruirArma(source,k)
		end
		info[source][1] = false
	end
end)

addEventHandler("onClientPlayerVehicleEnter",root,function()
	if jugadores[source] then
		for k,v in pairs(jugadores[source]) do
			destruirArma(source,k)
		end
		info[source][2] = true
	end
end)

addEventHandler("onClientPlayerVehicleExit",root,function()
	if jugadores[source] then
		info[source][2] = false
	end
end)

addEventHandler("onClientPreRender",root,function()
	for k,v in pairs(jugadores) do
		-- [[
		--  * แก้ไข:
		--  * 1. ลบ 'goto' (ที่อาจไม่รองรับใน MTA 1.5)
		--  * 2. ใช้ 'if isElement(k) then' ครอบทั้งหมดแทน
		-- ]]
		if isElement(k) then
			local x,y,z = getPedBonePosition(k,3)
			local rot = math.rad(90-getPedRotation(k))
			local i = 15
			local wep = getPedWeaponSlot(k) -- 'wep' คือ Slot (เช่น 3)
			local ox,oy = math.cos(rot)*0.22,-math.sin(rot)*0.22
			local alpha = getElementAlpha(k)
			
			-- Loop ตรวจสอบ/ทำลาย/แสดงผล อาวุธที่มีอยู่
			for q,w in pairs(v) do
				-- ตรวจสอบว่าผู้เล่นยังมีอาวุธในช่องนั้น (q) หรือไม่
				local armaEnSlot = getPedWeapon(k, q) 
				
				-- (นี่คือส่วนที่แก้บัค 'takeWeapon')
				-- ถ้าผู้เล่นถืออาวุธช่องนั้นอยู่ (q == wep) 
				-- หรือ ผู้เล่นไม่มีอาวุธในช่องนั้นแล้ว (armaEnSlot == 0)
				-- ให้ทำลาย object ทิ้ง
				if q == wep or armaEnSlot == 0 then
					destruirArma(k,q)
				else
					-- แสดงผล Object ที่หลัง
					setElementRotation(w,0,70,getPedRotation(k)+90)
					setElementAlpha(w,alpha)
					if q==2 then
						local px,py,pz = getPedBonePosition(k,51)
						local qx,qy = math.sin(rot)*0.11,math.cos(rot)*0.11
						setElementPosition(w,px+qx,py+qy,pz)
					elseif q==4 then
						local px,py,pz = getPedBonePosition(k,41)
						local qx,qy = math.sin(rot)*0.06,math.cos(rot)*0.06
						setElementPosition(w,px-qx,py-qy,pz)
					else
						setElementPosition(w,x+ox,y+oy,z-0.2)
						setElementRotation(w,-17,-(50+i),getPedRotation(k))
						i=i+15
					end
				end
			end
			
			-- Loop สร้างอาวุธใหม่
			if info[k][1] and not info[k][2] then
				for i=1,7 do
					local arma = getPedWeapon(k,i) -- 'arma' คือ ID (เช่น 30)
					
					-- ========== แก้ไขบัคดั้งเดิมของสคริปต์ ==========
					-- เดิมทีมันเทียบ 'arma' (ID) กับ 'wep' (Slot)
					-- ที่ถูกต้องคือเทียบ 'i' (Slot) กับ 'wep' (Slot)
					if i ~= wep and arma > 0 and not jugadores[k][i] then
						crearArma(k,arma)
					end
					-- ==========================================
				end
			end
		
		else 
			-- ถ้า 'k' (ผู้เล่น) ไม่ valid แล้ว ให้ล้างข้อมูล (แทนที่ goto)
			if v then
				for slot, obj in pairs(v) do
					if isElement(obj) then
						destroyElement(obj)
					end
				end
			end
			jugadores[k] = nil
			info[k] = nil
		end -- สิ้นสุด if isElement(k)
	end -- สิ้นสุด for k,v
end)

function obtenerObjeto(arma)
	local m
	if arma > 1 and arma < 9 then
		m = 331 + arma
	elseif arma == 9 then
		m = 341
	elseif arma == 15 then
		m = 326
	elseif (arma > 21 and arma < 30) or (arma > 32 and arma < 39) or (arma > 40 and arma < 44) then
		m = 324 + arma
	elseif arma > 29 and arma < 32 then
		m = 325 + arma
	elseif arma == 32 then
		m = 372
	end
	return m
end